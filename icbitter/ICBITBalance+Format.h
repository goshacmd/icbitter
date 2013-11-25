//
//  ICBITBalance+Format.h
//  icbitter
//
//  Created by Gosha Arinich on 11/25/13.
//  Copyright (c) 2013 Gosha Arinich. All rights reserved.
//

#import "ICBITBalance.h"

@interface ICBITBalance (Format)

- (NSString *)formatCurrency:(NSNumber *)value;
- (NSString *)formatValue:(NSNumber *)value;

// generic
- (NSString *)formattedAmount;
- (NSString *)formattedMargin;
- (NSString *)formattedPL;
- (NSString *)formattedQuantity;

// contract-only
- (NSString*)formattedExecPrice;

// currency-only
- (NSString *)formattedAmountAvailable;
- (NSString *)formattedNetValue;
- (NSString *)formattedMarginPercent;

@end
