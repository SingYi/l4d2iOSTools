//
//  LDDataManager.m
//  l4d2Tools
//
//  Created by Sans on 2022/2/17.
//

#import "LDDataManager.h"
#import "LDUDPManager.h"
#import "LDByteBuffer.h"

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

        [[LDUDPManager Instance] getServerInfoServer:s[0] Port:s[1] Callback:^(NSString * _Nonnull server, NSString * _Nonnull port, NSData *data) {
            // 处理服务器数据
            Byte a[1024];
            [data getBytes:a range:NSMakeRange(6, data.length - 6)];
            
            // 第一个 byte 是当前玩家数量
            LDByteBuffer *buffer = [[LDByteBuffer alloc] initWithByte:a];
            model.name = [buffer readString];
            NSLog(@"%@", model.name);
            model.map = [buffer readString];
            NSLog(@"%@", model.map);
            model.serverFolder = [buffer readString];
            NSLog(@"%@", model.serverFolder);
            model.gameName = [buffer readString];
            NSLog(@"%@", model.gameName);
            
            model.appId = [buffer readShort];
            NSLog(@"%d", model.appId);
            model.currentPlayer = [buffer readBtye];
            NSLog(@"%d", model.currentPlayer);
            model.maxPlayer = [buffer readBtye];
            NSLog(@"%d", model.maxPlayer);
            model.botsCount = [buffer readBtye];
            NSLog(@"%d", model.botsCount);
            model.serverType = [buffer readBtye];
            NSLog(@"serverType %c", model.serverType);
            model.environment = [buffer readBtye];
            NSLog(@"environment %c", model.environment);
            model.visibility = [buffer readBtye];
            NSLog(@"visibility %d", model.visibility);
            model.vac = [buffer readBtye];
            NSLog(@"vac %d", model.vac);
            
            if (self.refreshBlock) {
                self.refreshBlock();
            }
        }];
        
        [[LDUDPManager Instance] getPlayerInfoServer:s[0] Port:s[1] Callback:^(NSString * _Nonnull server, NSString * _Nonnull port, NSData *data) {
            // 处理服务器数据
            Byte a[1024];
            [data getBytes:a range:NSMakeRange(5, data.length - 5)];
            // 第一个 byte 是当前玩家数量
            LDByteBuffer *buffer = [[LDByteBuffer alloc] initWithByte:a];
            Byte playerNumber = [buffer readBtye];
            NSLog(@"玩家数量 = %d", playerNumber);
            NSMutableArray *array = [@[] mutableCopy];
            for (int i = 0; i < playerNumber; i++) {
                LDPlayerModel *player = [[LDPlayerModel alloc] init];
                Byte index = [buffer readBtye];
                NSLog(@"玩家下标 = %d", index);
                NSString *name = [buffer readString];
                NSLog(@"玩家 name  = %@", name);
                int score = [buffer readInt];
                NSLog(@"玩家 score  = %d", score);
                float time = [buffer readFloat];
                NSLog(@"玩家 time  = %f", time);
                player.index = index;
                player.name = name;
                player.score = score;
                player.duration = time;
                [array addObject:player];
            }
            
            model.playerInfo = array;
            if (self.refreshBlock) {
                self.refreshBlock();
            }
        }];
    }
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
        @"119.3.63.233:27015",      // 101
        @"47.100.41.45:27015",      // 102
        @"47.101.183.209:27015",    // 103
        @"152.136.206.11:27015",    // 104
        @"182.61.16.64:27015",      // 105
        @"106.54.173.248:27015",    // 106
        @"182.61.48.110:27015",     // 107
        @"124.223.102.206:27015",
        @"101.43.219.42:27015",     // 109
        @"106.12.17.252:27015",     // 111
        @"175.24.115.22:27015",     // 118
        @"175.24.115.22:27016",     // 119
        @"81.68.177.163:27015",     // 125
        @"106.15.239.138:27015",    // 126
    ];
}

- (NSMutableDictionary *)cacheDict {
    if (!_cacheDict) {
        _cacheDict = [NSMutableDictionary dictionary];
    }
    return _cacheDict;
}

@end
