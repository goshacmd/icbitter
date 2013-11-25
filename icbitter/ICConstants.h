//
//  ICConstants.h
//  icbitter
//
//  Created by Gosha Arinich on 11/16/13.
//  Copyright (c) 2013 Gosha Arinich. All rights reserved.
//

#ifndef icbitter_ICConstants_h
#define icbitter_ICConstants_h

static NSString *const ICConnectionEstablishedNotification = @"name.goshakkk.icbitter.icbit-connection.established";
static NSString *const ICConnectionClosedNotification = @"name.goshakkk.icbitter.icbit-connection.closed";
static NSString *const ICConnectionErrorNotification = @"name.goshakkk.icbitter.icbit-connection.error";

static NSString *const ICStoreBalancesNotification = @"name.goshakkk.icbitter.balances";
static NSString *const ICStoreInstrumentsNotification = @"name.goshakkk.icbitter.instruments";
static NSString *const ICStoreTradesNotification = @"name.goshakkk.icbitter.trades";
static NSString *const ICStoreTradeNotification = @"name.goshakkk.icbitter.trade-%@";
static NSString *const ICStoreOrderbooksNotification = @"name.goshakkk.icbitter.orderbooks";
static NSString *const ICStoreOrderbookNotification = @"name.goshakkk.icbitter.orderbook-%@";
static NSString *const ICStoreOrdersNotification = @"name.goshakkk.icbitter.orders";

static NSString *const ICSettingsDomain = @"name.goshakkk.icbitter.settings";
static NSString *const ICSettingsHideUSDNotification = @"name.goshakkk.icbitter.settings";

static NSString *const ICLoginErrorDomain = @"name.goshakkk.icbitter.login-error";
static NSString *const ICLoginSignInNotification = @"name.goshakkk.icbitter.login.sign-in";
static NSString *const ICLoginSignOutNotification = @"name.goshakkk.icbitter.login.sign-out";

static NSString *const ICBITBaseUrl = @"http://icbit.se";

#endif
