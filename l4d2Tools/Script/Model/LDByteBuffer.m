//
//  LDByteBuffer.m
//  l4d2Tools
//
//  Created by Sans on 2022/2/18.
//

#import "LDByteBuffer.h"

@interface LDByteBuffer () {
    Byte _a[1024];
}

@property(assign, nonatomic) Byte *originData;

@end


@implementation LDByteBuffer


- (instancetype)initWithData:(NSData *)data {
    self = [super init];
    if (self) {
        [self initDataWithData:data];
    }
    return self;
}

- (instancetype)initWithByte:(Byte *)byte {
    self = [super init];
    if (self) {
        [self initDataWithByte:byte];
    }
    return self;
}

- (void)initDataWithData:(NSData *)data {
    _originData = (Byte *)[data bytes];
}

- (void)initDataWithByte:(Byte *)byte {
    _originData = byte;
}

- (Byte)readBtye {
    Byte tmp = *(_originData);
    _originData = ++_originData;
    return tmp;
}

- (short)readShort {
    Byte tmp0 = [self readBtye];
    short l0 = tmp0 & 0xff;
    Byte tmp1 = [self readBtye];
    short l1 = tmp1 & 0xff;
    short result = l0 | l1 << 8;
    return result;
}

- (int)readInt {
    Byte tmp0 = [self readBtye];
    int l0 = tmp0 & 0xff;
    Byte tmp1 = [self readBtye];
    int l1 = tmp1 & 0xff;
    Byte tmp2 = [self readBtye];
    int l2 = tmp2 & 0xff;
    Byte tmp3 = [self readBtye];
    int l3 = tmp3 & 0xff;
    int result = l0 | l1 << 8 | l2 << 16 | l3 << 24;
    return result;
}

- (float)readFloat {
    Byte bytes[4] = {};
    for (int i = 0; i < 4; i++) {
        bytes[i] = [self readBtye];
    }
    float number;
    memcpy(&number, &bytes, sizeof(bytes));
    return number;
}

- (NSString *)readString {
    Byte tmp = 255;
    Byte a[1024] = {};
    int index = 0;
    @try {
        do {
            tmp = [self readBtye];
            a[index] = tmp;
            index++;
        } while (tmp != '\0');
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
    if (a[0] != 0) {
        NSData *data = [NSData dataWithBytes:a length:index];
        NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        return result;
    }

    return @"";
}

@end
