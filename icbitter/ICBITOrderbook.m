//
//  ICBITOrderbook.m
//  icbitter
//
//  Created by Gosha Arinich on 11/16/13.
//  Copyright (c) 2013 Gosha Arinich. All rights reserved.
//

#import "ICBITOrderbook.h"
#import "ICBITInstrument.h"
#import "ICBITOrderbookEntry.h"

@implementation ICBITOrderbook

+ (void)load {
    [ICModelManager registerModel:self forType:@"orderbook"];
}

- (void)updateFromDictionary:(NSDictionary *)data {
    self.ticker = data[@"s"];
    self.identifier = self.ticker;
    
    self.buys = [NSMutableArray array];
    self.sells = [NSMutableArray array];
    self.timestamp = [NSDate dateWithTimeIntervalSince1970:[data[@"ts"] intValue]];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSSortDescriptor *priceDesc = [NSSortDescriptor sortDescriptorWithKey:@"price" ascending:NO];
        
        for (id obj in data[@"buy"]) {
            NSMutableDictionary *data = [NSMutableDictionary dictionaryWithDictionary:obj];
            [data setObject:self.ticker forKey:@"ticker"];
            ICBITOrderbookEntry *entry = [self.dataSource materializeDictionary:data forType:@"orderbookEntry"];
            entry.type = ICBITOrderbookEntryBuy;
            [self.buys addObject:entry];
        }
        
        [self.buys sortUsingDescriptors:@[priceDesc]];
        
        for (id obj in data[@"buy"]) {
            NSMutableDictionary *data = [NSMutableDictionary dictionaryWithDictionary:obj];
            [data setObject:self.ticker forKey:@"ticker"];
            ICBITOrderbookEntry *entry = [self.dataSource materializeDictionary:data forType:@"orderbookEntry"];
            entry.type = ICBITOrderbookEntrySell;
            [self.sells addObject:entry];
        }
        
        [self.sells sortUsingDescriptors:@[priceDesc]];
    });
}

- (ICBITInstrument *)instrument {
    return [self.dataSource fetchModelWithIdenitfier:self.ticker ofType:@"instrument"];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<Orderbook %@>", self.ticker];
}

@end
