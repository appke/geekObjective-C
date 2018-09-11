//
//  UIView+findResponder.m
//  Foundation
//
//  Created by 方立立 on 16/7/15.
//
//

#import "UIView+FindResponder.h"

@implementation UIView(FindResponder)

- (id)findFirstResponder
{
    if([self isFirstResponder]) {
        return self;
    }
    
    for (UIView *subView in self.subviews) {
        id view = [subView findFirstResponder];
        if (view) {
            return view;
        }
    }
    
    return nil;
}

@end
