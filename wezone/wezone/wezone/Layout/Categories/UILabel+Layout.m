//
//  UILabel+Layout.m
//  sobane
//
//  Created by Kim Sunmi on 2017. 1. 29..
//  Copyright © 2017년 Kim Sunmi. All rights reserved.
//

#import "UILabel+Layout.h"
#import "UIFont+Layout.h"

@implementation UILabel(Layout)


-(instancetype) init:(CGRect)rect parent:(UIView*)parent tag:(NSInteger)tag text:(NSString *)text color:(UIColor *)color bgColor:(UIColor *)bgColor align:(NSTextAlignment)align font:(NSString *)font size:(CGFloat)size {
    
    self = [self init:rect parent:parent tag:tag];
    
    [self setText:text];
    [self setTextAlignment:align];
    
    [self setTextColor:color];
    
    [self setFont:[UIFont defalutFont:font size:size]];
    
    if ( bgColor ) {
        [self setBackgroundColor:bgColor];
    } else {
        [self setBackgroundColor:[UIColor clearColor]];
    }
    [self setNumberOfLines:0];
    return self;
}

- (void)sizeToFitHeight {

    CGRect rect = self.frame;
    [self sizeToFit];
    
    if ( self.textAlignment == NSTextAlignmentCenter ) {
        [self setX: rect.origin.x + rect.size.width / 2 - self.frame.size.width / 2];
    } else if ( self.textAlignment == NSTextAlignmentRight ) {
        [self setX: rect.origin.x + rect.size.width - self.frame.size.width];
    }
}

- (void)sizeToFitHeight:(float)minHeight {
    
    CGRect rect = self.frame;
    [self sizeToFit];
    if ( self.frame.size.height < minHeight ) [self setHeight:minHeight];
    
    if ( self.textAlignment == NSTextAlignmentCenter ) {
        [self setX: rect.origin.x + rect.size.width / 2 - self.frame.size.width / 2];
    } else if ( self.textAlignment == NSTextAlignmentRight ) {
        [self setX: rect.origin.x + rect.size.width - self.frame.size.width];
    }
}

- (void)sizeToFitWidth {
    
    CGRect rect = self.frame;
    [self sizeToFit];
    
    [self setY: rect.origin.y + rect.size.height / 2 - self.frame.size.height / 2];
}

@end
