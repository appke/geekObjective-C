//
//  BNCToolbar.h
//  BNRetail
//
//  Created by 刘晓恒 on 2018/7/17.
//  Copyright © 2018年 Baoneng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BNCToolbarItem;

@interface BNCToolbar : UIView

@property (nonatomic, assign) NSUInteger selectedItemIndex;
@property (nonatomic, strong) NSArray<BNCToolbarItem *> *items;
@property (nonatomic, assign, getter=isShowIndicator) BOOL showIndicator;

- (void)addTarget:(id)target action:(SEL)selector;
- (void)updateIndicatorPosition:(CGPoint)position;

@end

#pragma mark - BNOrderToolbarItem

@interface BNCToolbarItem : UIButton

@property (nonatomic, assign, readonly) CGFloat titleWidth;
@property (nonatomic, copy, readonly) NSString *title;

+ (instancetype)itemWithTitle:(NSString *)title;

@end

#pragma mark - BNCToolbarIndicator

@interface BNCToolbarIndicator : UIView

@property (nonatomic, strong) UIColor *tintColor; //default kButtonNormalColor

@end
