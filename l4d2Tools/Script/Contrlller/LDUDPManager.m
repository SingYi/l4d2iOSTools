//
//  LDUDPManager.m
//  l4d2Tools
//
//  Created by Sans on 2022/2/17.
//

#import "LDUDPManager.h"
#import <GCDAsyncUdpSocket.h>

struct UDPResponseData {
    Byte        a[4];
    Byte        header;
    Byte        data[1019];
};

@interface LDUDPManager ()<GCDAsyncUdpSocketDelegate>

@property(strong, nonatomic) GCDAsyncUdpSocket *client;
@property(assign, nonatomic) dispatch_queue_t clientQueue;
@property(strong, nonatomic) NSMutableDictionary<NSString *, GetInfoCallback> *serverCallback;
@property(strong, nonatomic) NSMutableDictionary<NSString *, GetInfoCallback> *playerCallback;

@end

@implementation LDUDPManager

static LDUDPManager *_private_udp_manager = nil;
+ (LDUDPManager *)Instance {
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        if (_private_udp_manager == nil) {
            _private_udp_manager = [[LDUDPManager alloc] init];
            [_private_udp_manager initUdpClient];
        }
    });
    return  _private_udp_manager;
}


- (void)initUdpClient {
//    NSLog(@"upd client init");
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    self.client = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
//    self.client = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:queue];
    NSError * error = nil;
    [self.client bindToPort:22222 error:&error];
    if (error) {//监听错误打印错误信息
        NSLog(@"error:%@",error);
    }else {//监听成功则开始接收信息
//        NSLog(@"监听成功!");
        [self.client beginReceiving:&error];
    }
}


#pragma mark - method
- (void)getServerInfoServer:(NSString *)ip Port:(NSString *)port Callback:(GetInfoCallback)callback {
//    NSLog(@"send udp get server info ip = %@ prot = %@",ip, port);
    [self.client sendData:[self queryServerData] toHost:ip port:[port intValue] withTimeout:-1 tag:0];
    [self.serverCallback setObject:callback forKey:[NSString stringWithFormat:@"%@:%@",ip, port]];
}

- (void)getPlayerInfoServer:(NSString *)ip Port:(NSString *)port Callback:(GetInfoCallback)callback {
//    NSLog(@"send udp get player info ip = %@ prot = %@",ip, port);
    NSMutableData *queryData = [self queryPlayerData];
    Byte tmp[4] = {0xff, 0xff, 0xff, 0xff};
    [queryData appendBytes:tmp length:4];
    [self.client sendData:queryData toHost:ip port:[port intValue] withTimeout:-1 tag:0];
    [self.playerCallback setObject:callback forKey:[NSString stringWithFormat:@"%@:%@",ip, port]];
}


#pragma mark - UDP delegate
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext {

    NSString *ip = [GCDAsyncUdpSocket hostFromAddress:address];
    uint16_t port = [GCDAsyncUdpSocket portFromAddress:address];
    NSString *identifier = [NSString stringWithFormat:@"%@:%d",ip,port];
    // 继续来等待接收下一次消息
    const struct UDPResponseData *response = [data bytes];
    NSLog(@"收到服务端的响应 [%@]", identifier);
//    NSLog(@"收到服务端的响应 header [%x]", response->header);
    switch (response->header) {
        case 0x41: {
            NSMutableData *queryData = [self queryServerData];
            [queryData appendBytes:response->data length:4];
            [self.client sendData:queryData toHost:ip port:port withTimeout:-1 tag:0];
            NSMutableData *queryData2 = [self queryPlayerData];
            [queryData2 appendBytes:response->data length:4];
            [self.client sendData:queryData2 toHost:ip port:port withTimeout:-1 tag:0];
            break;
        }
        case 0x49: {
            // server info
            if ([self.serverCallback valueForKey:identifier] != nil) {
                GetInfoCallback callback = self.serverCallback[identifier];
                callback(ip, [NSString stringWithFormat:@"%d",port], data);
            }
            break;
        }
        case 0x44: {
            // player info
            if ([self.playerCallback valueForKey:identifier] != nil) {
                GetInfoCallback callback = self.playerCallback[identifier];
                callback(ip, [NSString stringWithFormat:@"%d",port], data);
            }
            break;
        }
        default:
            break;
    }
}

#pragma mark - getter
- (GCDAsyncUdpSocket *)client {
    if (!_client) {
        _client = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_queue_create("com.sans.udpclient", DISPATCH_QUEUE_CONCURRENT)];
    }
    return _client;
}

- (NSMutableData *)queryPlayerData {
    Byte byte2[] = {0xff, 0xff, 0xff, 0xff, 0x55};
    NSMutableData *data = [[NSMutableData alloc] initWithBytes:byte2 length:5];
    return data;
}

- (NSMutableData *)queryServerData {
    Byte byte2[] = {0xff, 0xff, 0xff, 0xff, 0x54, 0x53 , 0x6F , 0x75 , 0x72 , 0x63 , 0x65 ,0x20, 0x45 , 0x6E , 0x67 , 0x69 , 0x6E , 0x65 , 0x20 , 0x51 , 0x75 , 0x65 , 0x72 , 0x79 , 0x00};
    NSMutableData *data = [[NSMutableData alloc] initWithBytes:byte2 length:25];
    return data;
}

- (NSMutableDictionary<NSString *,GetInfoCallback> *)serverCallback {
    if (!_serverCallback) {
        _serverCallback = [[NSMutableDictionary alloc] init];
    }
    return _serverCallback;
}

- (NSMutableDictionary<NSString *,GetInfoCallback> *)playerCallback {
    if (!_playerCallback) {
        _playerCallback = [[NSMutableDictionary alloc] init];
    }
    return _playerCallback;
}



@end
