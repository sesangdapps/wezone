//
//  UILabel+Layout.h
//  sobane
//
//  Created by Kim Sunmi on 2017. 1. 29..
//  Copyright © 2017년 Kim Sunmi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+Layout.h"

@interface UILabel(Layout)

-(instancetype) init:(CGRect)rect parent:(UIView*)parent tag:(NSInteger)tag text:(NSString *)text color:(UIColor *)color bgColor:(UIColor *)bgColor align:(NSTextAlignment)align font:(NSString *)font size:(CGFloat)size;
- (void)sizeToFitHeight;
- (void)sizeToFitHeight:(float)minHeight;
- (void)sizeToFitWidth;

@end
