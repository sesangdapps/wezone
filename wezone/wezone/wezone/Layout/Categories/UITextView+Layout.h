//
//  UITextView+Layout.h
//  sobane
//
//  Created by Kim Sunmi on 2017. 1. 31..
//  Copyright © 2017년 Kim Sunmi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+Layout.h"


@interface UITextView(Layout)

- (instancetype)init:(CGRect)rect parent:(UIView*)parent tag:(NSInteger)tag text:(NSString *)text color:(UIColor *)color align:(NSTextAlignment)align font:(NSString*)font size:(CGFloat)size delegate:(id<UITextViewDelegate>)delegate;

@end
