//
//  LDServerModel.m
//  l4d2Tools
//
//  Created by Sans on 2022/2/17.
//

#import "LDServerModel.h"

@interface LDServerModel ()

@end

@implementation LDServerModel

- (void)setServerIpAndPort:(NSString *)ipAndPort {
    NSArray *tmp = [ipAndPort componentsSeparatedByString:@":"];
    self.ip = tmp[0];
    self.port = tmp[1];
}


- (NSString *)description {
    /*
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
     */
    return [NSString stringWithFormat:@"\n  ip = %@,port = %@, name = %@, Snas  map = %@, asns serverFolder = %@, gameName = %@,  appid = %d, currentPlayer = %d,  maxPlayer = %d,  botsCount = %d, serverType = %d, environment = %d,  visibility = %d,  vac = %d,\n",
            self.ip,
            self.port,
            self.name,
            self.map,
            self.serverFolder,
            self.gameName,
            self.appId,
            self.currentPlayer,
            self.maxPlayer,
            self.botsCount,
            self.serverType,
            self.environment,
            self.visibility,
            self.vac];
}

@end
