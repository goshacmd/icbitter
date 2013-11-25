//
//  ICConnection.m
//  icbitter
//
//  Created by Gosha Arinich on 11/13/13.
//  Copyright (c) 2013 Gosha Arinich. All rights reserved.
//

#import "ICConnection.h"
#import "ICLoginManager.h"
#import "ICStoreAdapter.h"

typedef NS_ENUM(NSInteger, MessageType) {
    kUnknown,
    kUserOrder,
    kUserBalance,
    kStatus,
    kTrade,
    kTicker,
    kInstruments,
    kOrderbook
};

@interface ICConnection ()

@property (strong, nonatomic) SocketIO *socket;

+ (MessageType)typeForMessageType:(NSString *)messageType;
- (void)handleIncomingData:(NSDictionary *)data ofType:(MessageType)messageType update:(BOOL)update;
- (void)opGet:(NSString *)type;
- (void)opSubscribe:(NSString *)channel;

- (void)signedIn:(NSNotification *)notification;
- (void)signedOut:(NSNotification *)notification;

@end

@implementation ICConnection {
    NSNotificationCenter *notificationCenter;
    ICLoginManager *loginManager;
    ICStoreAdapter *store;
}

+ (MessageType)typeForMessageType:(NSString *)messageType {
    static NSDictionary *typeDictionary;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        typeDictionary = @{
            @"user_order": @(kUserOrder),
            @"user_balance": @(kUserBalance),
            @"status": @(kStatus),
            @"trade": @(kTrade),
            @"ticker": @(kTicker),
            @"instruments": @(kInstruments),
            @"orderbook": @(kOrderbook)
        };
    });
    
    int mappedType = [typeDictionary[messageType] intValue];
    
    if (!mappedType) {
        NSLog(@"%@ is unknown message type", messageType);
    }
    
    return mappedType;
}

+ (id)sharedConnection {
    static ICConnection *sharedConnection = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedConnection = [[self alloc] init];
    });
    
    return sharedConnection;
}

- (id)init {
    if (self = [super init]) {
        notificationCenter = NSNotificationCenter.defaultCenter;
        loginManager = ICLoginManager.sharedManager;
        store = ICStoreAdapter.sharedStoreAdapter;
        self.socket = [[SocketIO alloc] initWithDelegate:self];
        self.socket.useSecure = true;

        [notificationCenter addObserver:self
                               selector:@selector(signedIn:)
                                   name:ICLoginSignInNotification
                                 object:nil];
        
        [notificationCenter addObserver:self
                               selector:@selector(signedOut:)
                                   name:ICLoginSignOutNotification
                                 object:nil];
    }
    
    return self;
}

#pragma mark - Notification actions

- (void)signedIn:(NSNotification *)notification {
    [self connect];
}

- (void)signedOut:(NSNotification *)notification {
    [self disconnect];
    [store purge];
}

#pragma mark - Connection

- (void)connect {
    if (loginManager.isLoggedIn == NO || self.socket.isConnected == YES) return;
    
    [self.socket connectToHost:@"api.icbit.se"
                        onPort:443
                    withParams:@{ @"AuthKey": loginManager.apiKey, @"UserId": loginManager.userId }
                 withNamespace:@"/icbit"];
    
#if DEBUG
    NSLog(@"Connecting to icbit.se websocket...");
#endif
}

- (void)disconnect {
    if (self.socket.isConnected == NO) return;
    
    [self.socket disconnect];
}

#pragma mark - Message handling

- (void)handleIncomingData:(id)data ofType:(MessageType)messageType update:(BOOL)update {
    switch (messageType) {
        case kUserOrder: {
            NSLog(@"Dealing with orders");
            [store loadOrders:data update:update];
            break;
        }
            
        case kUserBalance: {
            NSLog(@"Dealing with status");
            [store loadBalance:data update:update];
            break;
        }
            
        case kStatus: {
            NSLog(@"Dealing with status");
            break;
        }
            
        case kTrade: {
            [store loadTrade:data update:update];
            NSLog(@"Dealing with trade");
            break;
        }
            
        case kTicker: {
            NSLog(@"Dealing with ticker");
            break;
        }
            
        case kInstruments: {
            NSLog(@"Dealing with instruments");
            [store loadInstruments:data update:update];
            break;
        }

        case kOrderbook: {
            NSLog(@"Dealing with orderbook");
            [store loadOrderbook:data update:update];
            break;
        }
            
        default: {
            NSLog(@"Unknown message type. Data: %@", data);
            break;
        }
    }
}

#pragma mark - Query methods

- (void)opGet:(NSString *)type {
    [self.socket sendJSON:@{ @"op": @"get", @"type": type }];
}

- (void)opSubscribe:(NSString *)channel {
    [self.socket sendJSON:@{ @"op": @"subscribe", @"channel": channel }];
}

- (void)fetchBalance {
    [self opGet:@"user_balance"];
}

- (void)fetchOrders {
    [self opGet:@"user_order"];
}

- (void)subscribeOrder {
    [self opSubscribe:@"user_order"];
}

- (void)subscribeTrades:(NSString *)ticker {
    [self opSubscribe:[NSString stringWithFormat:@"trades_%@", ticker]];
}

- (void)subscribeOrderbook:(NSString *)ticker {
    [self opSubscribe:[NSString stringWithFormat:@"orderbook_%@", ticker]];
}

- (void)cancelOrder:(NSNumber *)orderId market:(NSNumber *)marketId {
    [self.socket sendJSON:@{ @"op": @"cancel_order", @"order": @{ @"oid": orderId, @"market": marketId } }];
}

#pragma mark - SocketIODelegate

- (void)socketIODidConnect:(SocketIO *)_socket {
#if DEBUG
    NSLog(@"Socket opened");
#endif
    
    [self subscribeOrder];
    [self fetchOrders];
    
    [notificationCenter postNotificationName:ICConnectionEstablishedNotification
                                      object:nil];
}

- (void)socketIODidDisconnect:(SocketIO *)socket disconnectedWithError:(NSError *)error {
    NSLog(@"Socket closed: %@", error);
    NSLog(@"Connected: %d", socket.isConnected || socket.isConnecting);
    
    if (error.domain == NSPOSIXErrorDomain && error.code == 60) {
        // TODO: retry connect on time outs
    }
    
    [notificationCenter postNotificationName:ICConnectionClosedNotification
                                      object:error];
}

- (void)socketIO:(SocketIO *)socket didReceiveJSON:(SocketIOPacket *)packet {
#if DEBUG
    NSLog(@"Received JSON");
#endif
    
    NSDictionary *data = packet.dataAsJSON;
    
    if ([data[@"op"] isEqualToString:@"private"]) {
        NSString *private = data[@"private"];
        BOOL update = [data[@"update"] boolValue];
        [self handleIncomingData:data[private]
                          ofType:[self.class typeForMessageType:private]
                          update:update];
    }
}

- (void)socketIO:(SocketIO *)socket onError:(NSError *)error {
    NSLog(@"Error occurred: %@", error);
    
    if (error.domain == SocketIOError && error.code == SocketIOHandshakeFailed) {
        // TODO: request timed out, retry
    }
    
    [notificationCenter postNotificationName:ICConnectionErrorNotification
                                      object:error];
}

@end
