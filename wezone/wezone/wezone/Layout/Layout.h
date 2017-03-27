//
//  Layout.h
//  sobane
//
//  Created by Kim Sunmi on 2017. 1. 29..
//  Copyright © 2017년 Kim Sunmi. All rights reserved.
//


#import <UIKit/UIKit.h>
//#import "Def_Common.h"
//#import "Def_Color.h"
//#import "Def_Size.h"
#import "UIView+Layout.h"
#import "UIScrollView+Layout.h"
#import "UITableView+Layout.h"
#import "UIImageView+Layout.h"
#import "UILabel+Layout.h"
#import "UIButton+Layout.h"
#import "UITextField+Layout.h"
#import "UITextView+Layout.h"

static float LAYOUT_WIDTH = 320;
static float LAYOUT_HEIGHT = 568 - 44;
static float NAVI_HEIGHT = 44;

@interface Layout : NSObject

+ (float)statusHeight;
+ (CGRect)screenRect;
+ (CGRect)fullscreenRect;
+ (float)screenScale;
+ (float)screenWidth;
+ (float)screenHeight;
+ (float)pixelWidth;

+ (float)scaleWidth;
+ (float)scaleHeight;

+ (CGRect)aspecRect:(CGRect)rect;
+ (CGSize)aspecSize:(CGSize)size;
+ (float)aspecValue:(float)value;

+ (CGRect)convertRect:(CGRect)rect;
+ (CGSize)convertSize:(CGSize)size;
+ (float)convertHeight:(float)value;
+ (float)convertWidth:(float)value;

+ (float)revert:(float)value;

+ (float)stringWidth:(NSString *)text font:(NSString *)fontName fontSize:(float)fontSize;
+ (float)lineSize:(float)size;

+ (UIImage *)imageWithColor:(UIColor *)color;

@end


