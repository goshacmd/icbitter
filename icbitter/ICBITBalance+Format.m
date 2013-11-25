//
//  ICBITBalance+Format.m
//  icbitter
//
//  Created by Gosha Arinich on 11/25/13.
//  Copyright (c) 2013 Gosha Arinich. All rights reserved.
//

#import "ICBITBalance+Format.h"
#import "ICFormatter.h"

@implementation ICBITBalance (Format)

- (NSString *)formatCurrency:(NSNumber *)value {
    return [self.currency formatValue:value];
}

- (NSString *)formatValue:(NSNumber *)value {
    return [ICFormatter.decimalFormatter stringFromNumber:value];
}

- (NSString *)formattedAmount {
    if (self.isMoney) {
        return [self formatCurrency:self.quantity];
    } else {
        return [self formatCurrency:self.amount];
    }
}

- (NSString *)formattedMargin {
    return [self formatCurrency:self.margin];
}

- (NSString *)formattedPL {
    return [self formatCurrency:self.unrealizedPL];
}

- (NSString *)formattedAmountAvailable {
    return [self formatCurrency:self.amountAvailable];
}

- (NSString *)formattedNetValue {
    return [self formatCurrency:self.netValue];
}

- (NSString *)formattedExecPrice {
    return [self formatValue:self.execPrice];
}

- (NSString *)formattedMarginPercent {
    return [ICFormatter.percentFormatter stringFromNumber:self.marginPercent];
}

- (NSString *)formattedQuantity {
    return [ICFormatter.quantityFormatter stringFromNumber:self.quantity];
}

@end
