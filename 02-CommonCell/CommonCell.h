//
//  CommonCell.h
//  BNRetail
//
//  Created by wuzhou on 2018/3/2.
//  Copyright © 2018年 Baoneng. All rights reserved.
//

typedef enum {
    ENUM_MAIN_LABEL = 1,
    ENUM_MAIN_IMAGE_LABEL,
    ENUM_MAIN_LABEL_IMAGE,
}enumMainType;

typedef enum {
    ENUM_SUB_ARROW = 1,
    ENUM_SUB_LABEL,
    ENUM_SUB_LABEL_ARROW,
    ENUM_SUB_IMAGE,
    ENUM_SUB_IMAGE_ARROW,
    ENUM_SUB_NOTHING,
}enumSubType;

typedef void (^CommonCellClickBlock)(void);

@interface CommonCell : UIView

- (void)setMainType:(int)type;
- (void)setSubType:(int)type;
- (void)setMainLabelText:(NSString *)mainLabelText;
- (void)setMainImagePath:(NSString *)mainImagePath;
- (void)setMainLabelColor:(UIColor *)color;
- (void)increaseMainLabelWidth;
- (void)setSubLabelText:(NSString *)subLabelText;
- (void)setSubLabelTextColor:(UIColor *)color;
- (void)setSubImagePath:(NSString *)subImagePath;
- (void)setLineEdg:(UIEdgeInsets)inset;

@property (nonatomic, assign) BOOL deleteBottonLine;

- (void)setVisible;
- (void)setInvisible;
- (void)setLineInvisible;
- (void)setEnable:(BOOL)enable;

+ (NSUInteger)getCellHeight;

@property (nonatomic, copy) CommonCellClickBlock cellClickBlock;

@end

