//
//  CommonCell.m
//  BNRetail
//
//  Created by wuzhou on 2018/3/2.
//  Copyright © 2018年 Baoneng. All rights reserved.
//

#import "CommonCell.h"

static const NSUInteger cellHeight = 48;

@interface CommonCell()

@property (nonatomic, strong) UILabel *mainLabel;
@property (nonatomic, strong) UILabel *subLabel;
@property (nonatomic, strong) UIImageView *mainImageView;
@property (nonatomic, strong) UIImageView *arrowImageView;
@property (nonatomic, strong) UIImageView *subImageView;
@property (nonatomic, strong) UIImageView *line;

@property (nonatomic) BOOL isEnable;    // 是否相应点击事件

@end

@implementation CommonCell

@synthesize mainLabel, mainImageView, subLabel, arrowImageView, subImageView, line;
@synthesize isEnable;

- (id)init {
    self = [super init];
    if (self) {
        //        self.layer.borderWidth = kSingleLineWidth;
        //        self.layer.borderColor = kSingleLineColor.CGColor;
        self.backgroundColor = [UIColor whiteColor];
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(cellHeight);
        }];
        
        // main区，mainLabel，mainImageView
        mainLabel = [[UILabel alloc] init];
        mainLabel.textColor = kTextColor333;
        mainLabel.font = [UIFont systemFontOfSize:kCellMainSize];
        mainLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:mainLabel];
        
        mainImageView = [[UIImageView alloc] init];
        [self addSubview:mainImageView];
        
        // sub区，arrow，subImageView，subLabel
        arrowImageView = [[UIImageView alloc] init];
        arrowImageView.image = [UIImage imageNamed:@"icon_right"];
        [self addSubview:arrowImageView];
        
        subLabel = [[UILabel alloc] init];
        subLabel.textColor = kTextColor999;
        subLabel.font = [UIFont systemFontOfSize:kCellSubSize];
        subLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:subLabel];
        
        subImageView = [[UIImageView alloc] init];
        [self addSubview:subImageView];
        
        // 默认
        // main区只有Label
        [mainLabel setHidden:NO];
        [mainImageView setHidden:YES];
        [mainLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.and.bottom.equalTo(self);
            make.left.equalTo(self).with.offset(15);
            make.right.equalTo(self.mas_centerX).offset(80);
        }];
        
        // line，与mainLabel左对齐
        line = [[UIImageView alloc] init];
        line.backgroundColor = kSeperatorLineColor;
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(mainImageView);
            make.right.and.bottom.equalTo(self);
            make.height.mas_equalTo(0.5);
        }];
        
        // 只有arrow
        [arrowImageView setHidden:NO];
        [subLabel setHidden:YES];
        [subImageView setHidden:YES];
        [arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.right.equalTo(self).with.offset(-15);
            make.width.and.height.mas_equalTo(arrowSize);
        }];
        
        // 默认可点击
        isEnable = YES;
    }
    return self;
}

- (void)setMainType:(int)type {
    switch (type) {
        case ENUM_MAIN_LABEL:
        {
            // main区只有Label
            [mainLabel setHidden:NO];
            [mainImageView setHidden:YES];
            [mainLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.and.bottom.equalTo(self);
                make.left.equalTo(self).with.offset(15);
                make.right.equalTo(self.mas_centerX).offset(80);
            }];
            break;
        }
        case ENUM_MAIN_IMAGE_LABEL:
        {
            // main区为左图右label模式
            [mainLabel setHidden:NO];
            [mainImageView setHidden:NO];
            [mainImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self);
                make.width.and.height.mas_equalTo(20);
                make.left.equalTo(self).with.offset(15);
            }];
            [mainLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.and.bottom.equalTo(self);
                make.left.equalTo(mainImageView.mas_right).with.offset(15);
                make.right.equalTo(self.mas_centerX);
            }];
            break;
        }
        case ENUM_MAIN_LABEL_IMAGE:
        {
            // main区为左label右图模式
            [mainLabel setHidden:NO];
            [mainImageView setHidden:NO];
            [mainLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.and.bottom.equalTo(self);
                make.left.equalTo(self).with.offset(15);
                make.right.equalTo(self.mas_centerX).offset(80);
            }];
            [mainImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self);
                make.width.and.height.mas_equalTo(20);
                make.left.equalTo(self).with.offset(15);
            }];
            break;
        }
        default:
        {
            // main区只有Label
            [mainLabel setHidden:NO];
            [mainImageView setHidden:YES];
            [mainLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.and.bottom.equalTo(self);
                make.left.equalTo(self).with.offset(15);
                make.right.equalTo(self.mas_centerX).offset(80);
            }];
            break;
        }
    }
}

