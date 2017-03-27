//
//  CommonInputViewController.m
//  wezone
//
//  Created by Kim Sunmi on 2017. 3. 21..
//  Copyright © 2017년 Kim Sunmi. All rights reserved.
//

#import "CommonInputViewController.h"

@interface CommonInputViewController ()

@end

@implementation CommonInputViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    UITapGestureRecognizer *tapGesture =[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                action:@selector(dismissKeyboard:)];
    [self.bodyView addGestureRecognizer:tapGesture];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:self.view.window];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:self.view.window];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    if ( [touch.view isKindOfClass:[UITableView class]] ) {
        return NO;
    } else if ( [touch.view isKindOfClass:[UIButton class]] ) {
        //[self hideKeyboard];
        return NO;
    }
    return YES;
}

- (void)dismissKeyboard:(UITapGestureRecognizer *)recognizer {
    
    [self hideKeyboard];
}

- (void) showKeyboard:(UITextField *)textField {
    
    if ( textField ) {
        if ( textField.isSecureTextEntry ) textField.text = @"";
        [textField becomeFirstResponder];
    }
}

- (void) hideKeyboard {
    
    if ( self.selectedInput ) {
        [self.selectedInput resignFirstResponder];
        self.selectedInput = nil;
        return;
    }
    for (UIView * txt in self.bodyView.subviews){
        if ([txt isKindOfClass:[UITextField class]] && [txt isFirstResponder]) {
            [txt resignFirstResponder];
        }
    }
    self.selectedInput = nil;
}

-(void)keyboardWillShow:(NSNotification *)n {
    
    if ( self.selectedInput ) {
        
        NSDictionary* userInfo = [n userInfo];
        CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
        
        self.scrollView.contentSize = CGSizeMake(self.bodyView.frame.size.width, self.bodyView.frame.size.height + keyboardSize.height);
        
        float y = [self.selectedInput.superview convertPoint:self.selectedInput.frame.origin toView:self.bodyView].y;
        float h = self.scrollView.frame.size.height - keyboardSize.height;
        float b = y + self.selectedInput.frame.size.height + 20 - self.scrollView.contentOffset.y;
        
        self.scrollOffset = self.scrollView.contentOffset;
        
        if ( b > h ) {
            
            float move = b - h;
            
            CGPoint offset = self.scrollView.contentOffset;
            offset.y += move;
            
            [UIView animateWithDuration:0.3
                                  delay:0
                                options:UIViewAnimationOptionBeginFromCurrentState
                             animations:^{
                                 self.scrollView.contentOffset = offset;
                             }
                             completion:^(BOOL finished){
                                 
                             }];
        }
    }
}

-(void)keyboardWillHide:(NSNotification *)n {
    
    self.scrollView.contentSize = CGSizeMake(self.bodyView.frame.size.width, self.bodyView.frame.size.height + 1);
    
    if ( self.scrollView.frame.size.height + self.scrollOffset.y > self.bodyView.frame.size.height ) {
        self.scrollOffset = CGPointMake(self.scrollOffset.x, self.bodyView.frame.size.height - self.scrollView.frame.size.height);
    }
    
    if ( self.scrollOffset.y != self.scrollView.contentOffset.y ) {
        
        [UIView animateWithDuration:0.3
                              delay:0
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             
                             
                             self.scrollView.contentOffset = self.scrollOffset;
                         }
                         completion:^(BOOL finished){
                             
                         }];
    }
}

#pragma mark - UITextFieldDelegate

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    self.selectedInput = textField;
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self hideKeyboard];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
