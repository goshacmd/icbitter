//
//  ICBITCurrency.m
//  icbitter
//
//  Created by Gosha Arinich on 11/16/13.
//  Copyright (c) 2013 Gosha Arinich. All rights reserved.
//

#import "ICBITCurrency.h"

@implementation ICBITCurrency

+ (instancetype)currencyWithCurrencyType:(ICBITCurrencyType)type {
    return [[self alloc] initWithCurrencyType:type];
}

- (instancetype)initWithCurrencyType:(ICBITCurrencyType)type {
    if (self = [super init]) {
        _type = type;
    }
    
    return self;
}

- (BOOL)isUSD {
    return _type == ICBITCurrencyUSD;
}

- (BOOL)isBTC {
    return _type == ICBITCurrencyBTC;
}

- (NSDictionary *)currencyData {
    if (self.isUSD) {
        return @{
            @"code": @"USD",
            @"symbol": @"$",
            @"precision": @2
        };
    } else {
        return @{
            @"code": @"BTC",
            @"symbol": @"฿",
            @"precision": @8
        };
    }
}

- (NSString *)formatValue:(NSNumber *)value {
    static NSNumberFormatter *formatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSNumberFormatter alloc] init];
        formatter.numberStyle = NSNumberFormatterCurrencyStyle;
        
        NSDictionary *currencyData = self.currencyData;
        
        formatter.maximumFractionDigits = [currencyData[@"precision"] intValue];
        formatter.currencyCode = currencyData[@"code"];
        formatter.currencySymbol = currencyData[@"symbol"];
    });
    
    return [formatter stringFromNumber:value];
}

@end
