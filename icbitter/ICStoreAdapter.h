//
//  ICStoreAdapter.h
//  icbitter
//
//  Created by Gosha Arinich on 11/13/13.
//  Copyright (c) 2013 Gosha Arinich. All rights reserved.
//

// An adapter used as a bridge between websocket messages and data source.
@interface ICStoreAdapter : NSObject

+ (id)sharedStoreAdapter;

- (void)loadBalance:(NSArray *)data update:(BOOL)update;
- (void)loadInstruments:(NSArray *)data update:(BOOL)update;
- (void)loadTrade:(NSDictionary *)data update:(BOOL)update;
- (void)loadOrderbook:(NSDictionary *)data update:(BOOL)update;
- (void)loadOrders:(NSArray *)data update:(BOOL)update;

- (void)purge;

@end
