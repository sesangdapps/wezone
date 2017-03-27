//
//  UIImageView+Layout.h
//  sobane
//
//  Created by Kim Sunmi on 2017. 1. 29..
//  Copyright © 2017년 Kim Sunmi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+Layout.h"

@interface UIImageView(Layout)

- (instancetype)init:(CGRect)rect parent:(UIView*)parent tag:(NSInteger)tag image:(UIImage *)image;
- (instancetype)init:(CGRect)rect parent:(UIView*)parent tag:(NSInteger)tag imageName:(NSString *)imageName;
    
@end
