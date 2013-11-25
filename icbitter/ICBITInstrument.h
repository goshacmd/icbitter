//
//  ICBITInstrument.h
//  icbitter
//
//  Created by Gosha Arinich on 11/13/13.
//  Copyright (c) 2013 Gosha Arinich. All rights reserved.
//

#import "ICBIT.h"
#import "ICModel.h"
#import "ICBITTrade.h"
#import "ICBITCurrency.h"

@interface ICBITInstrument : ICModel

@property (nonatomic) ICBITMarketType market;
@property (copy, nonatomic) NSString *ticker;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *textDescription;
@property (strong, nonatomic) ICBITCurrency *currency;
@property (strong, nonatomic) NSNumber *marginBuy;
@property (strong, nonatomic) NSNumber *marginSell;
@property (strong, nonatomic) NSNumber *priceMin;
@property (strong, nonatomic) NSNumber *priceMax;
@property (nonatomic) BOOL inverted;
@property (strong, nonatomic) NSNumber *tradingFee;
@property (strong, nonatomic) NSNumber *clearingFee;
@property (nonatomic) NSInteger sessionID;
@property (strong, nonatomic) NSDate *expiry;
@property (strong, nonatomic) NSNumber *tickSize;
@property (strong, nonatomic) NSNumber *lotSize;

- (NSArray *)trades;
- (NSNumber *)floatPriceWithTick:(NSNumber *)price;
- (NSNumber *)precision;
- (NSNumber *)marginForQuantity:(NSNumber *)quantity;

@end
