//
//  MGWaterflowLayout.m
//  57-瀑布流
//
//  Created by 穆良 on 16/4/24.
//  Copyright © 2016年 穆良. All rights reserved.
//

#import "MGWaterflowLayout.h"

/** 默认的列数 */
static const NSInteger MGDefaultColumnCount = 3;
/** 每一列之间的间距 */
static const NSInteger MGDefaultColumnMargin = 10;
/** 每一行之间的间距 */
static const NSInteger MGDefaultRowMargin = 10;
/** 边缘间距 */
static const UIEdgeInsets MGDefaultEdgeInsets = {10, 10, 10, 10};

@interface MGWaterflowLayout ()
/** 存放所有cell的布局属性 */
@property (nonatomic, strong) NSMutableArray *attrsArray;
/** 存放所有列的当前最大高度 */
//@property (nonatomic, strong) NSMutableDictionary *maxHeightDict;
///** 存放所有列的当前最大高度 */
@property (nonatomic, strong) NSMutableArray *columnHeights;

/** 内容的高度 */
@property (nonatomic, assign) CGFloat contentHeight;

- (NSInteger)columnCount;
- (CGFloat)columnMargin;
- (CGFloat)rowMargin;
- (UIEdgeInsets)edgeInsets;
@end

@implementation MGWaterflowLayout

#pragma mark - 代理方法处理
- (NSInteger)columnCount
{
    if ([self.delegate respondsToSelector:@selector(columnCountInWaterflowLayout:)]) {
        return [self.delegate columnCountInWaterflowLayout:self];
    } else {
        return MGDefaultColumnCount;
    }
}

- (CGFloat)columnMargin
{
    if ([self.delegate respondsToSelector:@selector(rowMarginInWaterflowLayout:)]) {
        return [self.delegate columnMarginInWaterflowLayout:self];
    } else {
        return MGDefaultColumnMargin;
    }
}

- (CGFloat)rowMargin
{
    if ([self.delegate respondsToSelector:@selector(rowMarginInWaterflowLayout:)]) {
        return [self.delegate rowMarginInWaterflowLayout:self];
    } else {
        return MGDefaultRowMargin;
    }
}

- (UIEdgeInsets)edgeInsets
{
    if ([self.delegate respondsToSelector:@selector(edgeInsetsInWaterflowLayout:)]) {
        return [self.delegate edgeInsetsInWaterflowLayout:self];
    } else {
        return MGDefaultEdgeInsets;
    }
}

#pragma mark - 懒加载
- (NSMutableArray *)columnHeights
{
    if (!_columnHeights) {
        _columnHeights = [NSMutableArray array];
    }
    return _columnHeights;
}

- (NSMutableArray *)attrsArray
{
    if (!_attrsArray) {
        _attrsArray = [NSMutableArray array];
    }
    return _attrsArray;
}

/**
 *  初始化
 */
- (void)prepareLayout
{
    [super prepareLayout];

    self.contentHeight = 0;
    
    // 清除以前计算的所有高度
    [self.columnHeights removeAllObjects];
    for (int i = 0; i < self.columnCount; i++) {
        self.columnHeights[i] = @(self.edgeInsets.top);
    }
    
    // 清除之前所有的布局属性-不然数组会越来越大
    [self.attrsArray removeAllObjects];
    
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    // 创建一个cell对应的布局属性
    for (int i = 0; i < count; i++) {
        // 创建位置
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        // 获取indexPath位置cell对应的 布局属性
        UICollectionViewLayoutAttributes *attrs = [self layoutAttributesForItemAtIndexPath:indexPath];
        [self.attrsArray addObject:attrs];
    }
}


/**
 *  决定cell的排布
 */
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return self.attrsArray;
}

/**
 *  返回indexPath位置cell对应的布局属性
 */
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 创建布局属性
    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    // collectionView的宽度
    CGFloat collectionViewW = self.collectionView.frame.size.width;

    CGFloat w = (collectionViewW - self.edgeInsets.left - self.edgeInsets.right - (self.columnCount - 1) * self.columnMargin) / self.columnCount;
    
    // item的高度- 必须实现的方法,不用判断
    CGFloat h = [self.delegate waterflowLayout:self heightForItemAtIndex:indexPath.item itemWidth:w];
    
    // 找出高度最短的那列
    NSInteger destColumn = 0;
    CGFloat minColumnHeight = [self.columnHeights[0] floatValue];
    for (int i = 1; i < self.columnCount; i++) {
        if ([self.columnHeights[i] floatValue] < minColumnHeight) {
            minColumnHeight = [self.columnHeights[i] floatValue];
            destColumn = i;
        }
    }
    CGFloat x = self.edgeInsets.left + (w + self.columnMargin) * destColumn;
    CGFloat y = minColumnHeight + self.rowMargin;
    
    if (self.edgeInsets.top == minColumnHeight) {
        y = minColumnHeight;
    }
    
    attrs.frame = CGRectMake(x, y, w, h);
    // 更新 最短那列的高度
    self.columnHeights[destColumn] = @(CGRectGetMaxY(attrs.frame));
    
    // 记录内容的最大高度
    CGFloat columnHeight = [self.columnHeights[destColumn] doubleValue];
    if (self.contentHeight < columnHeight) {
        self.contentHeight = columnHeight;
    }

    return  attrs;
}

- (CGSize)collectionViewContentSize
{
    // 最长高度的那列
//    __block NSUInteger maxHeightColumn = 0;
//    [self.columnHeights enumerateObjectsUsingBlock:^(NSNumber *obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        // 找到最大高度的列
//        if ([self.columnHeights[maxHeightColumn] floatValue] < obj.floatValue) {
//            maxHeightColumn = idx;
//        }
//    } ];
    
    CGFloat contentH = self.contentHeight + self.edgeInsets.bottom;
    
    return CGSizeMake(0, contentH);
}

@end
