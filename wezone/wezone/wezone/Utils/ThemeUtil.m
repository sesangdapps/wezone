//
//  ThemeUtil.m
//  wezone
//
//  Created by Kim Sunmi on 2017. 3. 15..
//  Copyright © 2017년 Kim Sunmi. All rights reserved.
//

#import "ThemeUtil.h"
#import "GALCommon.h"

@implementation ThemeUtil

+(UIColor *)naviColor {
    
    switch (appThemeType) {
        case AppThemeTypeBlue: return UIColorFromRGB(0x162133);
        case AppThemeTypeRed: return UIColorFromRGB(0x36191b);
        case AppThemeTypeYellow: return UIColorFromRGB(0x362e09);
    }
    return UIColorFromRGB(0x162133);
}

+(NSString *)imageName:(NSString *)name {

    name = [name stringByReplacingOccurrencesOfString:@"_blue" withString:@""];
    switch (appThemeType) {
        case AppThemeTypeBlue: return [name stringByAppendingString:@"_blue"];
        case AppThemeTypeRed: return [name stringByAppendingString:@"_red"];
        case AppThemeTypeYellow: return [name stringByAppendingString:@"_yellow"];
    }
    return name;
}

@end
