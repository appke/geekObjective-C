//
//  AlertController.m
//  BNRetail
//
//  Created by wuzhou on 2018/3/8.
//  Copyright © 2018年 Baoneng. All rights reserved.
//

#import "AlertController.h"

@interface AlertController()

@end

@implementation AlertController

- (void)dealloc {
    
    
}

- (id)init {
    self = [super init];
    if (self) {
        [self initWarning];
        [self initConfirm];
    }
    return self;
}

- (void)initWarning {
    self.warningTitle = nil;
    self.warningText = nil;
    self.warningBtnText = @"好的";
    self.warningBlock = nil;
}

- (void)initConfirm {
    self.confirmTitle = nil;
    self.confirmText = nil;
    self.confirmYesBtnText = @"确认";
    self.confirmNoBtnText = @"取消";
    self.confirmYesBlock = nil;
    self.confirmNoBlock = nil;
    self.confirmYesStyle = UIAlertViewStyleDefault;
    self.confirmNoStyle = UIAlertActionStyleCancel;
}

- (void)showWarningOnVC:(id)vc {
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:self.warningTitle
                                                                message:self.warningText
                                                         preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:self.warningBtnText
                                                       style:UIAlertActionStyleDefault
                                                     handler:self.warningBlock];
    [ac addAction:okAction];
    [vc presentViewController:ac animated:YES completion:nil];
}

- (void)showConfirmOnVC:(id)vc {
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:self.confirmTitle
                                                                message:self.confirmText
                                                         preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:self.confirmYesBtnText
                                                       style:self.confirmYesStyle
                                                     handler:self.confirmYesBlock];
    [ac addAction:okAction];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:self.confirmNoBtnText
                                                           style:self.confirmNoStyle
                                                         handler:self.confirmNoBlock];
    [ac addAction:cancelAction];
    [vc presentViewController:ac animated:YES completion:nil];
}

- (void)showSheetOnVC:(id)vc {
    
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:self.sheetTitle
                                                                message:self.sheetConfirmText
                                                         preferredStyle:UIAlertControllerStyleActionSheet];
    
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:self.sheetCancelText style:UIAlertActionStyleCancel handler:self.sheetCancelBlock];
            [ac addAction:cancelAction];
            for (NSString *title in self.othersText) {
                
                UIAlertAction *act = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:self.sheetChoiceBlock];
                [ac addAction:act];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [vc presentViewController:ac animated:YES completion:nil];
            });
        });
}

@end
