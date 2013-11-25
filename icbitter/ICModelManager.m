//
//  ICModelManager.m
//  icbitter
//
//  Created by Gosha Arinich on 11/18/13.
//  Copyright (c) 2013 Gosha Arinich. All rights reserved.
//

#import "ICModelManager.h"
#import "ICModel.h"

static NSMutableDictionary *modelTypeRegistry;

@interface ICModelManager ()

@end

@implementation ICModelManager

+ (void)initialize {
    if (!modelTypeRegistry)
        modelTypeRegistry = NSMutableDictionary.dictionary;
}

+ (void)registerModel:(Class)model forType:(NSString *)type {
#if DEBUG
    NSLog(@"Attempting to register %@  as model for type %@", model, type);
#endif
    
    if ([model isSubclassOfClass:ICModel.class]) {
#if DEBUG
        NSLog(@"Registering %@  as model for type %@", model, type);
#endif
        
        [modelTypeRegistry setObject:model forKey:type];
    } else {
        [NSException raise:NSInvalidArgumentException
                    format:@"Wanted a subclass of ICBaseStore but got %@", NSStringFromClass(model)];

    }
}

+ (id<ICModelProtocol>)instantiateModelOfType:(NSString *)type withDataSource:(ICDataSource *)dataSource {
    Class model = modelTypeRegistry[type];
    return [[model alloc] initWithDataSource:dataSource];
}

+ (id<ICModelProtocol>)instantiateModelOfType:(NSString *)type withDataSource:(ICDataSource *)dataSource dictionary:(NSDictionary *)dictionary {
    id instance = [self instantiateModelOfType:type withDataSource:dataSource];
    [instance updateFromDictionary:dictionary];
    
    return instance;
}

@end
