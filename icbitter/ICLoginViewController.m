//
//  ICLoginViewController.m
//  icbitter
//
//  Created by Gosha Arinich on 11/12/13.
//  Copyright (c) 2013 Gosha Arinich. All rights reserved.
//

#import "ICLoginViewController.h"
#import "ICLoginManager.h"

@interface ICLoginViewController()

- (void)disableInputs;
- (void)enableInputs;

@end

@implementation ICLoginViewController


#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.username becomeFirstResponder];
    self.error.hidden = YES;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.username) {
        [self.password becomeFirstResponder];
    } else if (textField == self.password) {
        [self login:nil];
    }
    
    return YES;
}

#pragma mark - IBAction

- (IBAction)login:(id)sender {
    NSString *username = self.username.text;
    NSString *password = self.password.text;
    
    ICLoginManager *loginManager = [ICLoginManager sharedManager];
    
    [self disableInputs];
    
    [loginManager signInWithUsername:username
                            password:password
                          completion:^(NSError *error) {
        [self enableInputs];
        
        if (error) {
            NSLog(@"Error: %@", error);
            
            NSDictionary *dict = error.userInfo;
            NSString *errorText = [@[ dict[NSLocalizedDescriptionKey], dict[NSLocalizedFailureReasonErrorKey] ] componentsJoinedByString:@" - "];
            
            self.error.text = errorText;
            self.error.hidden = NO;
            
            [self.username becomeFirstResponder];
        } else {
            self.error.hidden = YES;
            NSLog(@"Login successful");
            
            [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
        }
    }];
}

#pragma mark - Stuff

- (void)disableInputs {
    self.username.enabled = NO;
    self.username.textColor = [UIColor lightGrayColor];
    self.password.enabled = NO;
    self.password.textColor = [UIColor lightGrayColor];
    self.button.enabled = NO;
}

- (void)enableInputs {
    self.username.enabled = YES;
    self.username.textColor = self.username.defaultTextAttributes[@"textColor"];
    self.password.enabled = YES;
    self.password.textColor = self.password.defaultTextAttributes[@"textColor"];
    self.button.enabled = YES;
}

@end
