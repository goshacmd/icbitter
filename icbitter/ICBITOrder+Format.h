//
//  ICBITOrder+Format.h
//  icbitter
//
//  Created by Gosha Arinich on 11/25/13.
//  Copyright (c) 2013 Gosha Arinich. All rights reserved.
//

#import "ICBITOrder.h"

@interface ICBITOrder (Format)

- (NSString *)formattedPrice;
- (NSString *)formattedQuantity;
- (NSString *)humanDirection;
- (NSString *)humanStatus;

@end
