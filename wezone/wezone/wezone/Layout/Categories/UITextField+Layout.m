//
//  UITextField+Layout.m
//  sobane
//
//  Created by Kim Sunmi on 2017. 1. 29..
//  Copyright © 2017년 Kim Sunmi. All rights reserved.
//

#import "UITextField+Layout.h"
#import "UIFont+Layout.h"

@implementation UITextField(Layout)

-(instancetype) init:(CGRect)rect parent:(UIView*)parent tag:(NSInteger)tag text:(NSString *)text placeholder:(NSString*)placeholder color:(UIColor *)color align:(NSTextAlignment)align font:(NSString*)font size:(CGFloat)size type:(UIKeyboardType)type password:(BOOL)password delegate:(id<UITextFieldDelegate>)delegate {
    
    self = [self init:rect parent:parent tag:tag];
    
    if ( color) [self setTextColor:color];
    [self setFont:[UIFont defalutFont:font size:size]];
    if ( placeholder ) [self setPlaceholder:placeholder];
    if ( text ) [self setText:text];
    
    [self setTextAlignment:align];

    
    if ( delegate )[self setDelegate:delegate];
    [self setKeyboardType:type];
    [self setSecureTextEntry:password];
    
    [self setLeftPadding:10];
    [self setRightPadding:10];
    
    [self setReturnKeyType:UIReturnKeyDone];
    
    return self;
}

- (instancetype)addBackgroundImage:(NSString *)bgImageName {
    
    [self setBackground:[UIImage imageNamed:bgImageName]];
    
    return self;
}

- (instancetype)addBackgroundColor:(UIColor *)bgColor {
    
    [self setBackgroundColor:bgColor];
    
    return self;
}

-(void) setLeftPadding:(int) paddingValue {
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, paddingValue, self.frame.size.height)];
    self.leftView = paddingView;
    self.leftViewMode = UITextFieldViewModeAlways;
}

-(void) setRightPadding:(int) paddingValue {
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, paddingValue, self.frame.size.height)];
    self.rightView = paddingView;
    self.rightViewMode = UITextFieldViewModeAlways;
}



//+ (UITextField *) create:(CGRect)rect parent:(UIView*)parent tag:(NSInteger)tag text:(NSString *)text placeholder:(NSString*)placeholder bgImageName:(NSString *)bgImageName color:(UIColor *)color align:(NSTextAlignment)align font:(NSString*)font size:(CGFloat)size type:(UIKeyboardType)type password:(BOOL)password delegate:(id<UITextFieldDelegate>)delegate rightImage:(NSString *)rightImage {
//    
//    UITextField *view = [self create:rect parent:parent tag:tag text:text placeholder:placeholder bgImageName:bgImageName color:color align:align font:font size:size type:type password:password delegate:delegate];
//    
//    if ( rightImage ) {
//        view.rightViewMode = UITextFieldViewModeAlways;
//        view.rightView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:rightImage]];
//    }
//    return view;
//}
@end

//@implementation UIBorderTextField
//
////- (instancetype)addBackgroundColor:(UIColor *)normalColor highlightedColor:(UIColor *)highlightedColor disabledColor:(UIColor *)disabledColor {
////    
////    self.bgNormalColor = normalColor;
////    self.bgHighlightedColor = highlightedColor;
////    self.bgDisabledColor = disabledColor;
////    
////    [self makeNormalState];
////    
////    return self;
////}
////
////- (instancetype)addTextColor:(UIColor *)normalColor highlightedColor:(UIColor *)highlightedColor disabledColor:(UIColor *)disabledColor {
////    
////    self.textNormalColor = normalColor;
////    self.textHighlightedColor = highlightedColor;
////    self.textDisabledColor = disabledColor;
////    
////    return self;
////}
////
////- (instancetype)addBorderColor:(UIColor *)normalColor highlightedColor:(UIColor *)highlightedColor disabledColor:(UIColor *)disabledColor width:(float)width corner:(float)corner {
////    
////    self.borderNormalColor = normalColor;
////    self.borderHighlightedColor = highlightedColor;
////    self.borderDisabledColor = disabledColor;
////    
////    self.borderNormalWidth = width;
////    self.borderHighlightedWidth = width;
////    self.borderDisabledWidth = width;
////    
////    [self makeNormalState];
////    
////    return self;
////}
////
////- (instancetype)addBorderWidth:(float)normalWidth highlightedWidth:(float)highlightedWidth disabledWidth:(float)disabledWidth {
////    
////    self.borderNormalWidth = normalWidth;
////    self.borderHighlightedWidth = highlightedWidth;
////    self.borderDisabledWidth = disabledWidth;
////    
////    return self;
////}
//
//- (void)makeNormalState {
//    
//    [self setBackgroundColor:self.bgNormalColor];
//    [self.layer setBorderWidth:self.borderNormalWidth];
//    
////    if ( self.status == 0 ) {
////        [self.layer setBorderColor:self.borderNormalColor.CGColor];
////        [self setTextColor:self.textNormalColor];
////    } else if ( self.status == 1 ) {
////        [self.layer setBorderColor:self.borderErrorColor.CGColor];
////        [self setTextColor:self.textErrorColor];
////    } else if ( self.status == 2 ) {
////        [self.layer setBorderColor:self.borderErrorColor.CGColor];
////        [self setTextColor:self.textErrorColor];
////    }
//}
//
//- (void)makeHighlightedState {
//    
//    [self setBackgroundColor:self.bgHighlightedColor];
//    [self.layer setBorderWidth:self.borderHighlightedWidth];
//    
//    [self.layer setBorderColor:self.errorStatus ? self.borderErrorColor.CGColor : self.borderHighlightedColor.CGColor];
//    [self setTextColor:self.errorStatus ? self.textErrorColor : self.textHighlightedColor];
//}
//
//- (void)makeDisabledState {
//    
//    [self setBackgroundColor:self.bgDisabledColor];
//    [self.layer setBorderWidth:self.borderDisabledWidth];
//    
//    [self.layer setBorderColor:self.errorStatus ? self.borderErrorColor.CGColor : self.borderDisabledColor.CGColor];
//    [self setTextColor:self.errorStatus ? self.textErrorColor : self.textDisabledColor];
//}
//
//- (void)makeErrorState {
//        
//    [self.layer setBorderColor:self.borderErrorColor.CGColor];
//    [self setTextColor:self.textErrorColor];
//}
//
//- (instancetype)blackStyle {
//    
//    self.bgNormalColor = COLOR_INPUT_BG;
//    self.bgHighlightedColor = COLOR_INPUT_BG_FOCUS;
//    self.bgDisabledColor = COLOR_INPUT_BG;
//    
//    self.borderNormalColor = COLOR_INPUT_BORDER;
//    self.borderHighlightedColor = COLOR_INPUT_BORDER_FOCUS;
//    self.borderDisabledColor = COLOR_INPUT_BORDER;
//    self.borderErrorColor = COLOR_INPUT_BORDER_ERROR;
//    
//    self.textNormalColor = COLOR_INPUT_TEXT;
//    self.textHighlightedColor = COLOR_INPUT_TEXT_FOCUS;
//    self.textDisabledColor = COLOR_INPUT_TEXT;
//    self.textErrorColor = COLOR_INPUT_TEXT_ERROR;
//    
//    self.borderNormalWidth = 1;
//    self.borderHighlightedWidth = 2;
//    self.borderDisabledWidth = 1;
//    
//    [self makeNormalState];
//    
//    return self;
//}
//@end
