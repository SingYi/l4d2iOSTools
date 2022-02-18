//
//  LDServerModel.m
//  l4d2Tools
//
//  Created by Sans on 2022/2/17.
//

#import "LDServerModel.h"
#import "LDUDPManager.h"
#import "LDByteBuffer.h"

@interface LDServerModel ()

@end

@implementation LDServerModel

- (void)setServerIpAndPort:(NSString *)ipAndPort {
    NSArray *tmp = [ipAndPort componentsSeparatedByString:@":"];
    self.ip = tmp[0];
    self.port = tmp[1];
}

- (void)update {
    if (self.ip == nil || self.port == nil) {
        return;
    }
//    NSLog(@"update!");
    [[LDUDPManager Instance] getServerInfoServer:self.ip Port:self.port Callback:^(NSString * _Nonnull server, NSString * _Nonnull port, NSData *data) {
        // 处理服务器数据
        Byte a[1024];
        [data getBytes:a range:NSMakeRange(6, data.length - 6)];
        
        if (a[0] == 0xff || a[0] == 0) {
            return;
        }

        LDByteBuffer *buffer = [[LDByteBuffer alloc] initWithByte:a];
        
//        dispatch_async(dispatch_get_main_queue(), ^{
            self.name = [NSString stringWithFormat:@"%@",[buffer readString]];
            self.map = [NSString stringWithFormat:@"%@",[buffer readString]];
        NSLog(@"name == %@",self.name);
//        [buffer readString];
//        [buffer readString];
        [buffer readString];
        [buffer readString];
//            self.serverFolder = [NSString stringWithFormat:@"%@",[buffer readString]];
//            self.gameName = [NSString stringWithFormat:@"%@",[buffer readString]];
            
            self.appId = [buffer readShort];
            self.currentPlayer = [buffer readBtye];
            self.maxPlayer = [buffer readBtye];
            self.botsCount = [buffer readBtye];
            self.serverType = [buffer readBtye];
            self.environment = [buffer readBtye];
            self.visibility = [buffer readBtye];
            self.vac = [buffer readBtye];
//        });
        
//            NSLog(@"%@", model.name);
//            NSLog(@"%@", model.map);
//            NSLog(@"%@", model.serverFolder);
//            NSLog(@"%@", model.gameName);
        
//            NSLog(@"%d", model.appId);
//            NSLog(@"%d", model.currentPlayer);
//            NSLog(@"%d", model.maxPlayer);
//            NSLog(@"%d", model.botsCount);
//            NSLog(@"serverType %c", model.serverType);
//            NSLog(@"environment %c", model.environment);
//            NSLog(@"visibility %d", model.visibility);
//            NSLog(@"vac %d", model.vac);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.tableView) {
                [self.tableView reloadData];
            }
        });
    }];
    
    [[LDUDPManager Instance] getPlayerInfoServer:self.ip Port:self.port Callback:^(NSString * _Nonnull server, NSString * _Nonnull port, NSData *data) {
        // 处理服务器数据
        Byte a[1024];
        [data getBytes:a range:NSMakeRange(5, data.length - 5)];
        // 第一个 byte 是当前玩家数量
        LDByteBuffer *buffer = [[LDByteBuffer alloc] initWithByte:a];
        Byte playerNumber = [buffer readBtye];
//            NSLog(@"玩家数量 = %d", playerNumber);
        NSMutableArray *array = [@[] mutableCopy];
        for (int i = 0; i < playerNumber; i++) {
            LDPlayerModel *player = [[LDPlayerModel alloc] init];
            player.index = [buffer readBtye];
            player.name = [buffer readString];
            player.score = [buffer readInt];
            player.duration = [buffer readFloat];
//                NSLog(@"玩家下标 = %d", index);
//                NSLog(@"玩家 name  = %@", name);
//                NSLog(@"玩家 score  = %d", score);
//                NSLog(@"玩家 time  = %f", time);
            [array addObject:player];
        }
        
        self.playerInfo = array;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.tableView) {
                [self.tableView reloadData];
            }
        });
    }];
}



@end
