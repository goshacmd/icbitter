//
//  ICModelManager.h
//  icbitter
//
//  Created by Gosha Arinich on 11/18/13.
//  Copyright (c) 2013 Gosha Arinich. All rights reserved.
//

#import "ICModelProtocol.h"

@class ICModel;
@class ICDataSource;

// A model registry to instantiate models of needed type.
@interface ICModelManager : NSObject

+ (void)registerModel:(Class)model forType:(NSString *)type;

+ (id<ICModelProtocol>)instantiateModelOfType:(NSString *)type withDataSource:(ICDataSource *)dataSource;
+ (id<ICModelProtocol>)instantiateModelOfType:(NSString *)type withDataSource:(ICDataSource *)dataSource dictionary:(NSDictionary *)dictionary;

@end
