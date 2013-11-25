//
//  ICLoginViewController.h
//  icbitter
//
//  Created by Gosha Arinich on 11/12/13.
//  Copyright (c) 2013 Gosha Arinich. All rights reserved.
//

@interface ICLoginViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UILabel *error;

- (IBAction)login:(id)sender;

@end
