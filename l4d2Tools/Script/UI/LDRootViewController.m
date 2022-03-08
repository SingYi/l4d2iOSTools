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
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:(UIBarButtonSystemItemAdd) target:self action:@selector(responseAddButton)];
    [leftItem setTintColor:[UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void)initDataSource {
    [[LDDataManager instance] setRefreshBlock:^{
        [self.tableView reloadData];
    }];
}

- (void)refreshData {

}

- (void)responseAddButton {
//    NSLog(@"点击添加按钮!");
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"添加服务器"
                                                                             message:@"请输入服务器地址与端口"
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *ip = alertController.textFields.firstObject;
        UITextField *port = alertController.textFields[1];
        NSLog(@"[%@:%@]",ip.text, port.text);
        [[LDDataManager instance] addServer:ip.text Port:port.text];
        [self.tableView reloadData];
    }]];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入服务器地址";
    }];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入端口";
        textField.text = @"27015";
    }];

    [self presentViewController:alertController animated:YES completion:nil];

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
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"手动刷新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        LDServerModel *model = [LDDataManager instance].serverInfo[indexPath.row];
        [model updateWithIndex:indexPath.row];
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"向上移动" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[LDDataManager instance] dataUp:indexPath.row];
        [self.tableView reloadData];
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"向下移动" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[LDDataManager instance] dataDown:indexPath.row];
        [self.tableView reloadData];
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"删除服务器" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        LDServerModel *model = [LDDataManager instance].serverInfo[indexPath.row];
        [[LDDataManager instance] removeServerWithModel:model];
        [self.tableView reloadData];
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    CGFloat s_width = [UIScreen mainScreen].bounds.size.width;
//    CGFloat height = s_width / 16 * 9;
//    NSLog(@"height = %f",height);
    return 220;
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
        
        // 这里需要配置预估高度,否则刷新时,cell 会上下乱跳
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedRowHeight = 220;
    }
    return _tableView;
}


@end
