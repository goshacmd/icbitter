//
//  ICDataSource.h
//  icbitter
//
//  Created by Gosha Arinich on 11/18/13.
//  Copyright (c) 2013 Gosha Arinich. All rights reserved.
//

#import "ICModelProtocol.h"

// A data source to create, insert, fetch, and delete models.
@interface ICDataSource : NSObject

+ (instancetype)sharedSource;

- (id<ICModelProtocol>)materializeDictionary:(NSDictionary *)dictionary forType:(NSString *)type;
- (void)insertModel:(id<ICModelProtocol>)model forType:(NSString *)type;

- (id<ICModelProtocol>)insertDictionary:(NSDictionary *)dictionary forType:(NSString *)type;
- (id<ICModelProtocol>)upsertDictionary:(NSDictionary *)dictionary forType:(NSString *)type;

- (NSArray *)fetchModelsOfType:(NSString *)type;
- (NSArray *)fetchModelsOfType:(NSString *)type matchingPredicate:(NSPredicate *)predicate;
- (id<ICModelProtocol>)fetchModelOfType:(NSString *)type matchingPredicate:(NSPredicate *)predicate;
- (id<ICModelProtocol>)fetchModelWithIdenitfier:(id)identifier ofType:(NSString *)type;

- (void)deleteAllModelsOfType:(NSString *)type;
- (void)deleteModelsOfType:(NSString *)type matchingPredicate:(NSPredicate *)predicate;
- (void)deleteModelWithIdentifier:(id)identifier ofType:(NSString *)type;

- (void)purge;

@end
