//
//  BNCRootView.h
//  BNRetail
//
//  Created by 刘晓恒 on 2018/7/17.
//  Copyright © 2018年 Baoneng. All rights reserved.
//

#import "BNCToolbar.h"
#import <UIKit/UIKit.h>

@protocol BNCRootViewDelegate;

@interface BNCRootView : UIView

@property (nonatomic, weak) id<BNCRootViewDelegate> delegate;
@property (nonatomic, strong) BNCToolbar *toolBar;

- (void)addChildView:(UIView *)view atIndex:(NSUInteger)index;
- (void)switchControllerWithIndex:(NSUInteger)index;
- (void)switchControllerWithIndex:(NSUInteger)index animated:(BOOL)animated;

@end

@protocol BNCRootViewDelegate <NSObject>

@optional
- (void)rootView:(BNCRootView *)rootView didChangeToIndex:(NSUInteger)index;
- (void)rootView:(BNCRootView *)rootView didMoveToOffset:(CGPoint)offset;

@end
