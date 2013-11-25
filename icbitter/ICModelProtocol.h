//
//  ICModelProtocol.h
//  icbitter
//
//  Created by Gosha Arinich on 11/20/13.
//  Copyright (c) 2013 Gosha Arinich. All rights reserved.
//

@class ICDataSource;

// A basic model protocol.
@protocol ICModelProtocol <NSObject>

- (ICDataSource *)dataSource;
- (id)identifier;
- (void)updateFromDictionary:(NSDictionary *)dictionary;

@end
