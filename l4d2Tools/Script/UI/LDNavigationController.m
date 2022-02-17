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


@end
