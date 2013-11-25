//
//  ICBITTrade.m
//  icbitter
//
//  Created by Gosha Arinich on 11/15/13.
//  Copyright (c) 2013 Gosha Arinich. All rights reserved.
//

#import "ICBITTrade.h"
#import "ICBITInstrument.h"

@implementation ICBITTrade

+ (void)load {
    [ICModelManager registerModel:self forType:@"trade"];
}

- (void)updateFromDictionary:(NSDictionary *)data {
    self.ID = [data[@"tid"] intValue];
    self.identifier = @(self.ID);
    self.market = [data[@"market"] intValue];
    self.openInterest = @([data[@"oi"] intValue]);
    self.quantity = [data[@"qty"] intValue];
    self.ticker = data[@"ticker"];
    self.price = [self.instrument floatPriceWithTick:data[@"price"]];
    self.timestamp = [NSDate dateWithTimeIntervalSince1970:[data[@"ts"] intValue]];
}

- (ICBITInstrument *)instrument {
    return [self.dataSource fetchModelWithIdenitfier:self.ticker ofType:@"instrument"];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<Trade %@, %ld x %@ @ %@>", self.ticker, (long)self.quantity, self.price, self.timestamp];
}

@end
