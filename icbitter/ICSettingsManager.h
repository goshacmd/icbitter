//
//  ICSettingsManager.h
//  icbitter
//
//  Created by Gosha Arinich on 11/16/13.
//  Copyright (c) 2013 Gosha Arinich. All rights reserved.
//

// A settings manager. Acts as a thin proxy between NSUserDefauls and the app.
@interface ICSettingsManager : NSObject

+ (instancetype)sharedManager;

- (BOOL)hideUSD;
- (void)setHideUSD:(BOOL)hide;

@end
