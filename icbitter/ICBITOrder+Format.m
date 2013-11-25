//
//  ICBITOrder+Format.m
//  icbitter
//
//  Created by Gosha Arinich on 11/25/13.
//  Copyright (c) 2013 Gosha Arinich. All rights reserved.
//

#import "ICBITOrder+Format.h"
#import "ICBITInstrument+Format.h"

@implementation ICBITOrder (Format)

- (NSString *)formattedPrice {
    return [self.instrument formatValue:self.price];
}

- (NSString *)formattedQuantity {
    return [self.instrument formattedQuantity:@(self.quantity)];
}

- (NSString *)humanDirection {
    if (self.type == ICBITOrderBuy) {
        return @"Buy";
    } else {
        return @"Sell";
    }
}

- (NSString *)humanStatus {
    switch (self.status) {
        case ICBITOrderNew:
            return @"New";
            break;
            
        case ICBITOrderPartiallyFilled:
            return @"Partially filled";
            break;
            
        case ICBITOrderFilled:
            return @"Filled";
            break;
            
        case ICBITOrderCanceled:
            return @"Canceled";
            break;
            
        case ICBITOrderRejected:
            return @"Rejected";
            break;
            
        default:
            break;
    }
}

@end
