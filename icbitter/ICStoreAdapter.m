//
//  ICStoreAdapter.m
//  icbitter
//
//  Created by Gosha Arinich on 11/13/13.
//  Copyright (c) 2013 Gosha Arinich. All rights reserved.
//

#import "ICStoreAdapter.h"
#import "ICConnection.h"
#import "ICDataSource.h"
#import "ICBITBalance.h"
#import "ICBITInstrument.h"
#import "ICBITTrade.h"
#import "ICBITOrderbook.h"
#import "ICBITOrder.h"

@interface ICStoreAdapter ()

@property (strong, nonatomic) NSMutableDictionary *orderbookCache;
@property (strong, nonatomic) ICDataSource *dataSource;

@end

@implementation ICStoreAdapter

+ (id)sharedStoreAdapter {
    static ICStoreAdapter *_sharedStoreAdapter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedStoreAdapter = [[self alloc] init];
    });
    
    return _sharedStoreAdapter;
}

- (id)init {
    if (self = [super init]) {
        self.dataSource = ICDataSource.sharedSource;
    }
    
    return self;
}

- (void)purge {
    self.orderbookCache = NSMutableDictionary.dictionary;
    [self.dataSource purge];
}

#pragma mark - Data loaders

- (void)loadBalance:(NSArray *)data update:(BOOL)update {
    [self.dataSource deleteAllModelsOfType:@"balance"];
    
    for (NSDictionary *obj in data) {
        [self.dataSource insertDictionary:obj forType:@"balance"];
    }
    
    [NSNotificationCenter.defaultCenter postNotificationName:ICStoreBalancesNotification object:nil];
}

- (void)loadInstruments:(NSArray *)data update:(BOOL)update {
    if (!update) {
        [self.dataSource deleteAllModelsOfType:@"instrument"];
        
        for (NSDictionary *obj in data) {
            ICBITInstrument *instrument = [self.dataSource insertDictionary:obj forType:@"instrument"];
            [[ICConnection sharedConnection] subscribeTrades:instrument.ticker];
            [[ICConnection sharedConnection] subscribeOrderbook:instrument.ticker];
        }
    }
    
    [NSNotificationCenter.defaultCenter postNotificationName:ICStoreInstrumentsNotification
                                                      object:nil];
}

- (void)loadTrade:(NSDictionary *)data update:(BOOL)update {
    ICBITTrade *trade = [self.dataSource upsertDictionary:data forType:@"trade"];
    
    [NSNotificationCenter.defaultCenter postNotificationName:ICStoreTradesNotification
                                                      object:nil];
    [NSNotificationCenter.defaultCenter postNotificationName:[NSString stringWithFormat:ICStoreTradeNotification, trade.ticker]
                                                      object:nil];
}

- (void)loadOrderbook:(NSDictionary *)data update:(BOOL)update {
    NSString *ticker = data[@"s"];
    NSMutableDictionary *d = [NSMutableDictionary dictionaryWithDictionary:data];
    [d removeObjectForKey:@"ts"];
    
    if ([self.orderbookCache[ticker] isEqualToDictionary:d]) {
        return;
    }
    
    [self.dataSource deleteModelWithIdentifier:ticker ofType:@"orderbook"];
    [self.dataSource insertDictionary:data forType:@"orderbook"];
    
    [self.orderbookCache setObject:d forKey:ticker];
    
    [NSNotificationCenter.defaultCenter postNotificationName:ICStoreOrderbooksNotification
                                                      object:nil];
    [NSNotificationCenter.defaultCenter postNotificationName:[NSString stringWithFormat:ICStoreOrderbookNotification, ticker]
                                                      object:nil];
}

- (void)loadOrders:(NSArray *)data update:(BOOL)update {
    if (update) {
        for (NSDictionary *obj in data) {
            [self.dataSource upsertDictionary:obj forType:@"order"];
        }
    } else {
        [self.dataSource deleteAllModelsOfType:@"order"];
        
        for (NSDictionary *obj in data) {
            [self.dataSource insertDictionary:obj forType:@"order"];
        };
    }
    
    [NSNotificationCenter.defaultCenter postNotificationName:ICStoreOrdersNotification
                                                      object:nil];
}

@end
