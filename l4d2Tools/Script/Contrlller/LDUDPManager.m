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
@property(strong, nonatomic) NSMutableDictionary<NSString *, GetServerInfoCallback> *cacheCallback;

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
    NSLog(@"upd client init");
    self.client = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    NSError * error = nil;
    [self.client bindToPort:22222 error:&error];
    if (error) {//监听错误打印错误信息
        NSLog(@"error:%@",error);
    }else {//监听成功则开始接收信息
        NSLog(@"监听成功!");
        [self.client beginReceiving:&error];
    }
}


#pragma mark - method
- (void)getServerInfoServer:(NSString *)ip Port:(NSString *)port Callback:(GetServerInfoCallback)callback {
    NSLog(@"send udp! ip = %@ prot = %@",ip, port);
    [self.client sendData:[self queryData] toHost:ip port:[port intValue] withTimeout:-1 tag:0];
    [self.cacheCallback setObject:callback forKey:[NSString stringWithFormat:@"%@:%@",ip, port]];
}


#pragma mark - UDP delegate
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext
{

    NSString *ip = [GCDAsyncUdpSocket hostFromAddress:address];
    uint16_t port = [GCDAsyncUdpSocket portFromAddress:address];
    NSString *identifier = [NSString stringWithFormat:@"%@:%d",ip,port];
    // 继续来等待接收下一次消息
    NSLog(@"收到服务端的响应 [%@]", identifier);
    const struct UDPResponseData *response = [data bytes];
    NSLog(@"收到服务端的响应 header [%d]", response->header);
    switch (response->header) {
        case 0x41: {
            // challenge number
            NSMutableData *queryData = [self queryData];
//            Byte a[1024] = *(response->data);
            [queryData appendBytes:response->data length:4];
            [self.client sendData:queryData toHost:ip port:port withTimeout:-1 tag:0];
            break;
        }
            
        case 0x49: {
            // server info
            if ([self.cacheCallback valueForKey:identifier] != nil) {
                GetServerInfoCallback callback = self.cacheCallback[identifier];
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

- (NSMutableData *)queryData {
    Byte byte2[] = {0xff, 0xff, 0xff, 0xff, 0x54, 0x53 , 0x6F , 0x75 , 0x72 , 0x63 , 0x65 ,0x20, 0x45 , 0x6E , 0x67 , 0x69 , 0x6E , 0x65 , 0x20 , 0x51 , 0x75 , 0x65 , 0x72 , 0x79 , 0x00};
    NSMutableData *data = [[NSMutableData alloc] initWithBytes:byte2 length:25];
    return data;
}

- (NSMutableDictionary<NSString *,GetServerInfoCallback> *)cacheCallback {
    if (!_cacheCallback) {
        _cacheCallback = [[NSMutableDictionary alloc] init];
    }
    return _cacheCallback;
}



@end
