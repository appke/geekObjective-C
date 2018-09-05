//
//  BNVCContainer.h
//  BNRetail
//
//  Created by 刘晓恒 on 2018/7/17.
//  Copyright © 2018年 Baoneng. All rights reserved.
//

#import "BNBaseViewController.h"
#import "BNCRootView.h"

@interface BNVCContainer : BNBaseViewController <BNCRootViewDelegate>

@property (nonatomic, strong, readonly) BNCRootView *rootView;

/**
 重写Get方法，返回要显示在toolbar上的item
 目前只支持文字显示
 */
@property (nonatomic, strong) NSArray<BNCToolbarItem *> *items;

/**
 添加控制器到容器中

 @param controller 要添加的子控制器
 */
- (void)addController:(UIViewController *)controller;

@end
