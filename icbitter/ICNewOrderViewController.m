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
    
    [self.quantity becomeFirstResponder];
}

#pragma mark - IBAction

- (void)cancel:(id)sender {
    [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
