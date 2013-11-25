//
//  NSArray+ICAdditions.m
//  icbitter
//
//  Created by Gosha Arinich on 11/17/13.
//  Copyright (c) 2013 Gosha Arinich. All rights reserved.
//

#import "NSArray+ICAdditions.h"

@implementation NSArray (ICAdditions)

- (NSDictionary *)dictionaryGroupedByKeyPath:(NSString *)keyPath {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    for (id object in self) {
        id<NSCopying> key = [object valueForKeyPath:keyPath];
        NSMutableArray *objects = dictionary[key];
        
        if (!objects) {
            objects = [NSMutableArray array];
            dictionary[key] = objects;
        }
        
        [objects addObject:object];
    }
    
    return [NSDictionary dictionaryWithDictionary:dictionary];
}

@end
