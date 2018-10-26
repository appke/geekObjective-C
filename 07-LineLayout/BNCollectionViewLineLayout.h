//
//  BNCollectionViewLineLayout.h
//  BNMarket
//
//  Created by MGBook on 2018/10/23.
//  Copyright © 2018 Baoneng. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol BNCollectionViewLineLayoutDelegate <NSObject>
@required
/// 返回cell大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;
@end

@interface BNCollectionViewLineLayout : UICollectionViewLayout

@property (nonatomic,weak) id<BNCollectionViewLineLayoutDelegate> delegate;
/// 距离上下左右的距离
@property (nonatomic,assign) UIEdgeInsets sectionInsets;
/// 上下两个item的距离
@property (nonatomic,assign) CGFloat lineSpacing;
/// 左右两个item的距离
@property (nonatomic,assign) CGFloat interitemSpacing;
@end
