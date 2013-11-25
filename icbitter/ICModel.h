//
//  ICModel.h
//  icbitter
//
//  Created by Gosha Arinich on 11/15/13.
//  Copyright (c) 2013 Gosha Arinich. All rights reserved.
//

#import "ICModelManager.h"
#import "ICDataSource.h"
#import "ICModelProtocol.h"

// A simple `ICModelProtocol` implementation. Subclasses need to implement
// `updateFromDictionary:`.
@interface ICModel : NSObject <ICModelProtocol>

@property (strong, nonatomic, readonly) ICDataSource *dataSource;
@property (strong, nonatomic) id identifier;

- (instancetype)initWithDataSource:(ICDataSource *)dataSource;
- (void)updateFromDictionary:(NSDictionary *)dictionary;

@end
