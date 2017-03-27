//
//  UIButton+Layout.h
//  sobane
//
//  Created by Kim Sunmi on 2017. 1. 29..
//  Copyright © 2017년 Kim Sunmi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+Layout.h"

@interface UIButton(Layout)

- (instancetype) init:(CGRect)rect parent:(UIView*)parent tag:(NSInteger)tag target:(id)target action:(SEL)selector;
- (instancetype) init:(CGRect)rect parent:(UIView*)parent tag:(NSInteger)tag normalImage:(UIImage*)normalImage highlightedImage:(UIImage *)highlightedImage disabledImage:(UIImage *)disabledImage target:(id)target action:(SEL)selector;
- (instancetype) init:(CGRect)rect parent:(UIView*)parent tag:(NSInteger)tag normalImageName:(NSString*)normalImageName highlightedImageName:(NSString *)highlightedImageName disabledImageName:(NSString *)disabledImageName target:(id)target action:(SEL)selector;

- (instancetype) addImage:(UIImage*)normalImage highlightedImage:(UIImage *)highlightedImage disabledImage:(UIImage *)disabledImage;
- (instancetype) addImageName:(NSString*)normalImageName highlightedImageName:(NSString *)highlightedImageName disabledImageName:(NSString *)disabledImageName;
- (instancetype) addImageName:(NSString*)normalImageName highlightedImageName:(NSString *)highlightedImageName selectedImageName:(NSString *)selectedImageName disabledImageName:(NSString *)disabledImageName;
- (instancetype) addImageName:(NSString*)normalImageName;

- (instancetype) addBackgroundImage:(UIImage*)normalImage;
- (instancetype) addBackgroundImageName:(NSString*)normalImageName;
    
- (instancetype) addBackgroundImage:(UIImage*)normalImage highlightedImage:(UIImage *)highlightedImage disabledImage:(UIImage *)disabledImage;
- (instancetype) addBackgroundImageName:(NSString*)normalImageName highlightedImageName:(NSString *)highlightedImageName disabledImageName:(NSString *)disabledImageName;
- (instancetype) addBackgroundImageName:(NSString*)normalImageName highlightedImageName:(NSString *)highlightedImageName selectedImageName:(NSString *)selectedImageName disabledImageName:(NSString *)disabledImageName;

- (instancetype) addBackgroundColor:(UIColor *)normalColor;
- (instancetype) addBackgroundColor:(UIColor *)normalColor highlightedColor:(UIColor *)highlightedColor disabledColor:(UIColor *)disabledColor;


- (instancetype) addTitleColor:(UIColor *)normalColor;
- (instancetype) addTitleColor:(UIColor *)normalColor highlightedColor:(UIColor *)highlightedColor disabledColor:(UIColor *)disabledColor;

- (instancetype) addTitle:(NSString *)title;
- (instancetype) addTitle:(NSString *)title font:(NSString*)font size:(CGFloat)size;
- (instancetype) addTitle:(NSString *)title normalColor:(UIColor *)normalColor highlightedColor:(UIColor *)highlightedColor disabledColor:(UIColor *)disabledColor font:(NSString*)font size:(CGFloat)size;

- (instancetype) addTitle:(NSString *)title normalColor:(UIColor *)normalColor highlightedColor:(UIColor *)highlightedColor disabledColor:(UIColor *)disabledColor font:(NSString*)font size:(CGFloat)size align:(UIControlContentHorizontalAlignment)align;

- (instancetype) addAttributeTitle:(NSMutableAttributedString *)title;
- (instancetype) addAttributeTitle:(NSMutableAttributedString *)title font:(NSString*)font size:(CGFloat)size;
- (instancetype) addAttributeTitle:(NSMutableAttributedString *)title normalColor:(UIColor *)normalColor highlightedColor:(UIColor *)highlightedColor disabledColor:(UIColor *)disabledColor font:(NSString*)font size:(CGFloat)size;

//- (instancetype) yellowStyle;
//- (instancetype) blueStyle;
//- (instancetype) greyStyle;
//- (instancetype) menuItemStyle;

@end

@interface UIBorderButton : UIButton

@property (strong, nonatomic) UIColor *borderNormalColor;
@property (strong, nonatomic) UIColor *borderHighlightedColor;
@property (strong, nonatomic) UIColor *borderDisabledColor;

@property (assign, nonatomic) float borderNormalWidth;
@property (assign, nonatomic) float borderHighlightedWidth;
@property (assign, nonatomic) float borderDisabledWidth;


//- (instancetype)blackStyle;
- (instancetype)addBorderColor:(UIColor *)normalColor highlightedColor:(UIColor *)highlightedColor disabledColor:(UIColor *)disabledColor width:(float)width corner:(float)corner;
- (instancetype)addBorderWidth:(float)normalWidth highlightedWidth:(float)highlightedWidth disabledWidth:(float)disabledWidth;

@end

