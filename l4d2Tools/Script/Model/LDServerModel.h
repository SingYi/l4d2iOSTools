//
//  LDServerModel.h
//  l4d2Tools
//
//  Created by Sans on 2022/2/17.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "LDPlayerModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LDServerModel : NSObject

@property(strong, nonatomic) UITableView *tableView;
@property(strong, nonatomic) NSIndexPath *indexPath;

@property(strong, nonatomic) NSString *ip;
@property(strong, nonatomic) NSString *port;

@property(strong, nonatomic) NSString *name;
@property(strong, nonatomic) NSString *map;
@property(strong, nonatomic) NSString *serverFolder;
@property(strong, nonatomic) NSString *gameName;

@property(assign, nonatomic) short appId;
@property(assign, nonatomic) Byte currentPlayer;
@property(assign, nonatomic) Byte maxPlayer;
@property(assign, nonatomic) Byte botsCount;
@property(assign, nonatomic) Byte serverType;
@property(assign, nonatomic) Byte environment;
@property(assign, nonatomic) Byte visibility;
@property(assign, nonatomic) Byte vac;


@property(strong, nonatomic) NSMutableArray<LDPlayerModel *> *playerInfo;

- (void)setServerIpAndPort:(NSString *)ipAndPort;


@end

NS_ASSUME_NONNULL_END
