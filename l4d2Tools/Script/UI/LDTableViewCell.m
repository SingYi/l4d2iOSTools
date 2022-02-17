//
//  LDTableViewCell.m
//  l4d2Tools
//
//  Created by Sans on 2022/2/17.
//

#import "LDTableViewCell.h"
#import <Masonry.h>

@interface LDTableViewCell ()

@property(strong, nonatomic) UIImageView        *backgroundImageView;
@property(strong, nonatomic) UIVisualEffectView *visualEffectView;

@property(strong, nonatomic) UILabel            *nameLabel;
@property(strong, nonatomic) UILabel            *ipLabel;
@property(strong, nonatomic) UILabel            *mapLabel;

@end


@implementation LDTableViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSLog(@"%s",__func__);
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSLog(@"%s",__func__);
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    NSLog(@"%s",__func__);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

#pragma mark - method
- (void)doImageView {
    NSString *mapName = @"ThirdParty";
    if ([self.model.map hasPrefix:@"c1"]) {
        mapName = @"DeadCenter";
    } else if ([self.model.map hasPrefix:@"c2"]) {
        mapName = @"DarkCarnival";
    } else if ([self.model.map hasPrefix:@"c3"]) {
        mapName = @"SwampFever";
    } else if ([self.model.map hasPrefix:@"c4"]) {
        mapName = @"HardRain";
    } else if ([self.model.map hasPrefix:@"c5"]) {
        mapName = @"TheParish";
    } else if ([self.model.map hasPrefix:@"c6"]) {
        mapName = @"ThePassing";
    } else if ([self.model.map hasPrefix:@"c7"]) {
        mapName = @"TheSacrifice";
    } else if ([self.model.map hasPrefix:@"c8"]) {
        mapName = @"NoMercy";
    } else if ([self.model.map hasPrefix:@"c9"]) {
        mapName = @"CrashCourse";
    } else if ([self.model.map hasPrefix:@"c10"]) {
        mapName = @"DeathToll";
    } else if ([self.model.map hasPrefix:@"c11"]) {
        mapName = @"DeadAir";
    } else if ([self.model.map hasPrefix:@"c12"]) {
        mapName = @"BloodHarvest";
    } else if ([self.model.map hasPrefix:@"c13"]) {
        mapName = @"ColdStream";
    } else if ([self.model.map hasPrefix:@"c14"]) {
        mapName = @"ThirdParty";
    }
    self.imageView.image = [UIImage imageNamed:mapName];
}

- (void)doName {
    self.nameLabel.text = self.model.name;
}

- (void)doIp {
    self.ipLabel.text = [NSString stringWithFormat:@"%@:%@",self.model.ip,self.model.port];
}

- (void)doMap {
    self.mapLabel.text = [NSString stringWithFormat:@"地图: %@",self.model.map];
}

#pragma mark - setter
- (void)setModel:(LDServerModel *)model {
    _model = model;
    // 背景图片 16 比 9
    [self.contentView addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    [self.contentView addSubview:self.visualEffectView];
    [self.visualEffectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    [self doImageView];
    
    // 服务器名称
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).with.offset(10);
        make.left.equalTo(self.contentView.mas_left).with.offset(10);
        make.right.equalTo(self.contentView.mas_right).with.offset(-10);
    }];
    [self doName];
    
    // 服务器地址
    [self.contentView addSubview:self.ipLabel];
    [self.ipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).with.offset(4);
        make.left.equalTo(self.contentView.mas_left).with.offset(10);
        make.right.equalTo(self.contentView.mas_centerX);
    }];
    [self doIp];
    
    // 地图
    [self.contentView addSubview:self.mapLabel];
    [self.mapLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.ipLabel.mas_bottom).with.offset(4);
        make.left.equalTo(self.contentView.mas_left).with.offset(10);
        make.right.equalTo(self.contentView.mas_centerX);
    }];
    [self doMap];
}

#pragma mark - getter
- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.font = [UIFont systemFontOfSize:20];
    }
    return _nameLabel;
}

- (UILabel *)ipLabel {
    if (!_ipLabel) {
        _ipLabel = [[UILabel alloc] init];
        _ipLabel.textColor = [UIColor whiteColor];
        _ipLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _ipLabel;
}

- (UILabel *)mapLabel {
    if (!_mapLabel) {
        _mapLabel = [[UILabel alloc] init];
        _mapLabel.textColor = [UIColor whiteColor];
        _mapLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _mapLabel;
}

- (UIImageView *)backgroundImageView {
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc] init];
    }
    return _backgroundImageView;
}

- (UIVisualEffectView *)visualEffectView {
    if (!_visualEffectView) {
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        _visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blur];
        _visualEffectView.alpha = 0.8;
    }
    return _visualEffectView;
}

@end
