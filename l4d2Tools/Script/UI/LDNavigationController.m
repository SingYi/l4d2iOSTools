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

    if (@available(iOS 13.0, *)) {
        UINavigationBarAppearance *barApperance = [[UINavigationBarAppearance alloc] init];
        barApperance.backgroundColor = [UIColor colorWithWhite:0.1 alpha:1];
        [UINavigationBar appearance].standardAppearance = barApperance;
    } else {
        self.navigationBar.barTintColor = [UIColor colorWithWhite:0.1 alpha:1];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


@end
