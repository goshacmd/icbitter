//
//  ICBITOrder.m
//  icbitter
//
//  Created by Gosha Arinich on 11/13/13.
//  Copyright (c) 2013 Gosha Arinich. All rights reserved.
//

#import "ICBITOrder.h"
#import "ICConnection.h"

@implementation ICBITOrder

+ (void)load {
    [ICModelManager registerModel:self forType:@"order"];
}

- (void)updateFromDictionary:(NSDictionary *)data {
    self.ID = [data[@"oid"] intValue];
    self.identifier = @(self.ID);
    self.date = [NSDate dateWithTimeIntervalSince1970:[data[@"date"] intValue]];
    self.direction = [data[@"dir"] intValue];
    self.type = [data[@"type"] intValue];
    self.ticker = data[@"ticker"];
    self.price = [self.instrument floatPriceWithTick:data[@"price"]];
    self.quantity = [data[@"qty"] intValue];
    self.execQuantity = [data[@"qty"] intValue];
    self.status = [data[@"status"] intValue];
    self.token = data[@"token"];
    self.currency = data[@"currency"];
    self.market = [data[@"market"] intValue];
    self.fills = [data[@"fills"] copy];
}

- (ICBITInstrument *)instrument {
    return [self.dataSource fetchModelWithIdenitfier:self.ticker ofType:@"instrument"];
}

#pragma mark - Predicates

- (BOOL)isNew {
    return self.status == ICBITOrderNew;
}

- (BOOL)isPartiallyFilled {
    return self.status == ICBITOrderPartiallyFilled;
}

- (BOOL)isFilled {
    return self.status == ICBITOrderFilled;
}

- (BOOL)isCanceled {
    return self.status == ICBITOrderCanceled;
}

- (BOOL)isRejected {
    return self.status == ICBITOrderRejected;
}

- (BOOL)canBeCanceled {
    return self.isNew || self.isPartiallyFilled;
}

#pragma mark - Actions

- (void)cancel {
    if (self.canBeCanceled) {
        [ICConnection.sharedConnection cancelOrder:self.identifier market:@(self.market)];
    }
}

#pragma mark -

- (NSString *)description {
    return [NSString stringWithFormat:@"<Order %@ - %ld x %@ (%ld)>", self.ticker, (long)self.quantity, self.price, self.status];
}

@end
