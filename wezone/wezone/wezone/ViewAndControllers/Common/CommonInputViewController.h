//
//  CommonInputViewController.h
//  wezone
//
//  Created by Kim Sunmi on 2017. 3. 21..
//  Copyright © 2017년 Kim Sunmi. All rights reserved.
//

#import "GALBaseController.h"

@interface CommonInputViewController : GALBaseController<UITextFieldDelegate>

@property (nonatomic, strong) UIView *selectedInput;
@property (nonatomic, assign) CGPoint scrollOffset;

-(void)showKeyboard:(UITextField *)textField;
-(void)hideKeyboard;

@end
