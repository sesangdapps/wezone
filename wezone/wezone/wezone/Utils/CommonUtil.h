//
//  CommonUtil.h
//  wezone
//
//  Created by Kim Sunmi on 2017. 3. 17..
//  Copyright © 2017년 Kim Sunmi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonUtil : NSObject

+ (void)removeAllChildView:(UIView *)view;
+ (NSString *)moneyFormat:(double)value;
+ (NSString *)moneyFormat:(double)value maxFraction:(int)maxFraction;
+ (UIView *)findParengByType:(UIView *)view clazz:(Class)clazz;
+ (BOOL)isEmpty:(NSString *)string;

@end
