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

@end
