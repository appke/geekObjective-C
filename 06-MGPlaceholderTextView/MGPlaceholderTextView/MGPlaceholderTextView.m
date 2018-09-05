//
//  MGTextView.m
//  MGWeibo
//
//  Created by 穆良 on 15/11/8.
//  Copyright © 2015年 穆良. All rights reserved.
//

#import "MGPlaceholderTextView.h"
#import "UIView+MGExtension.h"


@interface MGPlaceholderTextView ()

@property (nonatomic, weak) UILabel *placeholderLabel;

@end

@implementation MGPlaceholderTextView

- (UILabel *)placeholderLabel
{
    if (!_placeholderLabel) {
        // 添加一个显示占位文字的label
        UILabel *placeholderLabel = [[UILabel alloc] init];
        placeholderLabel.numberOfLines = 0;
        placeholderLabel.x = 4;
        placeholderLabel.y = 7;
        
        [self addSubview:placeholderLabel];
        _placeholderLabel = placeholderLabel;
        
    }
    return _placeholderLabel;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {

        // 垂直方向永远能拖拽
        self.alwaysBounceVertical = YES;
        // 默认字体
        self.font = [UIFont systemFontOfSize:15];
        // 默认占位文字颜色
        self.placeholderColor = [UIColor grayColor];
        
        // 监听文字的改变
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:nil];
    }
    
    return self;
}

/**
 *  等你有宽度时 调用下
 */
- (void)layoutSubviews
{
    [super layoutSubviews];
    
//    self.placeholderLabel.backgroundColor = [UIColor redColor];
    self.placeholderLabel.width = self.width - 2 * self.placeholderLabel.x;
    [self.placeholderLabel sizeToFit];
}

/**
 *  监听文字的改变
 */
- (void)textDidChange {
    // 只要有文字, 就隐藏placeholderLabel
    self.placeholderLabel.hidden = (self.text.length != 0);
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 重写setter
- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = [placeholder copy];
    self.placeholderLabel.text = placeholder;
    [self setNeedsLayout];
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    _placeholderColor = placeholderColor;
    self.placeholderLabel.textColor = placeholderColor;
}

- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    self.placeholderLabel.font = font;
    [self setNeedsLayout];
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    [self textDidChange];
}

- (void)setAttributedText:(NSAttributedString *)attributedText
{
    [super setAttributedText:attributedText];
    [self textDidChange];
}

@end
