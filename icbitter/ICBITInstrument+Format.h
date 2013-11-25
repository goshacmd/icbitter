//
//  ICBITInstrument+Format.h
//  icbitter
//
//  Created by Gosha Arinich on 11/25/13.
//  Copyright (c) 2013 Gosha Arinich. All rights reserved.
//

#import "ICBITInstrument.h"

@interface ICBITInstrument (Format)

- (NSString *)formatValue:(NSNumber*)value;
- (NSString *)formattedQuantity:(NSNumber *)quantity;
- (NSString *)formattedMarginForQuantity:(NSNumber *)quantity;

@end
