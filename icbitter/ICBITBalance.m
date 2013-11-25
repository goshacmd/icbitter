//
//  ICBITBalance.m
//  icbitter
//
//  Created by Gosha Arinich on 11/13/13.
//  Copyright (c) 2013 Gosha Arinich. All rights reserved.
//

#import "ICBITBalance.h"

@implementation ICBITBalance

+ (void)load {
    [ICModelManager registerModel:self forType:@"balance"];
}

- (void)updateFromDictionary:(NSDictionary *)data {
    self.type = [data[@"type"] intValue];
    self.currency = [ICBITCurrency currencyWithCurrencyType:[data[@"curid"] intValue]];
    self.name = data[@"name"];
    self.ticker = data[@"ticker"];
    
    self.identifier = self.ticker;
    
    self.qty = [data[@"qty"] integerValue];
    
    if (self.isMoney) {
        self.margin = data[@"margin"];
        self.unrealizedPL = data[@"upl"];
    } else if (self.isContract) {
        self.margin = data[@"mm"];
        self.unrealizedPL = data[@"vm"];
        
        self.inverted = [data[@"inverted"] intValue];
        
        self.tickSize = @([data[@"r"] floatValue]);
        self.lotSize = @([data[@"w"] floatValue]);
        self.execPrice = @([data[@"price"] floatValue] * self.tickSize.floatValue);
        
        self.amount = self.inverted ? @(1 / self.execPrice.floatValue * self.lotSize.floatValue * self.qty) : @(self.execPrice.floatValue * self.lotSize.floatValue * self.qty);
    }
}

#pragma mark - Predicates

- (BOOL)isMoney {
    return self.type == ICBITBalanceMoney;
}

- (BOOL)isContract {
    return self.type == ICBITBalanceContract;
}

- (BOOL)isUSD {
    return self.currency.isUSD;
}

- (BOOL)isBTC {
    return self.currency.isBTC;
}

#pragma mark - Computed values

- (NSNumber *)quantity {
    if (self.isContract) {
        return @(self.qty);
    } else {
        if (self.isUSD) {
            return @(self.qty / 100.0);
        } else if (self.isBTC) {
            return @(self.qty / 100000000.0);
        }
    }
    
    return @0;
}

- (NSNumber *)amountAvailable {
    return @(self.quantity.floatValue - self.margin.floatValue);
}

- (NSNumber *)netValue {
    return @(self.quantity.floatValue + self.unrealizedPL.floatValue);
}

- (NSNumber *)marginPercent {
    if ([self.netValue isEqualToNumber:@0]) {
        return self.netValue;
    }
    
    double maintenance = self.margin.floatValue * 0.75;
    NSNumber *marginPer = @((self.netValue.floatValue - maintenance) / self.netValue.floatValue);
    
    return marginPer;
}

#pragma mark -

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@ (%@) x %@ - margin: %@, tick size: %@, exec price: %@>", self.ticker, self.name, self.quantity, self.margin, self.tickSize, self.execPrice];
}

@end
