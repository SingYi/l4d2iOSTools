//
//  LDUDPManager.h
//  l4d2Tools
//
//  Created by Sans on 2022/2/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^GetInfoCallback)(NSString *server, NSString *port, NSData *data);


@interface LDUDPManager : NSObject

+ (LDUDPManager *)Instance;

- (void)getServerInfoServer:(NSString *)ip Port:(NSString *)port Callback:(GetInfoCallback)callback;

- (void)getPlayerInfoServer:(NSString *)ip Port:(NSString *)port Callback:(GetInfoCallback)callback;

@end

NS_ASSUME_NONNULL_END
