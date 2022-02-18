//
//  LDRootViewController.m
//  l4d2Tools
//
//  Created by Sans on 2022/2/17.
//

#import "LDRootViewController.h"
#import "LDTableViewCell.h"
#import "LDDataManager.h"
#import <Masonry.h>

@interface LDRootViewController ()
<UITableViewDelegate,
UITableViewDataSource>

@property(strong, nonatomic) UITableView        *tableView;
@property(strong, nonatomic) UICollectionView   *collectionView;


@property(strong, nonatomic) NSArray *serverArray;

@end

@implementation LDRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initDataSource];
    [self initView];
}

- (void)initView {
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.top.equalTo(self.view.mas_top).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(0);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(0);
    }];
}

- (void)initDataSource {
    [[LDDataManager instance] setRefreshBlock:^{
        [self.tableView reloadData];
    }];
}

- (void)refreshData {

}

#pragma mark - table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [LDDataManager instance].serverInfo.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LDTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LDTableViewCell class]) forIndexPath:indexPath];

    LDServerModel *model = [LDDataManager instance].serverInfo[indexPath.row];
    model.tableView = tableView;
    model.indexPath = indexPath;
    
    cell.model = [LDDataManager instance].serverInfo[indexPath.row];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat s_width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = s_width / 16 * 9;
    return height + 10;
}

#pragma mark - getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[LDTableViewCell class] forCellReuseIdentifier:NSStringFromClass([LDTableViewCell class])];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor colorWithWhite:0.1 alpha:1];
    }
    return _tableView;
}


@end
