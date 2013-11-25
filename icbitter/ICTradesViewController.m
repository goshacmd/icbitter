//
//  ICTradesViewController.m
//  icbitter
//
//  Created by Gosha Arinich on 11/15/13.
//  Copyright (c) 2013 Gosha Arinich. All rights reserved.
//

#import "ICTradesViewController.h"
#import "ICDataSource.h"
#import "ICBITTrade+Format.h"
#import "ICTradeCell.h"

@interface ICTradesViewController ()

- (void)tradesChanged:(NSNotification *)notification;

@end

@implementation ICTradesViewController

- (void)tradesChanged:(NSNotification *)notification {
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:NO];
    self.trades = [[ICDataSource.sharedSource fetchModelsOfType:@"trade" matchingPredicate:[NSPredicate predicateWithFormat:@"ticker == %@", self.ticker]] sortedArrayUsingDescriptors:@[sortDescriptor]];
    
    [self.tableView reloadData];
}

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(tradesChanged:)
                                                 name:ICStoreTradesNotification
                                               object:nil];
    
    [self tradesChanged:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.trades count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"TradeCell";
    
    ICTradeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = (ICTradeCell *)[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                     reuseIdentifier:cellIdentifier];
    }
    
    ICBITTrade *trade = self.trades[indexPath.row];
    
    cell.priceLabel.text = trade.formattedPrice;
    cell.quantityLabel.text = trade.formattedQuantity;
    cell.timeLabel.text = trade.formattedTimestamp;
    
    return cell;
}

@end
