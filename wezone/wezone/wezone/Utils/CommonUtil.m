//
//  CommonUtil.m
//  wezone
//
//  Created by Kim Sunmi on 2017. 3. 17..
//  Copyright © 2017년 Kim Sunmi. All rights reserved.
//

#import "CommonUtil.h"

@implementation CommonUtil

+ (void)removeAllChildView:(UIView *)view {
    
    NSArray *list = view.subviews;
    
    for( UIView *child in list ) {
        [child removeFromSuperview];
    }
}

+ (NSString *)moneyFormat:(double)value {
    
    NSNumberFormatter *currencyStyle = [[NSNumberFormatter alloc] init];
    
    [currencyStyle setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber *amount = [NSNumber numberWithDouble:value];
    
    // get formatted string
    NSString* formatted = [currencyStyle stringFromNumber:amount];
    
    return formatted;
}

+ (NSString *)moneyFormat:(double)value maxFraction:(int)maxFraction {
    
    NSNumberFormatter *currencyStyle = [[NSNumberFormatter alloc] init];
    
    [currencyStyle setNumberStyle:NSNumberFormatterDecimalStyle];
    [currencyStyle setMaximumFractionDigits:maxFraction];
    [currencyStyle setMinimumFractionDigits:maxFraction];
    NSNumber *amount = [NSNumber numberWithDouble:value];
    
    // get formatted string
    NSString* formatted = [currencyStyle stringFromNumber:amount];
    
    return formatted;
}

+ (UIView *)findParengByType:(UIView *)view clazz:(Class)clazz {
    
    UIView * parent = view.superview;
    
    while (nil != parent ) {
        if ([parent isKindOfClass:clazz]) {
            return parent;
        } else {
            parent = parent.superview;
        }
    }
    return parent;
}

+ (BOOL)isEmpty:(NSString *)string {

    if ( string == nil ) return YES;
    if ( [string length] == 0 ) return YES;
    
    return NO;
}
@end
