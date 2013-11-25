//
//  ICTradesViewController.h
//  icbitter
//
//  Created by Gosha Arinich on 11/15/13.
//  Copyright (c) 2013 Gosha Arinich. All rights reserved.
//

@interface ICTradesViewController : UITableViewController

@property (weak, nonatomic) NSString *ticker;
@property (strong, nonatomic) NSArray *trades;

@end
