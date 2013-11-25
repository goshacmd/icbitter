//
//  ICNewOrderViewController.h
//  icbitter
//
//  Created by Gosha Arinich on 11/16/13.
//  Copyright (c) 2013 Gosha Arinich. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>

@class ICBITInstrument;

@interface ICNewOrderViewController : UITableViewController

@property (weak, nonatomic) NSString *ticker;
@property (strong, nonatomic) ICBITInstrument *instrument;
@property (weak, nonatomic) IBOutlet UITextField *quantity;
@property (weak, nonatomic) IBOutlet UITextField *price;
@property (weak, nonatomic) IBOutlet UITableViewCell *initialMargin;

- (IBAction)cancel:(id)sender;

@end
