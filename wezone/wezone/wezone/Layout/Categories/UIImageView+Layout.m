//
//  UIImageView+Layout.m
//  sobane
//
//  Created by Kim Sunmi on 2017. 1. 29..
//  Copyright © 2017년 Kim Sunmi. All rights reserved.
//

#import "UIImageView+Layout.h"

@implementation UIImageView(Layout)

- (instancetype)init:(CGRect)rect parent:(UIView*)parent tag:(NSInteger)tag image:(UIImage *)image {
    
    self = [self init:rect parent:parent tag:tag];
    if ( image ) [self setImage:image];
    
    self.contentMode = UIViewContentModeScaleToFill;
    //self.contentMode = UIViewContentModeScaleAspectFill;
    self.clipsToBounds = YES;
    
    return self;
}

- (instancetype)init:(CGRect)rect parent:(UIView*)parent tag:(NSInteger)tag imageName:(NSString *)imageName {
    
    self = [self init:rect parent:parent tag:tag];
    if ( imageName ) [self setImage:[UIImage imageNamed:imageName]];
    
    self.contentMode = UIViewContentModeScaleToFill;
    //self.contentMode = UIViewContentModeScaleAspectFill;
    self.clipsToBounds = YES;
    
    return self;
}

@end
