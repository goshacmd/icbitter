//
//  ICBaseModel.m
//  icbitter
//
//  Created by Gosha Arinich on 11/15/13.
//  Copyright (c) 2013 Gosha Arinich. All rights reserved.
//

#import "ICModel.h"

@implementation ICModel

- (instancetype)initWithDataSource:(ICDataSource *)dataSource {
    if (self = [super init]) {
        _dataSource = dataSource;
    }
    
    return self;
}

- (void)updateFromDictionary:(NSDictionary *)dictionary {
    [NSException raise:NSInternalInconsistencyException
                format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
}

@end
