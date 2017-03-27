//
//  UIFont+Layout.m
//  wezone
//
//  Created by Kim Sunmi on 2017. 3. 13..
//  Copyright © 2017년 Kim Sunmi. All rights reserved.
//

#import "UIFont+Layout.h"

@implementation UIFont(Style)

+ (nullable UIFont *)defalutFont:(NSString *)fontName size:(CGFloat)fontSize {
    
    UIFont *font = nil;
    if ( fontName ) {
        font = [UIFont fontWithName:fontName size:fontSize];
    }
    if ( !font ) {
        if ( fontName ) {
            if ( [[fontName uppercaseString] containsString:@"BOLD"] ) {
                font = [UIFont boldSystemFontOfSize:fontSize];
            } else {
                font = [UIFont systemFontOfSize:fontSize];
            }
        } else {
            font = [UIFont systemFontOfSize:fontSize];
        }
    }
    return font;
}

@end
