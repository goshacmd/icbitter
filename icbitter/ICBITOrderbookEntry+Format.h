//
//  ICBITOrderbookEntry+Format.h
//  icbitter
//
//  Created by Gosha Arinich on 11/25/13.
//  Copyright (c) 2013 Gosha Arinich. All rights reserved.
//

#import "ICBITOrderbookEntry.h"

@interface ICBITOrderbookEntry (Format)

- (NSString *)formattedPrice;
- (NSString *)formattedQuantity;

@end
