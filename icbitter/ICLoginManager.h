//
//  ICLoginManager.h
//  icbitter
//
//  Created by Gosha Arinich on 11/12/13.
//  Copyright (c) 2013 Gosha Arinich. All rights reserved.
//

typedef NS_ENUM(NSInteger, ICLoginManagerErrorCode) {
    ICLoginManagerEmptyCredentialsError = -10,
    ICLoginManagerInvalidCredentialsError = -11,
    ICLoginManagerAPIFetchError = -100
};

typedef void (^signInBlock)(NSError *error);


// A login manager is used to sign in & retrieve credentials.
@interface ICLoginManager : NSObject

+ (instancetype)sharedManager;

- (BOOL)isLoggedIn;
- (NSString *)apiKey;
- (NSString *)userId;
- (NSString *)username;
- (void)signInWithUsername:(NSString *)username password:(NSString *)password completion:(signInBlock)block;
- (void)signOut;

@end