- (void)setSubType:(int)type {
    switch (type) {
        case ENUM_SUB_ARROW:
        {
            // 只有arrow
            [arrowImageView setHidden:NO];
            [subLabel setHidden:YES];
            [subImageView setHidden:YES];
            [arrowImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self);
                make.right.equalTo(self).with.offset(-15);
                make.width.and.height.mas_equalTo(arrowSize);
            }];
            break;
        }
        case ENUM_SUB_LABEL:
        {
            // 只有文字
            [arrowImageView setHidden:YES];
            [subLabel setHidden:NO];
            [subImageView setHidden:YES];
            [subLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.and.bottom.equalTo(self);
                make.left.equalTo(self.mas_centerX);
                make.right.equalTo(self).with.offset(-15);
            }];
            break;
        }
        case ENUM_SUB_LABEL_ARROW:
        {
            // 左文字右arrow
            [arrowImageView setHidden:NO];
            [subLabel setHidden:NO];
            [subImageView setHidden:YES];
            [arrowImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self);
                make.right.equalTo(self).with.offset(-15);
                make.width.and.height.mas_equalTo(arrowSize);
            }];
            [subLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.and.bottom.equalTo(self);
                make.left.equalTo(self.mas_centerX);
                make.right.equalTo(arrowImageView.mas_left);
            }];
            break;
        }
        case ENUM_SUB_IMAGE:
        {
            // 只有图
            [arrowImageView setHidden:YES];
            [subLabel setHidden:YES];
            [subImageView setHidden:NO];
            [subImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self);
                make.width.and.height.mas_equalTo(32);
                make.right.equalTo(self).with.offset(-15);
            }];
            break;
        }
        case ENUM_SUB_IMAGE_ARROW:
        {
            // 左图右arrow
            [arrowImageView setHidden:NO];
            [subLabel setHidden:YES];
            [subImageView setHidden:NO];
            [arrowImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self);
                make.right.equalTo(self).with.offset(-15);
                make.width.and.height.mas_equalTo(arrowSize);
            }];
            [subImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self);
                make.width.and.height.mas_equalTo(32);
                make.right.equalTo(arrowImageView.mas_left);
            }];
            break;
        }
        case ENUM_SUB_NOTHING:
        {
            // 什么都没有
            [arrowImageView setHidden:YES];
            [subLabel setHidden:YES];
            [subImageView setHidden:YES];
            break;
        }
        default:
        {
            // 只有arrow
            [arrowImageView setHidden:NO];
            [subLabel setHidden:YES];
            [subImageView setHidden:YES];
            [arrowImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self);
                make.right.equalTo(self).with.offset(-15);
                make.width.and.height.mas_equalTo(arrowSize);
            }];
            break;
        }
    }
}

- (void)setMainLabelText:(NSString*)mainLabelText {
    mainLabel.text = mainLabelText;
}

- (void)setMainImagePath:(NSString *)mainImagePath {
    mainImageView.image = [UIImage imageNamed:mainImagePath];
    
    // 默认Main的图是紧贴在文字后边的
    CGRect textRect = [mainLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 30)
                                                   options:NSStringDrawingTruncatesLastVisibleLine |  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}
                                                   context:nil];
    CGFloat width = textRect.size.width;
    [mainImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.width.and.height.mas_equalTo(20);
        make.left.equalTo(self).with.offset(15 + width);
    }];
}

- (void)setMainLabelColor:(UIColor *)color {
    mainLabel.textColor = color;
}

- (void)increaseMainLabelWidth {
    [mainLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_centerX).offset(100);
    }];
}

- (void)setSubLabelText:(NSString *)subLabelText {
    subLabel.text = subLabelText;
}

- (void)setSubLabelTextColor:(UIColor *)color {
    subLabel.textColor = color;
}

- (void)setLineEdg:(UIEdgeInsets)inset {
    
    CGFloat left = inset.left;
    CGFloat right = inset.right;
    CGFloat bottom = inset.bottom;
    
    [line mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(mainImageView).mas_offset(left);
        make.right.equalTo(self).mas_offset(- right);
        make.bottom.equalTo(self).mas_offset(- bottom);
        make.height.mas_equalTo(0.5);
    }];
}

- (void)setSubImagePath:(NSString *)subImagePath  {
    subImageView.image = [UIImage imageNamed:subImagePath];
    CGSize size = subImageView.image.size;
    if (arrowImageView.hidden == YES) {
        [subImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.width.mas_equalTo(size.width);
            make.height.mas_equalTo(size.height);
            make.right.equalTo(self).with.offset(-twoSidesOffset);
        }];
    }else{
        [subImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.width.mas_equalTo(size.width);
            make.height.mas_equalTo(size.height);
            make.right.equalTo(arrowImageView.mas_left);
        }];
    }
    
    [self layoutIfNeeded];
}

- (void)setVisible {
    [self setHidden:NO];
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(cellHeight);
    }];
}

// 该函数使Cell的高度变成0，这样在界面不用显示此Cell时，不用去动态调整下面Cell的位置了
- (void)setInvisible {
    [self setHidden:YES];
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0);
    }];
}

- (void)setEnable:(BOOL)enable {
    isEnable = enable;
}

+ (NSUInteger)getCellHeight {
    return cellHeight;
}

// 下面的横线不可见，用在该页面的最后一个cell
- (void)setLineInvisible {
    [line removeFromSuperview];
}

- (void)setCellClickBlock:(CommonCellClickBlock)cellClickBlock {
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id gesture) {
        if (cellClickBlock) {
            cellClickBlock();
        }
    }];
    [self addGestureRecognizer:tapGesture];
}
@end

