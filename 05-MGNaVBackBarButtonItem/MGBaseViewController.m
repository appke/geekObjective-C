//
//  MGBaseViewController.m
//  MGNaVTest
//
//  Created by 穆良 on 2017/5/15.
//  Copyright © 2017年 穆良. All rights reserved.
//

#import "MGBaseViewController.h"

@interface MGBaseViewController ()

@end

@implementation MGBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.tintColor = kColorHex(0x3A8AEA);
    
    [self setupBackBarButtonItem];
}


/**
 创建返回按钮
 1. modal出来的
 2. push进来的
 */
- (void)setupBackBarButtonItem
{
//    LxDBAnyVar(self.presentingViewController);
//    LxDBAnyVar(self.presentedViewController);
//    LxDBAnyVar(self.navigationController.childViewControllers.count);
    
    // 只有根控制器不加leftBarButtonItem
    if (self.presentingViewController || self.navigationController.childViewControllers.count > 1) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"返回" forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"navigationButtonReturn"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"navigationButtonReturnClick"] forState:UIControlStateHighlighted];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
        
        [button sizeToFit];
        
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        button.contentEdgeInsets = UIEdgeInsetsMake(0, -8, 0, 0);
        [button addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    }
}

- (void)buttonAction
{
    if (self.presentingViewController) {    // modal出来的控制器
        // 返回是diss
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    } else {    // push进来的
        // 返回是pop
        [self.navigationController popViewControllerAnimated:YES];
    }
}
@end
