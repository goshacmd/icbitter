//
//  ICSettingsViewController.h
//  icbitter
//
//  Created by Gosha Arinich on 11/12/13.
//  Copyright (c) 2013 Gosha Arinich. All rights reserved.
//

@interface ICSettingsViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UISwitch *hideUSD;

- (IBAction)signOut:(id)sender;
- (IBAction)toggleHideUSD:(id)sender;

@end
