//
//  ICBITInstrument.m
//  icbitter
//
//  Created by Gosha Arinich on 11/13/13.
//  Copyright (c) 2013 Gosha Arinich. All rights reserved.
//

#import "ICBITInstrument.h"

@implementation ICBITInstrument

+ (void)load {
    [ICModelManager registerModel:self forType:@"instrument"];
}

- (void)updateFromDictionary:(NSDictionary *)data {
    self.market = [data[@"market_id"] intValue];
    self.ticker = data[@"ticker"];
    
    self.identifier = self.ticker;
    
    self.name = data[@"name"];
    self.textDescription = data[@"desc"];
    self.currency = [ICBITCurrency currencyWithCurrencyType:[data[@"curid"] intValue]];
    self.tickSize = @([data[@"r"] floatValue]);
    self.lotSize = @([data[@"w"] floatValue]);
    self.marginBuy = @([data[@"im_buy"] intValue]);
    self.marginSell = @([data[@"im_sell"] intValue]);
    self.priceMin = [self floatPriceWithTick:data[@"price_min"]];
    self.priceMax = [self floatPriceWithTick:data[@"price_mmax"]];
    self.inverted = [data[@"inverted"] intValue];
    self.tradingFee = @([data[@"fee"] intValue]);
    self.clearingFee = @([data[@"clr_fee"] intValue]);
    self.sessionID = [data[@"session"] intValue];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    self.expiry = [formatter dateFromString:data[@"expiry"]];
}

- (NSArray *)trades {
    return [self.dataSource fetchModelsOfType:@"trade" matchingPredicate:[NSPredicate predicateWithFormat:@"ticker == %@", self.ticker]];
}

- (NSNumber *)floatPriceWithTick:(NSNumber *)price {
    return @(price.floatValue * self.tickSize.floatValue);
}

- (NSNumber *)precision {
    return @([[@(1 / [self.tickSize floatValue]) stringValue] length] - 1);
}

- (NSNumber *)marginForQuantity:(NSNumber *)quantity {
    return @(self.marginBuy.floatValue * quantity.intValue * 0.00000001);
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<Instrument %@ (%@), expiry: %@>", self.name, self.ticker, self.expiry];
}

@end
