//
//  ICOrderbookViewController.m
//  icbitter
//
//  Created by Gosha Arinich on 11/16/13.
//  Copyright (c) 2013 Gosha Arinich. All rights reserved.
//

#import "ICOrderbookViewController.h"
#import "ICDataSource.h"
#import "ICBITOrderbookEntry+Format.h"
#import "ICOrderbookEntryCell.h"

@interface ICOrderbookViewController ()

- (void)orderbookChanged:(NSNotification *)notification;

@end

@implementation ICOrderbookViewController

- (void)orderbookChanged:(NSNotification *)notification {
    self.orderbook = [[ICDataSource sharedSource] fetchModelOfType:@"orderbook" matchingPredicate:[NSPredicate predicateWithFormat:@"ticker == %@", self.ticker]];
    
    [self.tableView reloadData];
}

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(orderbookChanged:)
                                                 name:ICStoreOrderbooksNotification
                                               object:nil];
    
    [self orderbookChanged:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UINavigationController *navigationController = segue.destinationViewController;
    id newOrderController = navigationController.topViewController;
    [newOrderController setTicker:self.ticker];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.orderbook.sells.count;
    } else {
        return self.orderbook.buys.count;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if ([self tableView:tableView numberOfRowsInSection:section] == 0) {
        return nil;
    }
    
    return [@[ @"Sell", @"Buy" ] objectAtIndex:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"EntryCell";
    
    ICOrderbookEntryCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[ICOrderbookEntryCell alloc] initWithStyle:UITableViewCellStyleDefault
                                           reuseIdentifier:cellIdentifier];
    }
    
    NSArray *entries = indexPath.section == 0 ? self.orderbook.sells : self.orderbook.buys;
    ICBITOrderbookEntry *entry = entries[indexPath.row];
    
    cell.priceLabel.text = entry.formattedPrice;
    
    if (indexPath.section == 0) {
        cell.leftQuantityLabel.text = entry.formattedQuantity;
        cell.rightQuantityLabel.text = @"";
    } else {
        cell.rightQuantityLabel.text = entry.formattedQuantity;
        cell.leftQuantityLabel.text = @"";
    }
    
    return cell;
}


@end
