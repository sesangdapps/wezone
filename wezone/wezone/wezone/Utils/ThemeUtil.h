//
//  ThemeUtil.h
//  wezone
//
//  Created by Kim Sunmi on 2017. 3. 15..
//  Copyright © 2017년 Kim Sunmi. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, AppThemeType) {
    AppThemeTypeBlue = 0,
    AppThemeTypeRed,
    AppThemeTypeYellow
};

static AppThemeType appThemeType = AppThemeTypeYellow;

@interface ThemeUtil : NSObject


+(UIColor *)naviColor;
+(NSString *)imageName:(NSString *)name;

@end
