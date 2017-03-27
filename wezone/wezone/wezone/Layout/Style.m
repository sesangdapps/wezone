//
//  Style.m
//  wezone
//
//  Created by Kim Sunmi on 2017. 3. 13..
//  Copyright © 2017년 Kim Sunmi. All rights reserved.
//

#import "Style.h"
#import "Layout.h"
#import "UIFont+Layout.h"



@implementation UITextField(Style)

-(instancetype) defaultStyle:(NSString *)text placeholder:(NSString *)placeholder delegate:(id<UITextFieldDelegate>)delegate {
    
    if ( self ) {
        
        [self setTextColor:UIColorFromRGB(0x2f2f2f)];
        [self setFont:[UIFont defalutFont:nil size:[Layout aspecValue:15.0f]]];
        [self setTextAlignment:NSTextAlignmentLeft];
        
        
        if ( placeholder ) [self setPlaceholder:placeholder];
        if ( text ) [self setText:text];
        if ( delegate )[self setDelegate:delegate];
        [self setKeyboardType:UIKeyboardTypeDefault];
        [self setSecureTextEntry:NO];
        
        [self setLeftPadding:[Layout aspecValue:20]];
        [self setRightPadding:[Layout aspecValue:20]];
        
        [self setReturnKeyType:UIReturnKeyDone];
        
        [self setBackground:[UIImage imageNamed:@"text_field_white"]];
    }
    return self;
}

-(instancetype) defaultStyle:(NSString *)text placeholder:(NSString *)placeholder type:(UIKeyboardType)type password:(BOOL)password delegate:(id<UITextFieldDelegate>)delegate {
    
    if ( self ) {
        
        [self defaultStyle:text placeholder:placeholder delegate:delegate];
        
        [self setKeyboardType:type];
        [self setSecureTextEntry:password];
        
    }
    return self;
}
@end

@implementation UIButton(Style)

-(instancetype) blueStyle {
    
    if ( self ) {
        [self.titleLabel setFont:[UIFont defalutFont:nil size:15]];
        [self addBackgroundImageName:@"btn_login_blue"];
        [self addTitleColor:UIColorFromRGB(0xffffff)];
    }
    return self;
}

-(instancetype) outlineStyle {
    
    if ( self ) {
        [self.titleLabel setFont:[UIFont defalutFont:nil size:15]];
        [self addBackgroundImageName:@"btn_outline_blue"];
        [self addTitleColor:UIColorFromRGB(0x669cf8)];
    }
    return self;
}

-(instancetype) icontextStyle:(NSString *)iconName {
    
    if ( self ) {
        [self.titleLabel setFont:[UIFont defalutFont:nil size:SIZE_TEXT_S]];
        [self addTitleColor:UIColorFromRGB(0x757575)];
        [self setBorder:UIColorFromRGBA(0x9e9e9eaa) width:1 corner:0];
        [self addImageName:iconName];
        [self setTitleEdgeInsets:UIEdgeInsetsMake(0, [Layout aspecValue:10], 0, [Layout aspecValue:10])];
    }
    return self;
}
@end
