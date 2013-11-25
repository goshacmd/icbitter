//
//  ICSettingsViewController.h
//  icbitter
//
//  Created by Gosha Arinich on 11/12/13.
//  Copyright (c) 2013 Gosha Arinich. All rights reserved.
//

#import "ICSettingsViewController.h"
#import "ICLoginManager.h"
#import "ICSettingsManager.h"

@interface ICSettingsViewController ()

@end

@implementation ICSettingsViewController {
    ICSettingsManager *settings;
}

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    settings = [ICSettingsManager sharedManager];
    self.username.text = [[[ICLoginManager sharedManager] username] copy];
    self.hideUSD.on = settings.hideUSD;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction

- (IBAction)signOut:(id)sender {
    [[ICLoginManager sharedManager] signOut];
    [self.parentViewController.parentViewController performSegueWithIdentifier:@"login"
                                                   sender:self.parentViewController];
}

- (void)toggleHideUSD:(id)sender {
    settings.hideUSD = self.hideUSD.on;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) { // sign out button
        UIButton *button = [tableView cellForRowAtIndexPath:indexPath].contentView.subviews[0];
        [button sendActionsForControlEvents:UIControlEventTouchUpInside];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

@end
