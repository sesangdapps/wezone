//
//  UIView+Layout.h
//  sobane
//
//  Created by Kim Sunmi on 2017. 1. 29..
//  Copyright © 2017년 Kim Sunmi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Layout)


- (instancetype)init:(CGRect)rect parent:(UIView*)parent tag:(NSInteger)tag;
- (instancetype)init:(CGRect)rect parent:(UIView*)parent tag:(NSInteger)tag color:(UIColor *)color;
- (instancetype)init:(CGRect)rect parent:(UIView*)parent tag:(NSInteger)tag color:(UIColor *)color borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth;

- (void)setX:(float)x;
- (void)setY:(float)y;
- (void)setWidth:(float)width;
- (void)setHeight:(float)height;
- (void)setPosition:(CGPoint)point;
- (void)setSize:(CGSize)size;
- (void)posLeft:(UIView *)view margin:(float)margin;
- (void)posRight:(UIView *)view margin:(float)margin;
- (void)posAbove:(UIView *)view margin:(float)margin;
- (void)posBelow:(UIView *)view margin:(float)margin;
- (void)posVerticalCenter:(UIView *)view;
- (void)posHorizontalCenter:(UIView *)view;
- (void)alignRight:(UIView *)view margin:(float)margin;
- (void)alignBottom:(UIView *)view margin:(float)margin;
- (void)sizeToFitWidth:(UIView *)view padding:(float)padding;
- (void)sizeToFitHeight:(UIView *)view padding:(float)padding;

- (void)setColor:(UIColor *)color;
- (void)setBorder:(UIColor *)color width:(float)width corner:(float)corner;
- (void)setShadow:(UIColor *)color opacity:(float)opacity radius:(float)radius;
- (void)addTarget:(id)target action:(SEL)action;

+ (instancetype)makeVerticalLine:(CGRect)rect parent:(UIView*)parent tag:(NSInteger)tag color:(UIColor *)color;
+ (instancetype)makeTopLine:(CGRect)rect parent:(UIView*)parent tag:(NSInteger)tag color:(UIColor *)color;
+ (instancetype)makeBottomLine:(CGRect)rect parent:(UIView*)parent tag:(NSInteger)tag color:(UIColor *)color;

+ (instancetype)makeHorizontalLine:(CGRect)rect parent:(UIView*)parent tag:(NSInteger)tag color:(UIColor *)color;
+ (instancetype)makeLeftLine:(CGRect)rect parent:(UIView*)parent tag:(NSInteger)tag color:(UIColor *)color;
+ (instancetype)makeRightLine:(CGRect)rect parent:(UIView*)parent tag:(NSInteger)tag color:(UIColor *)color;

@end

