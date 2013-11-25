//
//  ICSettingsManager.m
//  icbitter
//
//  Created by Gosha Arinich on 11/16/13.
//  Copyright (c) 2013 Gosha Arinich. All rights reserved.
//

#import "ICSettingsManager.h"

@implementation ICSettingsManager {
    NSUserDefaults *defaults;
    NSNotificationCenter *notificationCenter;
}

+ (instancetype)sharedManager {
    static ICSettingsManager *sharedManager = nil;
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

- (BOOL)hideUSD {
    return [[defaults objectForKey:@"hideUSD"] intValue];
}

- (void)setHideUSD:(BOOL)hide {
    [defaults setObject:@(hide) forKey:@"hideUSD"];
    [notificationCenter postNotificationName:ICSettingsHideUSDNotification object:nil];
}

@end
