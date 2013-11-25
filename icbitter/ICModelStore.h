//
//  ICModelStore.h
//  icbitter
//
//  Created by Gosha Arinich on 11/19/13.
//  Copyright (c) 2013 Gosha Arinich. All rights reserved.
//

// An internal model store.
@interface ICModelStore : NSObject

+ (instancetype)sharedStore;

- (void)insertObject:(id)model withIdentifier:(id)identifier inCollection:(NSString *)collection;

- (NSArray *)objectsInCollection:(NSString *)collection;
- (id)objectWithIdentifier:(id)identifier fromCollection:(NSString *)collection;

- (void)deleteAllFromCollection:(NSString *)type;
- (void)deleteAllFromCollection:(NSString *)type matchingPredicate:(NSPredicate *)predicate;

- (void)purge;

@end
