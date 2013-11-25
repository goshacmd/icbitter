//
//  ICBITOrderbookEntry.h
//  icbitter
//
//  Created by Gosha Arinich on 11/16/13.
//  Copyright (c) 2013 Gosha Arinich. All rights reserved.
//

#import "ICModel.h"
#import "ICBITInstrument.h"

@class ICBITOrderbook;

typedef enum {
    ICBITOrderbookEntryBuy,
    ICBITOrderbookEntrySell
} ICBITOrderbookEntryType;

@interface ICBITOrderbookEntry : ICModel

@property (nonatomic) ICBITOrderbookEntryType type;
@property (weak, nonatomic) ICBITOrderbook *orderbook;
@property (strong, atomic) NSNumber *price;
@property (nonatomic) NSInteger quantity;

- (ICBITInstrument *)instrument;
- (BOOL)isInRange;

@end
