//
//  Layout.m
//  sobane
//
//  Created by Kim Sunmi on 2017. 1. 29..
//  Copyright © 2017년 Kim Sunmi. All rights reserved.
//

#import "Layout.h"


@implementation Layout

+ (float)statusHeight {
    
//    if (IS_IOS7_OR_LATER) {
//        return 0;
//    } else {
//        return 20.0f;
//    }
    return [[UIApplication sharedApplication] statusBarFrame].size.height;
}

+ (CGRect)screenRect {
    
    CGRect frame = [[UIScreen mainScreen] bounds];
    CGRect rect;
    
    rect.origin.x = 0;
    rect.origin.y = [self statusHeight];
    
    rect.size.width = frame.size.width;
    rect.size.height = frame.size.height + (frame.origin.y - rect.origin.y);
    
    return rect;
}

+ (CGRect)fullscreenRect {
    
    CGRect rect = [self screenRect];
    
    rect.size.height += rect.origin.y;
    rect.origin.y = 0;
    
    return rect;
}

+ (float)pixelWidth {
    
    float scale = [[UIScreen mainScreen] scale];
    //float ppi = scale * ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 132 : 163);
    float width = ([[UIScreen mainScreen] bounds].size.width * scale);
    return  width;
}

+ (float)screenScale {
    
    return  [[UIScreen mainScreen] scale];
}

+ (float)screenWidth {
    
    return  [[UIScreen mainScreen] bounds].size.width;
}

+ (float)screenHeight {
    
    return  [[UIScreen mainScreen] bounds].size.height;
}

+ (float)scaleWidth {
    
    return [Layout screenRect].size.width / LAYOUT_WIDTH;
}

+ (float)scaleHeight {
    
    return ([Layout screenRect].size.height - NAVI_HEIGHT) / (LAYOUT_HEIGHT - [self statusHeight]);
}

+ (CGRect)aspecRect:(CGRect)rect {
    
    float scale = [Layout scaleWidth];
    
    rect.origin.x *= scale;
    rect.origin.y *= scale;
    rect.size.width *= scale;
    rect.size.height *= scale;
    
    return rect;
}

+ (CGSize)aspecSize:(CGSize)size {
    
    float scale = [Layout scaleWidth];
    
    size.width *= scale;
    size.height *= scale;
    
    return size;
}

+ (float)aspecValue:(float)value {
    
    return value * [Layout scaleWidth];
}

+ (CGRect)convertRect:(CGRect)rect {
    
    float scaleW = [Layout scaleWidth];
    float scaleH = [Layout scaleHeight];
    
    rect.origin.x *= scaleW;
    rect.origin.y *= scaleH;
    rect.size.width *= scaleW;
    rect.size.height *= scaleH;
    
    return rect;
}

+ (CGSize)convertSize:(CGSize)size {
    
    float scaleW = [Layout scaleWidth];
    float scaleH = [Layout scaleHeight];
    
    size.width *= scaleW;
    size.height *= scaleH;
    
    return size;
}

+ (float)convertWidth:(float)value {
    
    return value * [Layout scaleWidth];
}

+ (float)convertHeight:(float)value {
    
    return value * [Layout scaleHeight];
}

+ (float)revert:(float)value {
    
    return value / [Layout scaleWidth];
}

+ (float)stringWidth:(NSString *)text font:(NSString *)fontName fontSize:(float)fontSize {
    
    UIFont *font = [UIFont fontWithName:fontName size:fontSize];
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
    return [[[NSAttributedString alloc] initWithString:text attributes:attributes] size].width;
}

+ (float)lineSize:(float)size {
    
    if ( size < 1 ) return 1;
    return ceil(size);
}

+ (UIImage *)imageWithColor:(UIColor *)color {
    
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


@end




