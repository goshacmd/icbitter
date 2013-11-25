//
//  ICBITCurrency.h
//  icbitter
//
//  Created by Gosha Arinich on 11/16/13.
//  Copyright (c) 2013 Gosha Arinich. All rights reserved.
//

#import "ICBIT.h"

@interface ICBITCurrency : NSObject

@property (nonatomic, readonly) ICBITCurrencyType type;

+ (instancetype)currencyWithCurrencyType:(ICBITCurrencyType)type;
- (instancetype)initWithCurrencyType:(ICBITCurrencyType)type;

- (BOOL)isUSD;
- (BOOL)isBTC;
- (NSDictionary *)currencyData;
- (NSString *)formatValue:(NSNumber *)value;

@end
