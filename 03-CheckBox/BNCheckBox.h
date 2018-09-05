//
//  BNCheckBox.h
//  BNRetail
//
//  Created by wuzhou on 2018/3/5.
//  Copyright © 2018年 Baoneng. All rights reserved.
//

typedef void (^BNCheckBoxTextLabelClick)(void);
typedef void (^BNCheckBoxSwitchClick)(void);

@interface BNCheckBox: UIView

@property (nonatomic, assign) BOOL isChecked;
@property (nonatomic, copy) BNCheckBoxTextLabelClick clickBlock;
@property (nonatomic, copy) BNCheckBoxSwitchClick switchBlock;
@property (nonatomic, strong) UIButton *checkBtn;

- (void)setText:(NSString *)text;

// 前面那段颜色的字有几个，index就填几
- (void)setAttributeText:(NSString *)text AndIndex:(NSInteger)index;
@end
