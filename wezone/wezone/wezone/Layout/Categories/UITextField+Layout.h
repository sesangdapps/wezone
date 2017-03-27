//
//  UITextField+Layout.h
//  sobane
//
//  Created by Kim Sunmi on 2017. 1. 29..
//  Copyright © 2017년 Kim Sunmi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+Layout.h"


@interface UITextField(Layout)

- (instancetype)init:(CGRect)rect parent:(UIView*)parent tag:(NSInteger)tag text:(NSString *)text placeholder:(NSString*)placeholder color:(UIColor *)color align:(NSTextAlignment)align font:(NSString*)font size:(CGFloat)size type:(UIKeyboardType)type password:(BOOL)password delegate:(id<UITextFieldDelegate>)delegate;

- (instancetype)addBackgroundImage:(NSString *)bgImageName;
- (instancetype)addBackgroundColor:(UIColor *)bgColor;

-(void) setLeftPadding:(int) paddingValue;
-(void) setRightPadding:(int) paddingValue;
@end

//@interface UIBorderTextField : UITextField
//
//
//@property (strong, nonatomic) UIColor *bgNormalColor;
//@property (strong, nonatomic) UIColor *bgHighlightedColor;
//@property (strong, nonatomic) UIColor *bgDisabledColor;
//@property (strong, nonatomic) UIColor *bgErrorColor;
//
//@property (strong, nonatomic) UIColor *borderNormalColor;
//@property (strong, nonatomic) UIColor *borderHighlightedColor;
//@property (strong, nonatomic) UIColor *borderDisabledColor;
//@property (strong, nonatomic) UIColor *borderErrorColor;
//
//@property (strong, nonatomic) UIColor *textNormalColor;
//@property (strong, nonatomic) UIColor *textHighlightedColor;
//@property (strong, nonatomic) UIColor *textDisabledColor;
//@property (strong, nonatomic) UIColor *textErrorColor;
//
//
//@property (assign, nonatomic) float borderNormalWidth;
//@property (assign, nonatomic) float borderHighlightedWidth;
//@property (assign, nonatomic) float borderDisabledWidth;
//
//@property (assign, nonatomic) BOOL errorStatus;
//
//- (instancetype)blackStyle;
////- (instancetype)addBackgroundColor:(UIColor *)normalColor highlightedColor:(UIColor *)highlightedColor disabledColor:(UIColor *)disabledColor;
////- (instancetype)addBorderColor:(UIColor *)normalColor highlightedColor:(UIColor *)highlightedColor disabledColor:(UIColor *)disabledColor width:(float)width corner:(float)corner;
////- (instancetype)adTextColor:(UIColor *)normalColor highlightedColor:(UIColor *)highlightedColor disabledColor:(UIColor *)disabledColor width:(float)width corner:(float)corner;
////- (instancetype)addBorderWidth:(float)normalWidth highlightedWidth:(float)highlightedWidth disabledWidth:(float)disabledWidth;
//
//- (void)makeNormalState;
//- (void)makeHighlightedState;
//- (void)makeDisabledState;
//- (void)makeErrorState;
//    
//@end
