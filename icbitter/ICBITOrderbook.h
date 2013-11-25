//
//  ICBITOrderbook.h
//  icbitter
//
//  Created by Gosha Arinich on 11/16/13.
//  Copyright (c) 2013 Gosha Arinich. All rights reserved.
//

#import "ICModel.h"
#import "ICBITInstrument.h"

@interface ICBITOrderbook : ICModel

@property (copy, nonatomic) NSString *ticker;
@property (strong, nonatomic) NSMutableArray *buys;
@property (strong, nonatomic) NSMutableArray *sells;
@property (strong, nonatomic) NSDate *timestamp;

- (ICBITInstrument *)instrument;

@end
