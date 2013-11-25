//
//  ICLoginManager.m
//  icbitter
//
//  Created by Gosha Arinich on 11/12/13.
//  Copyright (c) 2013 Gosha Arinich. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "ICLoginManager.h"

@interface ICLoginManager ()

- (void)storeApiKey:(NSString *)apiKey andUserId:(NSString *)userId andUsername:(NSString *)username;
- (void)clearWebData;

@end

@implementation ICLoginManager {
    NSUserDefaults *defaults;
    NSNotificationCenter *notificationCenter;
}

+ (instancetype)sharedManager {
    static ICLoginManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    
    return sharedManager;
}

- (id)init {
    if (self = [super init]) {
        defaults = NSUserDefaults.standardUserDefaults;
        notificationCenter = NSNotificationCenter.defaultCenter;
    }
    
    return self;
}

#pragma mark - Queries

- (NSString *)apiKey {
    return [defaults objectForKey:@"apiKey"];
}

- (NSString *)userId {
    return [defaults objectForKey:@"userId"];
}

- (NSString *)username {
    return [defaults objectForKey:@"username"];
}

- (BOOL)isLoggedIn {
    return [self apiKey] && [self userId];
}

#pragma mark - Actions

- (void)signInWithUsername:(NSString *)username password:(NSString *)password completion:(signInBlock)block {
    NSDictionary *errorCodes = @{
      @(ICLoginManagerEmptyCredentialsError): @{
          NSLocalizedDescriptionKey: @"Sign in unsuccessful",
          NSLocalizedFailureReasonErrorKey: @"Empty credentials"
      },
      @(ICLoginManagerInvalidCredentialsError): @{
          NSLocalizedDescriptionKey: @"Sign in unsuccessful",
          NSLocalizedFailureReasonErrorKey: @"Invalid credentials"
      },
      @(ICLoginManagerAPIFetchError): @{
          NSLocalizedDescriptionKey: @"Sign in unsuccessful",
          NSLocalizedFailureReasonErrorKey: @"Can't fetch API key"
      },
    };
    
    void (^doError)(ICLoginManagerErrorCode) = ^void(ICLoginManagerErrorCode code) {
        NSError *error = [NSError errorWithDomain:ICLoginErrorDomain
                                             code:code
                                         userInfo:errorCodes[@(code)]];
        block(error);
    };
    
    
    if ([username isEqualToString:@""] || [password isEqualToString:@""]) {
        doError(ICLoginManagerEmptyCredentialsError);
        return;
    }
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:ICBITBaseUrl]];
    manager.requestSerializer = AFHTTPRequestSerializer.serializer;
    manager.responseSerializer = AFHTTPResponseSerializer.serializer;

    NSDictionary *params = @{
        @"form_id": @"user_login",
        @"name": username,
        @"pass": password
    };
    
    [self clearWebData];
    
    [manager POST:@"/user" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [manager GET:@"/WebTrade/Account/API.aspx" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSString *text = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            
            NSError *error = NULL;
            NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"AuthKey=(\\w+)&UserId=(\\d+)"
                                                                                   options:NSRegularExpressionCaseInsensitive
                                                                                     error:&error];
            
            if ([regex numberOfMatchesInString:text options:0 range:NSMakeRange(0, text.length)] == 0) {
                doError(ICLoginManagerInvalidCredentialsError);
                return;
            }
            
            [regex enumerateMatchesInString:text
                                    options:0
                                      range:NSMakeRange(0, text.length)
                                 usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                NSString *apiKey = [text substringWithRange:[result rangeAtIndex:1]];
                NSString *userId = [text substringWithRange:[result rangeAtIndex:2]];
                
                NSLog(@"API credentials: %@, %@", apiKey, userId);
                
                [self storeApiKey:apiKey andUserId:userId andUsername:username];
                block(NULL);
            }];
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            doError(ICLoginManagerAPIFetchError);
        }];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        doError(ICLoginManagerAPIFetchError);
    }];
}

- (void)clearWebData {
    [NSURLCache.sharedURLCache removeAllCachedResponses];
    NSHTTPCookieStorage *cookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage;
    
    for (NSHTTPCookie *cookie in cookieStorage.cookies) {
        [cookieStorage deleteCookie:cookie];
    }
}

- (void)storeApiKey:(NSString *)apiKey andUserId:(NSString *)userId andUsername:(NSString *)username {
    [defaults setValuesForKeysWithDictionary:@{ @"apiKey": apiKey, @"userId": userId, @"username": username }];
    [notificationCenter postNotificationName:ICLoginSignInNotification object:nil];
}

- (void)signOut {
    [defaults removeObjectForKey:@"apiKey"];
    [defaults removeObjectForKey:@"userId"];
    [defaults removeObjectForKey:@"username"];
    [defaults synchronize];
    [notificationCenter postNotificationName:ICLoginSignOutNotification object:nil];
}

@end
