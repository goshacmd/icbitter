//
//  ICBITTrade+Format.m
//  icbitter
//
//  Created by Gosha Arinich on 11/25/13.
//  Copyright (c) 2013 Gosha Arinich. All rights reserved.
//

#import "ICBITTrade+Format.h"
#import "ICBITInstrument+Format.h"
#import "ICFormatter.h"

@implementation ICBITTrade (Format)

- (NSString *)formattedPrice {
    return [self.instrument formatValue:self.price];
}

- (NSString *)formattedQuantity {
    return [self.instrument formattedQuantity:@(self.quantity)];
}

- (NSString *)formattedTimestamp {
    return [ICFormatter.timeFormatter stringFromDate:self.timestamp];
}

@end
