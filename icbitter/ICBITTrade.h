//
//  ICBITTrade.h
//  icbitter
//
//  Created by Gosha Arinich on 11/15/13.
//  Copyright (c) 2013 Gosha Arinich. All rights reserved.
//

#import "ICBIT.h"
#import "ICModel.h"

@class ICBITInstrument;

@interface ICBITTrade : ICModel

@property (nonatomic) NSInteger ID;
@property (nonatomic) ICBITMarketType market;
@property (strong, nonatomic) NSNumber *openInterest;
@property (strong, nonatomic) NSNumber *price;
@property (nonatomic) NSInteger quantity;
@property (copy, nonatomic) NSString *ticker;
@property (strong, nonatomic) NSDate *timestamp;

- (ICBITInstrument *)instrument;

@end
