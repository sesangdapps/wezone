//
//  UIButton+Layout.m
//  sobane
//
//  Created by Kim Sunmi on 2017. 1. 29..
//  Copyright © 2017년 Kim Sunmi. All rights reserved.
//

#import "UIButton+Layout.h"
//#import "CommonUtil.h"
//#import "Def_Color.h"
#import "Layout.h"
#import "UIFont+Layout.h"

@implementation UIButton(Layout)

- (instancetype) init:(CGRect)rect parent:(UIView*)parent tag:(NSInteger)tag {
    
    //UIButton *view = [[UIButton alloc] init];
    self = [super init];
    
    [self setFrame:rect];
    if ( tag > 0 ) {
        [self setTag:tag];
    }
    if ( parent ) {
        [parent addSubview:self];
    }
    return self;
}


- (instancetype) init:(CGRect)rect parent:(UIView*)parent tag:(NSInteger)tag target:(id)target action:(SEL)selector {
    
    self = [self init:rect parent:parent tag:tag];
    
    if ( target && selector ) {
        [self addTarget:target  action:selector forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (instancetype) init:(CGRect)rect parent:(UIView*)parent tag:(NSInteger)tag normalImage:(UIImage*)normalImage highlightedImage:(UIImage *)highlightedImage disabledImage:(UIImage *)disabledImage target:(id)target action:(SEL)selector {
    
    self = [self init:rect parent:parent tag:tag target:target action:selector];
    
    if ( normalImage ) [self setImage:normalImage forState:UIControlStateNormal];
    if ( highlightedImage ) {
        [self setImage:highlightedImage forState:UIControlStateHighlighted];
        [self setImage:highlightedImage forState:UIControlStateSelected];
    }
    if ( disabledImage ) {
        [self setImage:disabledImage forState:UIControlStateDisabled];
    }
    return self;
}

- (instancetype) init:(CGRect)rect parent:(UIView*)parent tag:(NSInteger)tag normalImageName:(NSString*)normalImageName highlightedImageName:(NSString *)highlightedImageName disabledImageName:(NSString *)disabledImageName target:(id)target action:(SEL)selector {
    
   self= [self init:rect parent:parent tag:tag target:target action:selector];
    
    if ( normalImageName ) [self setImage:[UIImage imageNamed:normalImageName] forState:UIControlStateNormal];
    if ( highlightedImageName ) {
        [self setImage:[UIImage imageNamed:highlightedImageName] forState:UIControlStateHighlighted];
        [self setImage:[UIImage imageNamed:highlightedImageName] forState:UIControlStateSelected];
    }
    if ( disabledImageName ) {
        [self setImage:[UIImage imageNamed:disabledImageName] forState:UIControlStateDisabled];
    }
    if ( target && selector ) {
        [self addTarget:target  action:selector forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (instancetype) addImage:(UIImage*)normalImage highlightedImage:(UIImage *)highlightedImage disabledImage:(UIImage *)disabledImage {
    
    if ( normalImage ) [self setImage:normalImage forState:UIControlStateNormal];
    if ( highlightedImage ) {
        [self setImage:highlightedImage forState:UIControlStateHighlighted];
        [self setImage:highlightedImage forState:UIControlStateSelected];
    }
    if ( disabledImage ) {
        [self setImage:disabledImage forState:UIControlStateDisabled];
    }
    return self;
}

- (instancetype) addImageName:(NSString*)normalImageName highlightedImageName:(NSString *)highlightedImageName disabledImageName:(NSString *)disabledImageName {
    
    if ( normalImageName ) [self setImage:[UIImage imageNamed:normalImageName] forState:UIControlStateNormal];
    if ( highlightedImageName ) {
        [self setImage:[UIImage imageNamed:highlightedImageName] forState:UIControlStateHighlighted];
        [self setImage:[UIImage imageNamed:highlightedImageName] forState:UIControlStateSelected];
    }
    if ( disabledImageName ) {
        [self setImage:[UIImage imageNamed:disabledImageName] forState:UIControlStateDisabled];
    }
    return self;
}

- (instancetype) addImageName:(NSString*)normalImageName highlightedImageName:(NSString *)highlightedImageName selectedImageName:(NSString *)selectedImageName disabledImageName:(NSString *)disabledImageName {
    
    if ( normalImageName ) [self setImage:[UIImage imageNamed:normalImageName] forState:UIControlStateNormal];
    if ( highlightedImageName ) {
        [self setImage:[UIImage imageNamed:highlightedImageName] forState:UIControlStateHighlighted];
    }
    if ( selectedImageName ) {
        [self setImage:[UIImage imageNamed:selectedImageName] forState:UIControlStateSelected];
    }
    if ( disabledImageName ) {
        [self setImage:[UIImage imageNamed:disabledImageName] forState:UIControlStateDisabled];
    }
    return self;
}

- (instancetype) addImageName:(NSString*)normalImageName {
    
    if ( normalImageName ) [self setImage:[UIImage imageNamed:normalImageName] forState:UIControlStateNormal];
    
    return self;
}

- (instancetype) addBackgroundImage:(UIImage*)normalImage highlightedImage:(UIImage *)highlightedImage disabledImage:(UIImage *)disabledImage {
    
    if ( normalImage ) [self setBackgroundImage:normalImage forState:UIControlStateNormal];
    if ( highlightedImage ) {
        [self setBackgroundImage:highlightedImage forState:UIControlStateHighlighted];
        [self setBackgroundImage:highlightedImage forState:UIControlStateSelected];
    }
    if ( disabledImage ) {
        [self setBackgroundImage:disabledImage forState:UIControlStateDisabled];
    }
    return self;
}

- (instancetype) addBackgroundImage:(UIImage*)normalImage {
    
    if ( normalImage ) [self setBackgroundImage:normalImage forState:UIControlStateNormal];
    
    return self;
}

- (instancetype) addBackgroundImageName:(NSString*)normalImageName {
    
    if ( normalImageName ) [self setBackgroundImage:[UIImage imageNamed:normalImageName] forState:UIControlStateNormal];
    
    return self;
}

- (instancetype) addBackgroundImage:(NSString*)normalImageName highlightedImageName:(NSString *)highlightedImageName disabledImageName:(NSString *)disabledImageName {
    
    if ( normalImageName ) [self setBackgroundImage:[UIImage imageNamed:normalImageName] forState:UIControlStateNormal];
    if ( highlightedImageName ) {
        [self setBackgroundImage:[UIImage imageNamed:highlightedImageName] forState:UIControlStateHighlighted];
        [self setBackgroundImage:[UIImage imageNamed:highlightedImageName] forState:UIControlStateSelected];
    }
    if ( disabledImageName ) {
        [self setBackgroundImage:[UIImage imageNamed:disabledImageName] forState:UIControlStateDisabled];
    }
    return self;
}

- (instancetype) addBackgroundImage:(NSString*)normalImageName highlightedImageName:(NSString *)highlightedImageName selectedImageName:(NSString *)selectedImageName disabledImageName:(NSString *)disabledImageName {
    
    if ( normalImageName ) [self setBackgroundImage:[UIImage imageNamed:normalImageName] forState:UIControlStateNormal];
    if ( highlightedImageName ) {
        [self setBackgroundImage:[UIImage imageNamed:highlightedImageName] forState:UIControlStateHighlighted];
    }
    if ( selectedImageName ) {
        [self setBackgroundImage:[UIImage imageNamed:selectedImageName] forState:UIControlStateSelected];
    }
    if ( disabledImageName ) {
        [self setBackgroundImage:[UIImage imageNamed:disabledImageName] forState:UIControlStateDisabled];
    }
    return self;
}

- (instancetype) addBackgroundColor:(UIColor *)normalColor {
    
    if ( normalColor) [self setBackgroundImage:[Layout imageWithColor:normalColor] forState:UIControlStateNormal];
    
    return self;
}

- (instancetype) addBackgroundColor:(UIColor *)normalColor highlightedColor:(UIColor *)highlightedColor disabledColor:(UIColor *)disabledColor {
    
    if ( normalColor) [self setBackgroundImage:[Layout imageWithColor:normalColor] forState:UIControlStateNormal];
    if ( highlightedColor) {
        [self setBackgroundImage:[Layout imageWithColor:highlightedColor] forState:UIControlStateHighlighted];
        [self setBackgroundImage:[Layout imageWithColor:highlightedColor] forState:UIControlStateSelected];
    }
    if ( disabledColor ) {
        [self setBackgroundImage:[Layout imageWithColor:disabledColor] forState:UIControlStateDisabled];
    }
    
    return self;
}

- (instancetype) addTitleColor:(UIColor *)normalColor {
    
    if ( normalColor) [self setTitleColor:normalColor forState:UIControlStateNormal];
    
    return self;
}

- (instancetype) addTitleColor:(UIColor *)normalColor highlightedColor:(UIColor *)highlightedColor disabledColor:(UIColor *)disabledColor {
    
    
    if ( normalColor) [self setTitleColor:normalColor forState:UIControlStateNormal];
    if ( highlightedColor) {
        [self setTitleColor:highlightedColor forState:UIControlStateHighlighted];
        [self setTitleColor:highlightedColor forState:UIControlStateSelected];
    }
    if ( disabledColor ) {
        [self setTitleColor:disabledColor forState:UIControlStateDisabled];
    }
    return self;
}

- (instancetype) addTitle:(NSString *)title normalColor:(UIColor *)normalColor highlightedColor:(UIColor *)highlightedColor disabledColor:(UIColor *)disabledColor font:(NSString*)font size:(CGFloat)size{
    
    [self setTitleEdgeInsets:UIEdgeInsetsMake(2, 0, 0, 0)];
    
    if ( title ) {
        [self setTitle:title forState:UIControlStateNormal];
        [self setTitle:title forState:UIControlStateHighlighted];
        [self setTitle:title forState:UIControlStateSelected];
        [self setTitle:title forState:UIControlStateDisabled];
    }
    if ( normalColor) [self setTitleColor:normalColor forState:UIControlStateNormal];
    if ( highlightedColor) {
        [self setTitleColor:highlightedColor forState:UIControlStateHighlighted];
        [self setTitleColor:highlightedColor forState:UIControlStateSelected];
    }
    if ( disabledColor ) {
        [self setTitleColor:disabledColor forState:UIControlStateDisabled];
    }
    [self.titleLabel setFont:[UIFont defalutFont:font size:size]];
    
    return self;
}

- (instancetype) addTitle:(NSString *)title normalColor:(UIColor *)normalColor highlightedColor:(UIColor *)highlightedColor disabledColor:(UIColor *)disabledColor font:(NSString*)font size:(CGFloat)size align:(UIControlContentHorizontalAlignment)align {
    
    [self addTitle:title normalColor:normalColor highlightedColor:highlightedColor disabledColor:disabledColor font:font size:size];
    [self setContentHorizontalAlignment:align];
    
    return self;
}

- (instancetype) addAttributeTitle:(NSMutableAttributedString *)title normalColor:(UIColor *)normalColor highlightedColor:(UIColor *)highlightedColor disabledColor:(UIColor *)disabledColor font:(NSString*)font size:(CGFloat)size {
    
    
    if ( title ) [self setAttributedTitle:title forState:UIControlStateNormal];
    
    if ( normalColor) {
        
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithAttributedString:title];
        [string addAttributes:@{NSForegroundColorAttributeName: normalColor} range:NSMakeRange(0, string.length)];
        [self setAttributedTitle:string forState:UIControlStateNormal];
        
        [self setTitleColor:normalColor forState:UIControlStateNormal];
    }
    if ( highlightedColor) {
        
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithAttributedString:title];
        [string addAttributes:@{NSForegroundColorAttributeName: highlightedColor} range:NSMakeRange(0, string.length)];
        [self setAttributedTitle:string forState:UIControlStateHighlighted];
        [self setAttributedTitle:string forState:UIControlStateSelected];
        
        [self setTitleColor:highlightedColor forState:UIControlStateHighlighted];
        [self setTitleColor:highlightedColor forState:UIControlStateSelected];
    }
    if ( disabledColor ) {
        
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithAttributedString:title];
        [string addAttributes:@{NSForegroundColorAttributeName: disabledColor} range:NSMakeRange(0, string.length)];
        [self setAttributedTitle:string forState:UIControlStateDisabled];
        
        [self setTitleColor:disabledColor forState:UIControlStateDisabled];
    }
    [self.titleLabel setFont:[UIFont defalutFont:font size:size]];
    
    return self;
    
}


- (instancetype) addTitle:(NSString *)title font:(NSString*)font size:(CGFloat)size {
    
    if ( title ) {
        [self setTitle:title forState:UIControlStateNormal];
        [self setTitle:title forState:UIControlStateHighlighted];
        [self setTitle:title forState:UIControlStateSelected];
        [self setTitle:title forState:UIControlStateDisabled];
    }
    [self.titleLabel setFont:[UIFont defalutFont:font size:size]];
    
    return self;
}

- (instancetype) addAttributeTitle:(NSMutableAttributedString *)title font:(NSString*)font size:(CGFloat)size {
    
    if ( title ) {
        [self setAttributedTitle:title forState:UIControlStateNormal];
        [self setAttributedTitle:title forState:UIControlStateHighlighted];
        [self setAttributedTitle:title forState:UIControlStateSelected];
        [self setAttributedTitle:title forState:UIControlStateDisabled];
    }
    [self.titleLabel setFont:[UIFont defalutFont:font size:size]];
    
    return self;
}

- (instancetype) addTitle:(NSString *)title {
    
    if ( title ) {
        [self setTitle:title forState:UIControlStateNormal];
        [self setTitle:title forState:UIControlStateHighlighted];
        [self setTitle:title forState:UIControlStateSelected];
        [self setTitle:title forState:UIControlStateDisabled];
    }
    return self;
}

- (instancetype) addAttributeTitle:(NSMutableAttributedString *)title {
    
    if ( title ) {
        [self setAttributedTitle:title forState:UIControlStateNormal];
        [self setAttributedTitle:title forState:UIControlStateHighlighted];
        [self setAttributedTitle:title forState:UIControlStateSelected];
        [self setAttributedTitle:title forState:UIControlStateDisabled];
    }
    return self;
}

//- (instancetype) yellowStyle {
//    
//    [self addBackgroundColor:COLOR_BUTTON_YELLOW_BG_NORMAL highlightedColor:COLOR_BUTTON_YELLOW_BG_OVER disabledColor:COLOR_BUTTON_YELLOW_BG_DIM];
//    [self addTitleColor:COLOR_BUTTON_YELLOW_TEXT_NORMAL highlightedColor:COLOR_BUTTON_YELLOW_TEXT_OVER disabledColor:COLOR_BUTTON_YELLOW_TEXT_DIM];
//    
//    return self;
//}
//
//- (instancetype) greyStyle {
//    
//    [self addBackgroundColor:COLOR_BUTTON_GREY_BG_NORMAL highlightedColor:COLOR_BUTTON_GREY_BG_OVER disabledColor:COLOR_BUTTON_GREY_BG_DIM];
//    [self addTitleColor:COLOR_BUTTON_GREY_TEXT_NORMAL highlightedColor:COLOR_BUTTON_GREY_TEXT_OVER disabledColor:COLOR_BUTTON_GREY_TEXT_DIM];
//    
//    return self;
//}
//
//- (instancetype) blueStyle {
//    
//    [self addBackgroundColor:COLOR_BUTTON_BLUE_BG_NORMAL highlightedColor:COLOR_BUTTON_BLUE_BG_OVER disabledColor:COLOR_BUTTON_BLUE_BG_DIM];
//    [self addTitleColor:COLOR_BUTTON_BLUE_TEXT_NORMAL highlightedColor:COLOR_BUTTON_BLUE_TEXT_OVER disabledColor:COLOR_BUTTON_BLUE_TEXT_DIM];
//    
//    return self;
//}
//
//- (instancetype) menuItemStyle {
//    
//    [self addBackgroundColor:RGBHEX(0xffffff) highlightedColor:RGBHEX(0xf5f5f5) disabledColor:RGBHEX(0xffffff)];
//    [self setTitleEdgeInsets:UIEdgeInsetsMake(0, 42, 0, 0)];
//    return self;
//}
//
//- (instancetype) underTitle {
//    
//
//    
//    return self;
//}

@end


@implementation UIBorderButton

- (instancetype) init {

    self = [super init];
    
    [self addTarget:self action:@selector(makeNormalState) forControlEvents:UIControlEventTouchUpInside];
    [self addTarget:self action:@selector(makeNormalState) forControlEvents:UIControlEventTouchUpOutside];
    [self addTarget:self action:@selector(makeHighlightedState) forControlEvents:UIControlEventTouchDown];
    
    return self;
}

- (instancetype)addBorderColor:(UIColor *)normalColor highlightedColor:(UIColor *)highlightedColor disabledColor:(UIColor *)disabledColor width:(float)width corner:(float)corner {
    
    self.borderNormalColor = normalColor;
    self.borderHighlightedColor = highlightedColor;
    self.borderDisabledColor = disabledColor;
    
    self.borderNormalWidth = width;
    self.borderHighlightedWidth = width;
    self.borderDisabledWidth = width;
    
    [self makeNormalState];
   
    return self;
}

- (instancetype)addBorderWidth:(float)normalWidth highlightedWidth:(float)highlightedWidth disabledWidth:(float)disabledWidth {
    
    self.borderNormalWidth = normalWidth;
    self.borderHighlightedWidth = highlightedWidth;
    self.borderDisabledWidth = disabledWidth;
    
    return self;
}

- (void)makeNormalState {
    
    [self.layer setBorderColor:self.borderNormalColor.CGColor];
    [self.layer setBorderWidth:self.borderNormalWidth / [Layout screenScale]];
}

- (void) makeHighlightedState {
    
    [self.layer setBorderColor:self.borderHighlightedColor.CGColor];
    [self.layer setBorderWidth:self.borderHighlightedWidth / [Layout screenScale]];
}

- (void) makeDisabledState {
    
    [self.layer setBorderColor:self.borderDisabledColor.CGColor];
    [self.layer setBorderWidth:self.borderDisabledWidth / [Layout screenScale]];
}

//- (instancetype) blackStyle {
//    
//    [self addBackgroundColor:COLOR_BUTTON_BLACK_BG_NORMAL highlightedColor:COLOR_BUTTON_BLACK_BG_OVER disabledColor:COLOR_BUTTON_BLACK_BG_DIM];
//    [self addTitleColor:COLOR_BUTTON_BLACK_TEXT_NORMAL highlightedColor:COLOR_BUTTON_BLACK_TEXT_OVER disabledColor:COLOR_BUTTON_BLACK_TEXT_DIM];
//    [self addBorderColor:COLOR_BUTTON_BLACK_BORDER_NORMAL highlightedColor:COLOR_BUTTON_BLACK_BORDER_OVER disabledColor:COLOR_BUTTON_BLACK_BORDER_DIM width:1.0f corner:0.0f];
//    return self;
//}


@end
