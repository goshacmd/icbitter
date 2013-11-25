//
//  ICOrderbookViewController.h
//  icbitter
//
//  Created by Gosha Arinich on 11/16/13.
//  Copyright (c) 2013 Gosha Arinich. All rights reserved.
//

#import "ICBITOrderbook.h"

@interface ICOrderbookViewController : UITableViewController

@property (weak, nonatomic) NSString *ticker;
@property (strong, nonatomic) ICBITOrderbook *orderbook;

@end
