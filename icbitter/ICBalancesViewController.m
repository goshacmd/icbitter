//
//  ICBalancesViewController.m
//  icbitter
//
//  Created by Gosha Arinich on 11/13/13.
//  Copyright (c) 2013 Gosha Arinich. All rights reserved.
//

#import "ICBalancesViewController.h"
#import "ICConnection.h"
#import "ICDataSource.h"
#import "ICBITBalance+Format.h"
#import "ICSettingsManager.h"
#import "ICCurrencyBalanceCell.h"
#import "ICContractBalanceCell.h"

typedef enum {
    kCurrenciesSection,
    kContractsSection
} Sections;

@interface ICBalancesViewController ()

- (void)balancesChanged:(NSNotification *)notification;
- (NSArray *)balancesForSection:(NSInteger)section;
- (NSString *)cellIdForIndexPath:(NSIndexPath *)indexPath;

@end

@implementation ICBalancesViewController

- (void)balancesChanged:(NSNotification *)notification {
    [self.tableView reloadData];
}

- (NSArray *)balancesForSection:(NSInteger)section {
    NSArray *balances = [ICDataSource.sharedSource fetchModelsOfType:@"balance"];
    if (section == kCurrenciesSection) {
        if (ICSettingsManager.sharedManager.hideUSD) {
            return [balances filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"isMoney == true && ticker != 'USD'"]];
        } else {
            return [balances filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"isMoney == true"]];
        }
    } else {
        return [balances filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"isContract == true"]];
    }
}

- (NSString *)cellIdForIndexPath:(NSIndexPath *)indexPath {
    static NSArray *cells;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cells = @[ @"CurrencyBalanceCell", @"ContractBalanceCell" ];
    });
    
    return [cells objectAtIndex:indexPath.section];
}

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(balancesChanged:)
                                                 name:ICStoreBalancesNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(balancesChanged:)
                                                 name:ICSettingsHideUSDNotification
                                               object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - IBAction

- (void)refresh:(id)sender {
    [ICConnection.sharedConnection fetchBalance];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ((UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:[self cellIdForIndexPath:indexPath]]).bounds.size.height;
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2; // "Currencies" and "Contracts"
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if ([self tableView:tableView numberOfRowsInSection:section] == 0) {
        return nil;
    }
    
    return [@[ @"Currencies", @"Contracts" ] objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self balancesForSection:section] count];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = [self cellIdForIndexPath:indexPath];
    
    UITableViewCell *bCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (bCell == nil) {
        bCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:cellIdentifier];
    }
    
    ICBITBalance *balance = [self balancesForSection:indexPath.section][indexPath.row];
    
    if (indexPath.section == kCurrenciesSection) {
        ICCurrencyBalanceCell *cell = (ICCurrencyBalanceCell *)bCell;
        
        cell.amountLabel.text = balance.formattedAmount;
        cell.availableLabel.text = balance.formattedAmountAvailable;
        cell.netValueLabel.text = balance.formattedNetValue;
        cell.marginPercentLabel.text = balance.formattedMarginPercent;
        
        return cell;
    } else if (indexPath.section == kContractsSection) {
        ICContractBalanceCell *cell = (ICContractBalanceCell *)bCell;
        
        cell.nameLabel.text = balance.name;
        cell.quantityLabel.text = balance.formattedQuantity;
        cell.unrealizedPLLabel.text = balance.formattedPL;
        
        switch ([balance.unrealizedPL compare:@0]) {
            case NSOrderedAscending: {
                // loss
                cell.unrealizedPLLabel.textColor = [UIColor colorWithRed:.94 green:.32 blue:.18 alpha:1];
                break;
            }
                
            case NSOrderedDescending: {
                // loss
                cell.unrealizedPLLabel.textColor = [UIColor colorWithRed:.37 green:.82 blue:0 alpha:1];
                break;
            }
                
            default: {
                break;
            }
        }
        
        cell.initialMarginLabel.text = balance.formattedMargin;
        cell.execPriceLabel.text = balance.formattedExecPrice;
        cell.amountLabel.text = balance.formattedAmount;
        
        return cell;
    }
    
    return bCell;
}

@end
