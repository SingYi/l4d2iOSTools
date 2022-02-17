//
//  LDDataManager.h
//  l4d2Tools
//
//  Created by Sans on 2022/2/17.
//

#import <Foundation/Foundation.h>
#import "LDServerModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^Refresh)(void);

@interface LDDataManager : NSObject

@property(strong, nonatomic) NSMutableArray<LDServerModel *> *serverInfo;
@property(strong, nonatomic) Refresh refreshBlock;

+ (LDDataManager *)instance;

@end

NS_ASSUME_NONNULL_END
