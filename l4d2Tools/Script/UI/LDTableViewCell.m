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
@property(strong, nonatomic) UILabel            *playerNumberLabel;
@property(strong, nonatomic) UILabel            *vacLabel;

@property(strong, nonatomic) NSArray<UILabel *> *playerArray;

@end


@implementation LDTableViewCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

#pragma mark - method
- (void)doImageView {
    NSString *mapName = @"ThirdParty";
    NSArray<NSString *> *tmpArray = [self.model.map componentsSeparatedByString:@"_"];
    tmpArray = [tmpArray.firstObject componentsSeparatedByString:@"m"];
    NSString *map = tmpArray.firstObject;
    if ([map isEqualToString:@"c1"]) {
        mapName = @"DeadCenter";
    } else if ([map isEqualToString:@"c2"]) {
        mapName = @"DarkCarnival";
    } else if ([map isEqualToString:@"c3"]) {
        mapName = @"SwampFever";
    } else if ([map isEqualToString:@"c4"]) {
        mapName = @"HardRain";
    } else if ([map isEqualToString:@"c5"]) {
        mapName = @"TheParish";
    } else if ([map isEqualToString:@"c6"]) {
        mapName = @"ThePassing";
    } else if ([map isEqualToString:@"c7"]) {
        mapName = @"TheSacrifice";
    } else if ([map isEqualToString:@"c8"]) {
        mapName = @"NoMercy";
    } else if ([map isEqualToString:@"c9"]) {
        mapName = @"CrashCourse";
    } else if ([map isEqualToString:@"c10"]) {
        mapName = @"DeathToll";
    } else if ([map isEqualToString:@"c11"]) {
        mapName = @"DeadAir";
    } else if ([map isEqualToString:@"c12"]) {
        mapName = @"BloodHarvest";
    } else if ([map isEqualToString:@"c13"]) {
        mapName = @"ColdStream";
    } else if ([map isEqualToString:@"c14"]) {
        mapName = @"ThirdParty";
    }
    self.imageView.image = [UIImage imageNamed:mapName];
}

- (void)doName {
    self.nameLabel.text = [NSString stringWithFormat:@"%@", self.model.name];
}

- (void)doIp {
    self.ipLabel.text = [NSString stringWithFormat:@"%@:%@",self.model.ip,self.model.port];
}

- (void)doMap {
    self.mapLabel.text = [NSString stringWithFormat:@"地图: %@",self.model.map];
}

- (void)doPlayer {
    int i = 0;
    for (; i < self.model.playerInfo.count; i++) {
        UILabel *label = self.playerArray[i];
        LDPlayerModel *player = self.model.playerInfo[i];
        label.text = player.name;
    }
    
    for (; i < self.playerArray.count; i++) {
        UILabel *label = self.playerArray[i];
        label.text = @"";
    }
}

- (void)doPlayerNumber {
    self.playerNumberLabel.text = [NSString stringWithFormat:@"当前玩家: %d/%d",self.model.currentPlayer, self.model.maxPlayer];
}

- (void)doVac {
    self.vacLabel.text = [NSString stringWithFormat:@"是否开启 VAC: %@", self.model.vac == 1 ? @"是" : @"否"];
}

#pragma mark - setter
- (void)setModel:(LDServerModel *)model {
    _model = model;
    // 背景图片 16 比 9
    [self addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.contentView);
        make.top.equalTo(self.contentView.mas_top);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.width.equalTo(self.mas_width);
        make.left.equalTo(self.mas_left);
    }];
    
    [self addSubview:self.visualEffectView];
    [self.visualEffectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    [self doImageView];
    
    // 服务器名称
    [self addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).with.offset(10);
        make.left.equalTo(self.contentView.mas_left).with.offset(10);
        make.right.equalTo(self.contentView.mas_right).with.offset(-10);
    }];
    [self doName];
    
    // 服务器地址
    [self addSubview:self.ipLabel];
    [self.ipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).with.offset(4);
        make.left.equalTo(self.contentView.mas_left).with.offset(10);
        make.right.equalTo(self.contentView.mas_centerX);
    }];
    [self doIp];
    
    // 地图
    [self addSubview:self.mapLabel];
    [self.mapLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.ipLabel.mas_bottom).with.offset(4);
        make.left.equalTo(self.contentView.mas_left).with.offset(10);
        make.right.equalTo(self.contentView.mas_centerX);
    }];
    [self doMap];
    
    // 玩家数量
    [self addSubview:self.playerNumberLabel];
    [self.playerNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mapLabel.mas_bottom).with.offset(4);
        make.left.equalTo(self.contentView.mas_left).with.offset(10);
        make.right.equalTo(self.contentView.mas_centerX);
    }];
    [self doPlayerNumber];
    
    // 是否开启 Vac
    [self addSubview:self.vacLabel];
    [self.vacLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.playerNumberLabel.mas_bottom).with.offset(4);
        make.left.equalTo(self.contentView.mas_left).with.offset(10);
        make.right.equalTo(self.contentView.mas_centerX);
    }];
    [self doVac];
    
    UILabel *last = self.nameLabel;
    for (UILabel *label in self.playerArray) {
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_centerX).with.offset(10);
            make.right.equalTo(self.contentView.mas_right).with.offset(-10);
            make.top.equalTo(last.mas_bottom).with.offset(2);
        }];
        last = label;
    }
    [self doPlayer];
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

- (UILabel *)playerNumberLabel {
    if (!_playerNumberLabel) {
        _playerNumberLabel = [[UILabel alloc] init];
        _playerNumberLabel.textColor = [UIColor whiteColor];
        _playerNumberLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _playerNumberLabel;
}

- (UILabel *)vacLabel {
    if (!_vacLabel) {
        _vacLabel = [[UILabel alloc] init];
        _vacLabel.textColor = [UIColor whiteColor];
        _vacLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _vacLabel;
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

- (NSArray<UILabel *> *)playerArray {
    if (!_playerArray) {
        NSMutableArray *array = [NSMutableArray array];
        for (int i = 0; i < 8; i++) {
            UILabel *label = [[UILabel alloc] init];
            label.textColor = [UIColor whiteColor];
            label.textAlignment = NSTextAlignmentLeft;
            [array addObject:label];
        }
        _playerArray = array;
    }
    return _playerArray;
}

@end
