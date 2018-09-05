//
//  MGWaterflowLayout.h
//  57-瀑布流
//
//  Created by 穆良 on 16/4/24.
//  Copyright © 2016年 穆良. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MGWaterflowLayout;

@protocol MGWaterflowLayoutDelegate <NSObject>
@required
- (CGFloat)waterflowLayout:(MGWaterflowLayout *)waterflowLayout heightForItemAtIndex:(NSUInteger)index itemWidth:(CGFloat)itemWidth;

@optional
- (NSInteger)columnCountInWaterflowLayout:(MGWaterflowLayout *)waterflowLayout;
- (CGFloat)columnMarginInWaterflowLayout:(MGWaterflowLayout *)waterflowLayout;
- (CGFloat)rowMarginInWaterflowLayout:(MGWaterflowLayout *)waterflowLayout;
- (UIEdgeInsets)edgeInsetsInWaterflowLayout:(MGWaterflowLayout *)waterflowLayout;
@end

@interface MGWaterflowLayout : UICollectionViewLayout
/** 代理 */
@property (nonatomic, weak) id<MGWaterflowLayoutDelegate> delegate;
@end
