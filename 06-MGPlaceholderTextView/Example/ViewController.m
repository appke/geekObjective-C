//
//  ViewController.m
//  Example
//
//  Created by 穆良 on 16/4/16.
//  Copyright © 2016年 穆良. All rights reserved.
//

#import "ViewController.h"
#import "MGPlaceholderTextView.h"


@interface ViewController () <UITextViewDelegate>

/** 占位文字textView */
@property (nonatomic, weak) MGPlaceholderTextView *textView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    // 添加一个MGPlaceholderTextView
    MGPlaceholderTextView *textView = [[MGPlaceholderTextView alloc] init];
    textView.frame = self.view.bounds;
    textView.delegate  =self;
    _textView = textView;
    textView.placeholder = @"这是一段占位文字………这是一段占位文字………这是一段占位文字………";
    
    [self.view addSubview:textView];
}

- (IBAction)changeFont:(id)sender {
    
    self.textView.font = [UIFont systemFontOfSize:20];
    
}

- (IBAction)changeColor:(id)sender {
    
    self.textView.placeholderColor = [UIColor redColor];
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

@end
