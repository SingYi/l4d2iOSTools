//
//  LDByteBuffer.h
//  l4d2Tools
//
//  Created by Sans on 2022/2/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LDByteBuffer : NSObject

- (instancetype)initWithData:(NSData *)data;
- (instancetype)initWithByte:(Byte *)byte;

- (Byte)readBtye;
- (int)readInt;
- (short)readShort;
- (float)readFloat;
- (NSString *)readString;

@end

NS_ASSUME_NONNULL_END
