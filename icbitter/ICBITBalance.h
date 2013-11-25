//
//  ICBITBalance.h
//  icbitter
//
//  Created by Gosha Arinich on 11/13/13.
//  Copyright (c) 2013 Gosha Arinich. All rights reserved.
//

#import "ICBIT.h"
#import "ICModel.h"
#import "ICBITCurrency.h"

typedef NS_ENUM(NSInteger, ICBITBalanceType) {
    ICBITBalanceMoney,
    ICBITBalanceContract
};

@interface ICBITBalance : ICModel

// used by both money & contract balances
@property (nonatomic) ICBITBalanceType type;
@property (strong, nonatomic) ICBITCurrency *currency;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *ticker;
@property (nonatomic) NSUInteger qty;
@property (strong, nonatomic) NSNumber *margin; // initial margin for contracts
@property (strong, nonatomic) NSNumber *unrealizedPL; // "upl" for money, "vm" for contracts

// used exclusively by contract balances
@property (nonatomic) BOOL inverted;
@property (strong, nonatomic) NSNumber *amount;
@property (strong, nonatomic) NSNumber *tickSize;
@property (strong, nonatomic) NSNumber *lotSize;
@property (strong, nonatomic) NSNumber *execPrice;

- (BOOL)isMoney;
- (BOOL)isContract;
- (BOOL)isUSD;
- (BOOL)isBTC;
- (NSNumber *)quantity;

// currency-only
- (NSNumber *)amountAvailable;
- (NSNumber *)netValue;
- (NSNumber *)marginPercent;

@end
