//
//  BNVCContainer.m
//  BNRetail
//
//  Created by 刘晓恒 on 2018/7/17.
//  Copyright © 2018年 Baoneng. All rights reserved.
//

#import "BNVCContainer.h"
#import "BNCToolbar.h"

@interface BNVCContainer ()

@property (nonatomic, strong) BNCRootView *rootView;

@end

@implementation BNVCContainer

#pragma mark - View Controller LifeCyle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.rootView];
    [self.rootView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.view);
        make.top.equalTo(self.navigationBar.mas_bottom);
        make.bottom.equalTo(self.view);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self showFirstVC];
}

#pragma mark - Actions
- (void)click:(BNCToolbar *)view {
    [self addChildViewAtIndex:view.selectedItemIndex];
    [self.rootView switchControllerWithIndex:view.selectedItemIndex];
}

#pragma mark - Public
- (void)addController:(UIViewController *)controller {
    [self addChildViewController:controller];
}

#pragma mark - Protocol conformance
- (void)rootView:(BNCRootView *)rootView didChangeToIndex:(NSUInteger)index {
    [self addChildViewAtIndex:index];
}

#pragma mark - Private
- (void)addChildViewAtIndex:(NSUInteger)index {
    UIViewController *vc = self.childViewControllers[index];
    if (![vc isViewLoaded]) {
        [self.rootView addChildView:vc.view atIndex:index];
    }
}

- (void)showFirstVC {
    UIViewController *first = [self.childViewControllers firstObject];
    if (![first isViewLoaded]) {
        [self.rootView addChildView:first.view atIndex:0];
        [first didMoveToParentViewController:self];
    }
}

#pragma mark - Lazy Loads
- (BNCRootView *)rootView {
    if (!_rootView) {
        _rootView = [[BNCRootView alloc] init];
        _rootView.delegate = self;
        [_rootView.toolBar addTarget:self action:@selector(click:)];
        _rootView.toolBar.items = self.items;
    }
    return _rootView;
}
@end
