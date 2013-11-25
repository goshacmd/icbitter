//
//  ICDataSource.m
//  icbitter
//
//  Created by Gosha Arinich on 11/18/13.
//  Copyright (c) 2013 Gosha Arinich. All rights reserved.
//

#import "ICDataSource.h"
#import "ICModelManager.h"
#import "ICModelStore.h"

@interface ICDataSource ()

@property (strong, nonatomic) ICModelStore *modelStore;

@end

@implementation ICDataSource

+ (instancetype)sharedSource {
    static ICDataSource *_sharedSource = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedSource = [[self alloc] init];
    });
    
    return _sharedSource;
}

- (id)init {
    if (self = [super init]) {
        self.modelStore = ICModelStore.sharedStore;
    }
    
    return self;
}

#pragma mark - Model instantiation

- (id<ICModelProtocol>)materializeDictionary:(NSDictionary *)dictionary forType:(NSString *)type {
    id model = [ICModelManager instantiateModelOfType:type
                                       withDataSource:self
                                           dictionary:dictionary];
    
    return model;
}

#pragma mark - Model insertion

- (void)insertModel:(id<ICModelProtocol>)model forType:(NSString *)type {
    id identifier = model.identifier;
    [self.modelStore insertObject:model
                   withIdentifier:identifier
                     inCollection:type];
}

- (id<ICModelProtocol>)insertDictionary:(NSDictionary *)dictionary forType:(NSString *)type {
    id model = [self materializeDictionary:dictionary forType:type];
    [self insertModel:model forType:type];
    return model;
}

- (id<ICModelProtocol>)upsertDictionary:(NSDictionary *)dictionary forType:(NSString *)type {
    id identifier = [[self materializeDictionary:dictionary forType:type] identifier];
    id<ICModelProtocol> model = [self fetchModelWithIdenitfier:identifier ofType:type];
    
    if (model) {
        [model updateFromDictionary:dictionary];
    } else {
        model = [self insertDictionary:dictionary forType:type];
    }
    
    return model;
}

#pragma mark - Model fetch

- (NSArray *)fetchModelsOfType:(NSString *)type {
    return [self.modelStore objectsInCollection:type];
}

- (NSArray *)fetchModelsOfType:(NSString *)type sort:(NSArray *)sortDescriptors {
    return [[self fetchModelsOfType:type] sortedArrayUsingDescriptors:sortDescriptors];
}

- (NSArray *)fetchModelsOfType:(NSString *)type matchingPredicate:(NSPredicate *)predicate {
    NSArray *all = [self fetchModelsOfType:type];
    return [all filteredArrayUsingPredicate:predicate];
}

- (NSArray *)fetchModelsOfType:(NSString *)type matchingPredicate:(NSPredicate *)predicate sort:(NSArray *)sortDescriptors {
    return [[self fetchModelsOfType:type matchingPredicate:predicate]
            sortedArrayUsingDescriptors:sortDescriptors];
}

- (id<ICModelProtocol>)fetchModelOfType:(NSString *)type matchingPredicate:(NSPredicate *)predicate {
    return [[self fetchModelsOfType:type matchingPredicate:predicate] firstObject];
}

- (id<ICModelProtocol>)fetchModelWithIdenitfier:(id)identifier ofType:(NSString *)type {
    return [self.modelStore objectWithIdentifier:identifier
                                  fromCollection:type];
}

#pragma mark - Model delete

- (void)deleteAllModelsOfType:(NSString *)type {
    [self.modelStore deleteAllFromCollection:type];
}

- (void)deleteModelsOfType:(NSString *)type matchingPredicate:(NSPredicate *)predicate {
    [self.modelStore deleteAllFromCollection:type matchingPredicate:predicate];
}

- (void)deleteModelWithIdentifier:(id)identifier ofType:(NSString *)type {
    [self deleteModelsOfType:type
           matchingPredicate:[NSPredicate predicateWithFormat:@"identifier == %@", identifier]];
}

#pragma mark -

- (void)purge {
    [self.modelStore purge];
}

@end
