//
//  LDNavigationController.m
//  l4d2Tools
//
//  Created by Sans on 2022/2/17.
//

#import "LDNavigationController.h"
#import "LDRootViewController.h"

@interface LDNavigationController ()

@property(strong, nonatomic) LDRootViewController *viewController;

@end

@implementation LDNavigationController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"%s", __func__);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
