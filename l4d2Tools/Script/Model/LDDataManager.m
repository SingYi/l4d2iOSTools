//
//  LDDataManager.m
//  l4d2Tools
//
//  Created by Sans on 2022/2/17.
//

#import "LDDataManager.h"
#import "LDUDPManager.h"


@interface LDDataManager ()

@property(strong, nonatomic) NSMutableArray *serverArray;
@property(strong, nonatomic) NSMutableDictionary *cacheDict;


@end

@implementation LDDataManager

static LDDataManager *_private_data_manager = nil;
+ (LDDataManager *)instance {
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        if (_private_data_manager == nil) {
            _private_data_manager = [[LDDataManager alloc] init];
            [_private_data_manager initDataSource];
        }
    });
    return  _private_data_manager;
}

- (void)initDataSource {
    [self.serverArray addObjectsFromArray:[self defaultArray]];
    
    for (NSString *ip in self.serverArray) {
        LDServerModel *model = [[LDServerModel alloc] init];
        [self.serverInfo addObject:model];
        [_cacheDict setObject:model forKey:ip];
        
        NSArray *s = [ip componentsSeparatedByString:@":"];
        model.ip = s.firstObject;
        model.port = s.lastObject;
//        NSLog(@"server = %@",s);
        [[LDUDPManager Instance] getServerInfoServer:s[0] Port:s[1] Callback:^(NSString * _Nonnull server, NSString * _Nonnull port, NSData *data) {
            // 处理服务器数据
            Byte a[1024];
            [data getBytes:a range:NSMakeRange(6, data.length - 6)];
            NSMutableString *str = [[NSMutableString alloc] init];
            
            // 第一个 String 是 name 以 0 结尾
            int j = 0;
            for (int i =0 ; i < data.length; i++) {
                // 读取字符串
                Byte tmp = *(a+i);
                if (j < 4) {
                    [str appendFormat:@"%c", tmp];
                    if (tmp == 0) {
                        // 字符串结束查看计数
                        if (j == 0) {
                            // 服务器 name
                            model.name = str;
                            NSLog(@"name = %@",str);
                        } else if (j == 1) {
                            // 服务器 map
                            model.map = str;
                            NSLog(@"map = %@",str);
                        }
                        j++;
                        str = [@"" mutableCopy];
                    }
                }

                
//                if (tmp != 0) {
//                    [str appendFormat:@"%c", tmp];
//                } else if (j < 4) {
//                    NSLog(@"str = %@",str);
//                    str = [[NSMutableString alloc] init];
//                    j++;
//                }
//                if (j >= 4) {
//                    NSLog(@"t = %x", tmp);
//                }
            }
            
            NSLog(@"刷新 1.");
            if (self.refreshBlock) {
                NSLog(@"刷新 2.");
                self.refreshBlock();
            }
        }];
    }
    
//    NSLog(@"count == %lu",(unsigned long)self.serverInfo.count);
//    NSLog(@"count == %lu",(unsigned long)self.serverArray.count);
}


#pragma mark - getter
- (NSMutableArray *)serverArray {
    if (!_serverArray) {
        _serverArray = [NSMutableArray array];
    }
    return _serverArray;
}

- (NSMutableArray<LDServerModel *> *)serverInfo {
    if (!_serverInfo) {
        _serverInfo = [[NSMutableArray alloc] init];
    }
    return _serverInfo;
}

- (NSArray *)defaultArray {
    return @[
        @"119.3.63.233:27015", //101
        @"47.100.41.45:27015", //102
        @"47.101.183.209:27015",
        @"152.136.206.11:27015",
        @"182.61.16.64:27015",
        @"106.54.173.248:27015",
        @"182.61.48.110:27015",
        @"124.223.102.206:27015",// 108
        @"101.43.219.42:27015",
        @"106.12.17.252:27015",
        @"175.24.115.22:27015",
        @"175.24.115.22:27016",
        @"81.68.177.163:27015",
        @"106.15.239.138:27015",
    ];
}

- (NSMutableDictionary *)cacheDict {
    if (!_cacheDict) {
        _cacheDict = [NSMutableDictionary dictionary];
    }
    return _cacheDict;
}

@end
