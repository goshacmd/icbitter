//
//  ICTabBarController.m
//  icbitter
//
//  Created by Gosha Arinich on 11/12/13.
//  Copyright (c) 2013 Gosha Arinich. All rights reserved.
//

#import "ICTabBarController.h"
#import "ICLoginManager.h"
#import "ICConnection.h"

@implementation ICTabBarController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    ICLoginManager *loginManager = [ICLoginManager sharedManager];
    
    if ([loginManager isLoggedIn]) {
        NSLog(@"There is a key: %@, %@", loginManager.apiKey, loginManager.userId);
        ICConnection *connection = [ICConnection sharedConnection];
        [connection connect];
    } else {
        NSLog(@"No key");
        [self performSegueWithIdentifier:@"login" sender:self];
    }
}

@end
