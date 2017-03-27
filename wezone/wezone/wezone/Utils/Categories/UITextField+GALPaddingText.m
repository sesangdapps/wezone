//
//  UITextField+GALPaddingText.m
//  Langtudy
//
//  Created by SinSuMin on 2016. 8. 11..
//  Copyright © 2016년 galuster. All rights reserved.
//

#import "UITextField+GALPaddingText.h"

@implementation UITextField (GALPaddingText)
-(void) setLeftPadding:(int) paddingValue
{
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, paddingValue, self.frame.size.height)];
    self.leftView = paddingView;
    self.leftViewMode = UITextFieldViewModeAlways;
}

-(void) setRightPadding:(int) paddingValue
{
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, paddingValue, self.frame.size.height)];
    self.rightView = paddingView;
    self.rightViewMode = UITextFieldViewModeAlways;
}

@end
