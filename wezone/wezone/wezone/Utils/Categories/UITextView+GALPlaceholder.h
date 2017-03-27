//
//  UITextView+GALPlaceholder.h
//  Langtudy
//
//  Created by SinSuMin on 2016. 10. 31..
//  Copyright © 2016년 galuster. All rights reserved.
//

#import <UIKit/UIKit.h>

@import UIKit;

FOUNDATION_EXPORT double UITextView_PlaceholderVersionNumber;
FOUNDATION_EXPORT const unsigned char UITextView_PlaceholderVersionString[];

@interface UITextView (GALPlaceholder)
@property (nonatomic, readonly) UILabel *placeholderLabel;

@property (nonatomic, strong) IBInspectable NSString *placeholder;
@property (nonatomic, strong) NSAttributedString *attributedPlaceholder;
@property (nonatomic, strong) IBInspectable UIColor *placeholderColor;

+ (UIColor *)defaultPlaceholderColor;
@end
