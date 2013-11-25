//
//  ICOrdersViewController.m
//  icbitter
//
//  Created by Gosha Arinich on 11/17/13.
//  Copyright (c) 2013 Gosha Arinich. All rights reserved.
//

#import "ICOrdersViewController.h"
#import "ICDataSource.h"
#import "ICBITOrder+Format.h"
#import "NSArray+ICAdditions.h"
#import "ICOrderCell.h"

@interface ICOrdersViewController ()

- (void)ordersChanged:(NSNotification *)notification;
- (ICBITOrder *)orderForIndexPath:(NSIndexPath *)indexPath;

@end

@implementation ICOrdersViewController {
    NSArray *orderSectionTitles;
    NSArray *orderSections;
}

- (void)ordersChanged:(NSNotification *)notification {
    self.orders = [[[ICDataSource sharedSource] fetchModelsOfType:@"order"] dictionaryGroupedByKeyPath:@"ticker"];
    orderSectionTitles = [self.orders allKeys];
    orderSections = [self.orders allValues];
    
    [self.tableView reloadData];
}

- (ICBITOrder *)orderForIndexPath:(NSIndexPath *)indexPath {
    return orderSections[indexPath.section][indexPath.row];
}

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(ordersChanged:)
                                                 name:ICStoreOrdersNotification
                                               object:nil];
    
    [self ordersChanged:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UITableViewDelegate

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"Remove";
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return orderSectionTitles.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [orderSections[section] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return orderSectionTitles[section];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self orderForIndexPath:indexPath].canBeCanceled;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    ICBITOrder *order = [self orderForIndexPath:indexPath];
    
    if (editingStyle == UITableViewCellEditingStyleDelete && order.canBeCanceled) {
        [order cancel];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"OrderCell";
    
    ICOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[ICOrderCell alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:cellIdentifier];
    }
    
    ICBITOrder *order = [self orderForIndexPath:indexPath];
    
    cell.directionLabel.text = order.humanDirection;
    cell.statusLabel.text = order.humanStatus;
    cell.quantityLabel.text = order.formattedQuantity;
    cell.priceLabel.text = order.formattedPrice;
    
    return cell;
}

@end
