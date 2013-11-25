//
//  ICBITOrder.h
//  icbitter
//
//  Created by Gosha Arinich on 11/13/13.
//  Copyright (c) 2013 Gosha Arinich. All rights reserved.
//

#import "ICModel.h"
#import "ICBIT.h"
#import "ICBITInstrument.h"

typedef NS_ENUM(NSInteger, ICBITOrderDirection) {
    ICBITOrderBuy,
    ICBITOrderSell
};

typedef NS_ENUM(NSInteger, ICBITOrderType) {
    ICBITOrderLMT
};

typedef NS_ENUM(NSInteger, ICBITOrderStatus) {
    ICBITOrderNew,
    ICBITOrderPartiallyFilled,
    ICBITOrderFilled,
    ICBITOrderCanceled = 4,
    ICBITOrderRejected
};

@interface ICBITOrder : ICModel

@property (nonatomic) NSUInteger ID;
@property (strong, nonatomic) NSDate *date;
@property (nonatomic) ICBITOrderDirection direction;
@property (nonatomic) ICBITOrderType type;
@property (strong, nonatomic) NSNumber *price;
@property (nonatomic) NSInteger quantity;
@property (nonatomic) NSInteger execQuantity;
@property (nonatomic) ICBITOrderStatus status;
@property (copy, nonatomic) NSString *ticker;
@property (copy, nonatomic) NSString *token;
@property (copy, nonatomic) NSString *currency;
@property (nonatomic) ICBITMarketType market;
@property (strong, nonatomic) NSArray *fills;

- (ICBITInstrument *)instrument;

- (BOOL)isNew;
- (BOOL)isPartiallyFilled;
- (BOOL)isFilled;
- (BOOL)isCanceled;
- (BOOL)isRejected;

- (BOOL)canBeCanceled;

- (void)cancel;

@end
