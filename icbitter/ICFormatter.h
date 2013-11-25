//
//  ICFormatter.h
//  icbitter
//
//  Created by Gosha Arinich on 11/24/13.
//  Copyright (c) 2013 Gosha Arinich. All rights reserved.
//

// A collection of different formatters.
@interface ICFormatter : NSObject

+ (NSNumberFormatter *)percentFormatter;
+ (NSNumberFormatter *)decimalFormatter;
+ (NSNumberFormatter *)quantityFormatter;
+ (NSDateFormatter *)timeFormatter;

@end
