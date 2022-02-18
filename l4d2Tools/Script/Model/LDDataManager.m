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
@property(strong, nonatomic) dispatch_source_t timer;


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
    [self initTimer];

    NSArray *arry = [self loadServerListFromUserDeafults];
    if (arry == nil || arry.count == 0) {
        // 默认服务器地址
        arry = [self defaultArray];
        // ba
        [self saveServerListToUserDafaults:arry];
    } else {
        NSLog(@"存在本地数据!");
    }
    [self.serverArray addObjectsFromArray:arry];
    [self getData];
}

static NSString * const _serverListKey = @"com.sans.serverList";
- (NSArray<NSString *> *)loadServerListFromUserDeafults {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *array = [defaults arrayForKey:_serverListKey];
    return array;
}

- (void)saveServerListToUserDafaults:(NSArray <NSString *>*)array {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:array forKey:_serverListKey];
    [defaults synchronize];
}

- (void)initTimer {
    //0.创建队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_queue_t queue = dispatch_get_main_queue();
    //1.创建GCD中的定时器
    /*
      第一个参数:创建source的类型 DISPATCH_SOURCE_TYPE_TIMER:定时器
      第二个参数:0
      第三个参数:0
      第四个参数:队列
    */
   dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);

    //2.设置时间等
    /*
      第一个参数:定时器对象
      第二个参数:DISPATCH_TIME_NOW 表示从现在开始计时
      第三个参数:间隔时间 GCD里面的时间最小单位为 纳秒
      第四个参数:精准度(表示允许的误差,0表示绝对精准)
    */
   dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 5.0 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);

    //3.要调用的任务
   dispatch_source_set_event_handler(timer, ^{
       // 更新数据
       [self updateAlldata];
   });

   //4.开始执行
   dispatch_resume(timer);
    self.timer = timer;
}


- (void)getData {
    for (NSString *ip in self.serverArray) {
        [self addServer:ip];
    }
}

- (void)updateAlldata {
    if (self.serverInfo == nil) {
        return;
    }
    for (LDServerModel *model in self.serverInfo) {
        [model update];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(500 * NSEC_PER_MSEC)), dispatch_get_main_queue(), ^{
        if (self.refreshBlock) {
            self.refreshBlock();
        }
    });
}

#pragma mark - method
- (void)addServer:(NSString *)ip Port:(NSString *)port {
    NSString *result = [NSString stringWithFormat:@"%@:%@",ip, port];
    NSLog(@"添加服务器: %@", result);
    [self.serverArray addObject:result];
    [self saveServerListToUserDafaults:self.serverArray];
    [self addServer:result];
    
}

- (void)addServer:(NSString *)ip {
    LDServerModel *model = [[LDServerModel alloc] init];
    NSArray *s = [ip componentsSeparatedByString:@":"];
    model.ip = s.firstObject;
    model.port = s.lastObject;
    [model update];
    [self.serverInfo addObject:model];
}

- (void)removeServer:(NSString *)value {
    [self.serverArray removeObject:value];
    [self saveServerListToUserDafaults:self.serverArray];
    LDServerModel *tmpModel;
    for (LDServerModel *model in self.serverInfo) {
        NSString *tmp = [NSString stringWithFormat:@"%@:%@",model.ip,model.port];
        if ([tmp isEqualToString:value]) {
            tmpModel = model;
            break;
        }
    }
    
    if (tmpModel != nil) {
        [self.serverInfo removeObject:tmpModel];
    }
}

- (void)removeServerWithModel:(LDServerModel *)value {
    [self.serverInfo removeObject:value];
    [self.serverArray removeObject:[NSString stringWithFormat:@"%@:%@",value.ip,value.port]];
    [self saveServerListToUserDafaults:self.serverArray];
}

- (void)dataUp:(NSUInteger)index {
    if (index == 0) {
        return;
    }
    [self.serverInfo exchangeObjectAtIndex:index withObjectAtIndex:(index - 1)];
    [self.serverArray exchangeObjectAtIndex:index withObjectAtIndex:(index - 1)];
    [self saveServerListToUserDafaults:self.serverArray];
}

- (void)dataDown:(NSUInteger)index {
    if (index == self.serverInfo.count - 1) {
        return;
    }
    [self.serverInfo exchangeObjectAtIndex:index withObjectAtIndex:(index + 1)];
    [self.serverArray exchangeObjectAtIndex:index withObjectAtIndex:(index + 1)];
    [self saveServerListToUserDafaults:self.serverArray];
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
