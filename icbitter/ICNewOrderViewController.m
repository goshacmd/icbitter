//
//  ICNewOrderViewController.m
//  icbitter
//
//  Created by Gosha Arinich on 11/16/13.
//  Copyright (c) 2013 Gosha Arinich. All rights reserved.
//

#import "ICNewOrderViewController.h"
#import "ICDataSource.h"
#import "ICBITInstrument+Format.h"

enum {
    kOrderDataSection,
    kOrderTypeSection
};

enum {
    kOrderTypeBuy,
    kOrderTypeSell
};

@implementation ICNewOrderViewController

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.instrument = [ICDataSource.sharedSource fetchModelWithIdenitfier:self.ticker ofType:@"instrument"];
    
    RACSignal *initialMarginText = [RACSignal
        combineLatest:@[ self.quantity.rac_textSignal ]
        reduce:^(NSNumber *quantity) {
            return [self.instrument formattedMarginForQuantity:quantity];
        }];
    
    RAC(self.initialMargin.detailTextLabel, text) = initialMarginText;
    
    if (self.initialPrice) {
        self.price.text = self.initialPrice;
    }
    
    [self.quantity becomeFirstResponder];
}

#pragma mark - IBAction

- (void)cancel:(id)sender {
    [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)placeOrder:(id)sender {
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    
    if (indexPath.section == kOrderTypeSection) {
        cell.accessoryType = indexPath.row == self.typeSelection ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case kOrderTypeSection: {
            _typeSelection = indexPath.row;
            break;
        }
            
        default: {
            break;
        }
    }
    
    [tableView reloadData];
    [self.quantity becomeFirstResponder];
}

@end
