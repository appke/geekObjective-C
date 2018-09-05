//
//  BNCheckBox.m
//  BNRetail
//
//  Created by wuzhou on 2018/3/5.
//  Copyright © 2018年 Baoneng. All rights reserved.
//

#import "BNCheckBox.h"

@interface BNCheckBox ()


@property (nonatomic, strong) UILabel *textLabel;

@end

@implementation BNCheckBox

- (instancetype)init {
    self = [super init];
    if (self) {
        self.isChecked = NO;
        [self initView];
    }
    return self;
}

- (void)initView {
    self.userInteractionEnabled = YES;
    self.backgroundColor = [UIColor clearColor];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kScreenWidth - 30);
        make.height.mas_equalTo(42);
    }];
    
    [self addSubview:self.checkBtn];
    [self addSubview:self.textLabel];
    
    self.checkBtn.selected = self.isChecked;
}

- (void)layoutSubviews {
    [self.checkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0).with.offset(-5.5);
        make.centerY.equalTo(self);
        make.width.and.height.mas_equalTo(42);
    }];
    
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.checkBtn.mas_right).with.offset(-5.5);
        make.top.and.bottom.and.right.equalTo(self);
    }];
}

- (UIButton *)checkBtn {
    if (_checkBtn == nil) {
        _checkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _checkBtn.selected = YES;
        _isChecked = YES;
        [_checkBtn setImage:[UIImage imageNamed:@"icon_checkbox_def"] forState:UIControlStateNormal];
        [_checkBtn setImage:[UIImage imageNamed:@"icon_checkbox_pre"] forState:UIControlStateSelected];
        [_checkBtn setImageEdgeInsets:UIEdgeInsetsMake(14, 14, 14, 14)];    // 扩大btn的点击区域
        [_checkBtn addTarget:self action:@selector(checkBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _checkBtn;
}

- (UILabel *)textLabel {
    if (_textLabel == nil) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.textColor = UIColorFromHexValue(0x888888);
        _textLabel.font = FONT(12);
        _textLabel.userInteractionEnabled = YES;
        WEAK_SELF
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id gesture) {
            STRONG_SELF
            if (strongSelf.clickBlock) {
                strongSelf.clickBlock();
            }
        }];
        [_textLabel addGestureRecognizer:tap];
    }
    return _textLabel;
}

- (void)checkBtnClick:(id)sender {
    self.isChecked = !self.isChecked;
    self.checkBtn.selected = self.isChecked;
    if (self.switchBlock) {
        self.switchBlock();
    }
}

- (void)setText:(NSString *)text {
    _textLabel.text = text;
}

// 从Index位置开始后面的文字为主题色
- (void)setAttributeText:(NSString *)text AndIndex:(NSInteger)index {
    if (index > text.length) {
        return;
    }
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:text];
    [attribute addAttributes:@{NSForegroundColorAttributeName:UIColorFromHexValue(0x888888)} range:NSMakeRange(0, index)];
    [attribute addAttributes:@{NSForegroundColorAttributeName:kThemeColor} range:NSMakeRange(index, text.length - index)];
    self.textLabel.attributedText = attribute;
}

@end
