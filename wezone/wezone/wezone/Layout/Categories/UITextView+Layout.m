//
//  UITextView+Layout.m
//  sobane
//
//  Created by Kim Sunmi on 2017. 1. 31..
//  Copyright © 2017년 Kim Sunmi. All rights reserved.
//

#import "UITextView+Layout.h"
#import "UIFont+Layout.h"

@implementation UITextView(Layout)

- (instancetype)init:(CGRect)rect parent:(UIView*)parent tag:(NSInteger)tag text:(NSString *)text color:(UIColor *)color align:(NSTextAlignment)align font:(NSString*)font size:(CGFloat)size delegate:(id<UITextViewDelegate>)delegate {
    
    self = [self init:rect parent:parent tag:tag];
    
    if ( color) [self setTextColor:color];
    [self setFont:[UIFont defalutFont:font size:size]];
   
    //self.editable = NO;
    
    [self setTextAlignment:align];
    if ( text ) self.text = text;
    
    if ( delegate )[self setDelegate:delegate];
       
    return self;
}


- (instancetype)addBackgroundColor:(UIColor *)bgColor {
    
    [self setBackgroundColor:bgColor];
    
    return self;
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

