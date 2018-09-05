//
//  BNCToolbar.m
//  BNRetail
//
//  Created by 刘晓恒 on 2018/7/17.
//  Copyright © 2018年 Baoneng. All rights reserved.
//

#import "BNCToolbar.h"

@interface BNCToolbar () {
    BOOL _needLayoutItem; //重新布局标记
}

@property (nonatomic, weak) id target;
@property (nonatomic, assign) SEL action;

@property (nonatomic, strong) BNCToolbarIndicator *indicatorView;

@end

@implementation BNCToolbar

#pragma mark - Initial Methods
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = kColorWhite;
        self.selectedItemIndex = 0;
        _needLayoutItem = YES;
        self.showIndicator = YES;

        [self addSubview:self.indicatorView];
    }
    return self;
}

#pragma mark - Lifecycle
- (void)layoutSubviews {
    [super layoutSubviews];
    [self adjuestItemPosition];
}

#pragma mark - Actions
- (void)addTarget:(id)target action:(SEL)selector {
    self.target = target;
    self.action = selector;
}

- (void)itemClick:(BNCToolbarItem *)item {
    if (!self.target && !self.action) {
        return;
    }

    if (item.tag == self.selectedItemIndex) {
        return;
    }

    self.selectedItemIndex = item.tag;

    __weak typeof(self) weakSelf = self;
    if ([self checkSelectorHasParamter:[self.target class] selector:self.action]) {
        [self.target performSelectorOnMainThread:self.action withObject:weakSelf waitUntilDone:NO];
    } else {
        [self.target performSelectorOnMainThread:self.action withObject:nil waitUntilDone:NO];
    }
}

//判断target的action是否包含参数
- (BOOL)checkSelectorHasParamter:(Class)clz selector:(SEL)sel {
    if (!sel || !clz) {
        return NO;
    }

    Method mth = class_getInstanceMethod(clz, sel);
    return method_getNumberOfArguments(mth) > 0;
}

#pragma mark - Public
- (void)setSelectedItemIndex:(NSUInteger)index {
    _selectedItemIndex = index;
    if (index >= self.items.count) {
        return;
    }
    [self.items enumerateObjectsUsingBlock:^(BNCToolbarItem *item, NSUInteger idx, BOOL *_Nonnull stop) {
        item.selected = NO;
        if (idx == index) {
            item.selected = YES;
        }
    }];
    [self updateIndicatorView];
}

- (void)updateIndicatorPosition:(CGPoint)position {
    CGRect frame = self.indicatorView.frame;
    CGPoint center = self.indicatorView.center;

    CGFloat offsetX = position.x / kScreenWidth;
    CGFloat itemWidth = kScreenWidth / self.items.count;

    center.x = offsetX * itemWidth + itemWidth / 2; //设置要移动的中心点位置

    NSUInteger index0 = offsetX;       //当前点所在的item下标
    NSUInteger index1 = ceil(offsetX); //下一个item所在的下标
    if ((index0 != index1) && (index0 < self.items.count && index1 < self.items.count)) {
        BNCToolbarItem *item0 = self.items[index0];
        BNCToolbarItem *item1 = self.items[index1];

        CGFloat w = item1.titleWidth - item0.titleWidth; // 计算出每次移动要增加的宽度
        CGFloat c0 = item0.center.x;
        CGFloat c1 = item1.center.x;
        CGFloat dist = c1 - c0; //计算每次移动时候,两个item项的中心点距离

        //计算出每次移动时候，宽度变化的增量
        CGFloat inc = w * (center.x - c0) / dist;
        if (isnan(inc)) { //因为计算到最后,当移动的中心点和目标中心点会重合,此时会出现除0的操作
            inc = w;
        }
        frame.size.width = inc + item0.titleWidth;
    }

    self.indicatorView.frame = frame;
    self.indicatorView.center = center;
}

#pragma mark - Private
- (void)adjuestItemPosition {
    if (self.items.count == 0 || !_needLayoutItem) {
        return;
    }
    _needLayoutItem = NO;
    CGRect bounds = self.bounds;
    CGFloat itemHeight = CGRectGetHeight(bounds);
    CGFloat itemWidth = CGRectGetWidth(bounds) / self.items.count;
    for (NSInteger i = 0; i < self.items.count; ++i) {
        BNCToolbarItem *item = self.items[i];
        item.frame = CGRectMake(i * itemWidth, 0, itemWidth, itemHeight);
        if (self.selectedItemIndex == i) {
            item.selected = YES;
        }
    }
    [self updateIndicatorView];
}

- (void)updateIndicatorView {
    self.indicatorView.hidden = !self.isShowIndicator;
    [UIView animateWithDuration:0.25
                     animations:^{
                         BNCToolbarItem *item = self.items[self.selectedItemIndex];
                         CGRect frame = self.indicatorView.frame;
                         frame.size.width = item.titleWidth;
                         frame.origin.x = item.center.x - item.titleWidth / 2;
                         self.indicatorView.frame = frame;
                     }];
}

#pragma mark - Lazy Loads
- (BNCToolbarIndicator *)indicatorView {
    if (!_indicatorView) {
        _indicatorView = [[BNCToolbarIndicator alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 3, 0, 3)];
    }
    return _indicatorView;
}

#pragma mark - Custom Accessors
- (void)setItems:(NSArray *)items {
    _needLayoutItem = YES;
    _items = items;
    [_items enumerateObjectsUsingBlock:^(BNCToolbarItem *item, NSUInteger idx, BOOL *_Nonnull stop) {
        [self addSubview:item];
        item.tag = idx;
        [item addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchUpInside];
    }];
    [self layoutIfNeeded];
}

@end

#pragma mark - BNCToolbarItem

@interface BNCToolbarItem ()
@property (nonatomic, assign) CGFloat titleWidth;
@end

@implementation BNCToolbarItem

+ (instancetype)itemWithTitle:(NSString *)title {
    BNCToolbarItem *item = [[self class] buttonWithType:UIButtonTypeCustom];
    [item setTitle:title forState:UIControlStateNormal];
    [item setTitleColor:UIColorFromHexValue(0x888888) forState:UIControlStateNormal];
    [item setTitleColor:kButtonNormalColor forState:UIControlStateSelected];
    item.titleLabel.font = [UIFont systemFontOfSize:kTipTextFontSize];

    item.titleWidth = [title widthForFont:item.titleLabel.font];
    return item;
}

- (NSString *)title {
    return [self titleForState:UIControlStateNormal];
}

@end

#pragma mark - BNCToolbarIndicator

@implementation BNCToolbarIndicator
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.tintColor = kButtonNormalColor;
        self.backgroundColor = self.tintColor;
    }
    return self;
}
@end
