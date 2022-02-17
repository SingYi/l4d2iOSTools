//
//  LDTableViewCell.h
//  l4d2Tools
//
//  Created by Sans on 2022/2/17.
//

#import <UIKit/UIKit.h>
#import "LDServerModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LDTableViewCell : UITableViewCell

@property(strong, nonatomic) LDServerModel *model;

@end

NS_ASSUME_NONNULL_END
