//
//  ICBITOrderbookEntry.m
//  icbitter
//
//  Created by Gosha Arinich on 11/16/13.
//  Copyright (c) 2013 Gosha Arinich. All rights reserved.
//

#import "ICBITOrderbookEntry.h"
#import "ICBITOrderbook.h"

@implementation ICBITOrderbookEntry

+ (void)load {
    [ICModelManager registerModel:self forType:@"orderbookEntry"];
}

- (void)updateFromDictionary:(NSDictionary *)data {
    self.orderbook = [self.dataSource fetchModelWithIdenitfier:data[@"ticker"] ofType:@"orderbook"];
    self.price = [self.instrument floatPriceWithTick:data[@"p"]];
    self.quantity = [data[@"q"] intValue];
}

- (ICBITInstrument *)instrument {
    return self.orderbook.instrument;
}

- (BOOL)isInRange {
    return self.price >= self.instrument.priceMin && self.price <= self.instrument.priceMax;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<Entry %@ - %ld @ %@>", self.instrument.ticker, (long)self.quantity, self.price];
}

@end
