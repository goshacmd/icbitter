//
//  ICModelStore.m
//  icbitter
//
//  Created by Gosha Arinich on 11/19/13.
//  Copyright (c) 2013 Gosha Arinich. All rights reserved.
//

#import "ICModelStore.h"

@interface ICModelStore ()

@property (strong, nonatomic) NSMutableDictionary *collections;
@property (strong, nonatomic) NSMutableDictionary *collectionIndexes;

- (void)prepareCollection:(NSString *)collection;
- (void)deleteCollection:(NSString *)collection;
- (void)deleteFromCollection:(NSString *)collection predicate:(NSPredicate *)predicate;
- (void)putObject:(id)model withIdentifier:(id)identifier inCollection:(NSString *)collection;

@end

@implementation ICModelStore

+ (instancetype)sharedStore {
    static ICModelStore *_sharedStore = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedStore = [[self alloc] init];
    });
    
    return _sharedStore;
}

- (id)init {
    if (self = [super init]) {
        [self purge];
    }
    
    return self;
}

#pragma mark - Internal API

- (void)purge {
    self.collections = NSMutableDictionary.dictionary;
    self.collectionIndexes = NSMutableDictionary.dictionary;
}

- (void)prepareCollection:(NSString *)collection {
    if (!self.collections[collection]) {
        self.collections[collection] = NSMutableArray.array;
        self.collectionIndexes[collection] = NSMutableDictionary.dictionary;
    }
}

- (void)putObject:(id)model withIdentifier:(id)identifier inCollection:(NSString *)collection {
    [self.collections[collection] addObject:model];
    [self.collectionIndexes[collection] setObject:model forKey:identifier];
}

- (void)deleteCollection:(NSString *)collection {
    [self.collections removeObjectForKey:collection];
    [self.collectionIndexes removeObjectForKey:collection];
    [self prepareCollection:collection];
}

- (void)deleteFromCollection:(NSString *)collection predicate:(NSPredicate *)predicate {
    NSArray *items = [self.collections[collection] filteredArrayUsingPredicate:predicate];
    
    for (id item in items) {
        [self.collections[collection] removeObject:item];
        [self.collectionIndexes[collection] removeObjectForKey:[item identifier]];
    }
}

#pragma mark - Public API

- (void)insertObject:(id)model withIdentifier:(id)identifier inCollection:(NSString *)collection {
    [self prepareCollection:collection];
    [self putObject:model withIdentifier:identifier inCollection:collection];
}

- (NSArray *)objectsInCollection:(NSString *)collection {
    [self prepareCollection:collection];
    return self.collections[collection];
}

- (id)objectWithIdentifier:(id)identifier fromCollection:(NSString *)collection {
    [self prepareCollection:collection];
    return self.collectionIndexes[collection][identifier];
}

- (void)deleteAllFromCollection:(NSString *)type {
    [self deleteCollection:type];
}

- (void)deleteAllFromCollection:(NSString *)type matchingPredicate:(NSPredicate *)predicate {
    [self deleteFromCollection:type predicate:predicate];
}

@end
