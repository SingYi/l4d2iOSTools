//
//  LDPlayerModel.h
//  l4d2Tools
//
//  Created by Sans on 2022/2/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LDPlayerModel : NSObject

@property(assign, nonatomic) Byte index;
@property(strong, nonatomic) NSString *name;
@property(assign, nonatomic) int score;
@property(assign, nonatomic) float duration;

@end

NS_ASSUME_NONNULL_END
