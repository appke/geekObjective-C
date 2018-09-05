//
//  BNCRootView.m
//  BNRetail
//
//  Created by 刘晓恒 on 2018/7/17.
//  Copyright © 2018年 Baoneng. All rights reserved.
//

#import "BNCRootView.h"

#define kToolBarHeight 44

@interface BNCRootView () <UIScrollViewDelegate> {
    struct {
        unsigned int rootViewDidMoveToOffset : 1;
        unsigned int rootViewDidChangeToIndex : 1;
    } flags;
}

@property (nonatomic, strong) UIScrollView *containView;

@end

@implementation BNCRootView

#pragma mark - Initial Methods
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

#pragma mark - Lifecycle
- (void)layoutSubviews {
    [super layoutSubviews];
    self.containView.frame = CGRectMake(0, kToolBarHeight, kScreenWidth, CGRectGetHeight(self.frame) - kToolBarHeight);
    self.containView.contentSize = CGSizeMake(self.toolBar.items.count * CGRectGetWidth(self.frame), 0);

    [self.containView.subviews enumerateObjectsUsingBlock:^(__kindof UIView *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        obj.frame = CGRectOffset(self.containView.bounds, idx * kScreenWidth, 0);
    }];
}

#pragma mark - Actions

#pragma mark - Public
- (void)addChildView:(UIView *)orderView atIndex:(NSUInteger)index {
    orderView.frame = CGRectMake(index * kScreenWidth, 0, CGRectGetWidth(self.containView.frame), CGRectGetHeight(self.containView.frame));
    [self.containView addSubview:orderView];
}

- (void)switchControllerWithIndex:(NSUInteger)index {
    [self switchControllerWithIndex:index animated:YES];
}

- (void)switchControllerWithIndex:(NSUInteger)index animated:(BOOL)animated {
    self.toolBar.selectedItemIndex = index;
    if (animated) {
        [UIView animateWithDuration:0.25
                         animations:^{ //实现滚动动画,但是不执行ScrollViewDelegate
                             [self.containView setContentOffset:CGPointMake(index * kScreenWidth, 0) animated:NO];
                         }];
    } else {
        [self.containView setContentOffset:CGPointMake(index * kScreenWidth, 0) animated:NO];
    }
}

#pragma mark - Protocol conformance
#pragma mark UIScrollViewDelegate
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    NSUInteger index = scrollView.contentOffset.x / CGRectGetWidth(scrollView.frame);
    self.toolBar.selectedItemIndex = index;
    if (flags.rootViewDidChangeToIndex) {
        [self.delegate rootView:self didChangeToIndex:index];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self scrollViewDidEndScrollingAnimation:scrollView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint offset = scrollView.contentOffset;
    [self.toolBar updateIndicatorPosition:offset];
    if (flags.rootViewDidMoveToOffset) {
        [self.delegate rootView:self didMoveToOffset:offset];
    }
}

#pragma mark - Private
- (void)setup {
    [self addSubview:self.toolBar];
    [self addSubview:self.containView];
}

#pragma mark - Lazy Loads
- (BNCToolbar *)toolBar {
    if (!_toolBar) {
        _toolBar = [[BNCToolbar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kToolBarHeight)];
    }
    return _toolBar;
}

- (UIScrollView *)containView {
    if (!_containView) {
        _containView = [[UIScrollView alloc] init];
        _containView.showsVerticalScrollIndicator = NO;
        _containView.showsHorizontalScrollIndicator = NO;
        _containView.pagingEnabled = YES;
        _containView.delegate = self;
    }
    return _containView;
}

#pragma mark - Custom Accessors
- (void)setDelegate:(id<BNCRootViewDelegate>)delegate {
    _delegate = delegate;

    flags.rootViewDidChangeToIndex = [delegate respondsToSelector:@selector(rootView:didChangeToIndex:)];
    flags.rootViewDidMoveToOffset = [delegate respondsToSelector:@selector(rootView:didMoveToOffset:)];
}

@end
