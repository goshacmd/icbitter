//
//  ICBITInstrument+Format.m
//  icbitter
//
//  Created by Gosha Arinich on 11/25/13.
//  Copyright (c) 2013 Gosha Arinich. All rights reserved.
//

#import "ICBITInstrument+Format.h"
#import "ICFormatter.h"

@implementation ICBITInstrument (Format)

- (NSString *)formatValue:(NSNumber *)value {
    static NSNumberFormatter *formatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSNumberFormatter alloc] init];
        formatter.numberStyle = NSNumberFormatterCurrencyStyle;
        
        formatter.maximumFractionDigits = self.precision.intValue;
        formatter.currencyCode = @"";
        formatter.currencySymbol = @"";
    });
    
    return [formatter stringFromNumber:value];
}

- (NSString *)formattedQuantity:(NSNumber *)quantity {
    return [ICFormatter.quantityFormatter stringFromNumber:quantity];
}

- (NSString *)formattedMarginForQuantity:(NSNumber *)quantity {
    return [ICFormatter.decimalFormatter stringFromNumber:[self marginForQuantity:quantity]];
}

@end
