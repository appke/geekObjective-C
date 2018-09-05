//
//  AlertController.h
//  BNRetail
//
//  Created by wuzhou on 2018/3/8.
//  Copyright © 2018年 Baoneng. All rights reserved.
//

typedef void (^AlertActionBlock)(UIAlertAction *);

@interface AlertController : UIView

@property (nonatomic, copy) NSString *warningTitle;
@property (nonatomic, copy) NSString *warningText;
@property (nonatomic, copy) NSString *warningBtnText;
@property (nonatomic, copy) AlertActionBlock warningBlock;
- (void)showWarningOnVC:(id)vc;

@property (nonatomic, copy) NSString *confirmTitle;
@property (nonatomic, copy) NSString *confirmText;
@property (nonatomic, copy) NSString *confirmYesBtnText;
@property (nonatomic, copy) NSString *confirmNoBtnText;
@property (nonatomic, copy) AlertActionBlock confirmYesBlock;
@property (nonatomic, copy) AlertActionBlock confirmNoBlock;
@property (nonatomic, assign) UIAlertActionStyle confirmYesStyle;
@property (nonatomic, assign) UIAlertActionStyle confirmNoStyle;
- (void)showConfirmOnVC:(id)vc;

@property (nonatomic, copy) NSString *sheetTitle;
@property (nonatomic, copy) NSString *sheetConfirmText;
@property (nonatomic, copy) NSString *sheetCancelText;
@property (nonatomic, strong) NSArray <NSString *>*othersText;
@property (nonatomic, copy) AlertActionBlock sheetCancelBlock;
@property (nonatomic, copy) AlertActionBlock sheetChoiceBlock;

- (void)showSheetOnVC:(id)vc;

@end
