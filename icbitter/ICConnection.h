//
//  ICConnection.h
//  icbitter
//
//  Created by Gosha Arinich on 11/13/13.
//  Copyright (c) 2013 Gosha Arinich. All rights reserved.
//

#import <socket.IO/SocketIO.h>
#import <socket.IO/SocketIOPacket.h>

// A websocket connection to icbit.se.
@interface ICConnection : NSObject <SocketIODelegate>

+ (id)sharedConnection;

- (void)connect;
- (void)disconnect;

- (void)fetchBalance;
- (void)fetchOrders;
- (void)subscribeOrder;
- (void)subscribeTrades:(NSString *)ticker;
- (void)subscribeOrderbook:(NSString *)ticker;
- (void)cancelOrder:(NSNumber *)orderId market:(NSNumber *)marketId;

@end
