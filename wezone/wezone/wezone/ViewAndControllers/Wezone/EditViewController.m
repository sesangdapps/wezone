//
//  EditViewController.m
//  wezone
//
//  Created by Kim Sunmi on 2017. 3. 21..
//  Copyright © 2017년 Kim Sunmi. All rights reserved.
//

#import "EditViewController.h"

@interface EditViewController ()
{
    NSString *_title;
    NSString *_content;
    NSString *_placeholder;
    EditCompletionBlock _completion;
    
    UITextView *_textView;
    UILabel *_placeHolder;
}
@end

@implementation EditViewController

-(instancetype)init:(NSString *)title content:(NSString *)content placeholder:(NSString *)placeholder completion:(EditCompletionBlock)completion {

    self = [self init];
    if ( self ) {
        _title = title;
        _content = content;
        _placeholder = placeholder;
        _completion = completion;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark -
#pragma mark Layout

- (void)makeLayout {
    
    [self makeRoot:NO title:_title bgColor:UIColorFromRGB(0xeeeeee)];
    [self makeLeftBackButton];
    [self makeRightButton:@"btn_check" target:self selector:@selector(onClickRegist)];
    
    CGRect rect = CGRectMake(0, 0, self.bodyView.frame.size.width, self.bodyView.frame.size.height);
    
    _textView = [[UITextView alloc] init:CGRectMake(0, 0, self.bodyView.frame.size.width, self.bodyView.frame.size.height) parent:self.bodyView tag:0 text:_content color:UIColor_text align:NSTextAlignmentLeft font:nil size:SIZE_TEXT_M delegate:self];
    
    rect.origin.x = _textView.contentInset.left + _textView.textContainerInset.left + _textView.textContainer.lineFragmentPadding;
    rect.origin.y = _textView.textContainerInset.top;
    
    _placeHolder = [[UILabel alloc] init:rect parent:self.bodyView tag:0 text:_placeholder color:UIColor_hint bgColor:nil align:NSTextAlignmentLeft font:nil size:SIZE_TEXT_M];
    [_placeHolder sizeToFit];
    
    _placeHolder.hidden = _content.length > 0;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)onClickRegist {
    
    if ( [CommonUtil isEmpty:_textView.text] ) {
        [GALToastView showWithText:_placeholder];
        return;
    }
    if ( _completion ) {
        _completion(_textView.text);
    }
    [self goBack];
}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}



#pragma mark - Keyboard Notification Function
- (void)keyboardWillShow: (NSNotification *)notification{
    
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (UIInterfaceOrientationIsLandscape(interfaceOrientation)) {
        CGFloat tmp = keyboardSize.height;
        keyboardSize.height = keyboardSize.width;
        keyboardSize.width = tmp;
    }
    NSLog(@">> %s - keyboardSize:%@", __func__, NSStringFromCGSize(keyboardSize));
    
    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         CGRect rect = self.bodyView.frame;
                         [_textView setHeight:rect.size.height - keyboardSize.height];
                     }
                     completion:nil
     ];
}

- (void)keyboardWillHide: (NSNotification *)notification{
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (UIInterfaceOrientationIsLandscape(interfaceOrientation)) {
        CGFloat tmp = keyboardSize.height;
        keyboardSize.height = keyboardSize.width;
        keyboardSize.width = tmp;
    }
    NSLog(@">> %s - keyboardSize:%@", __func__, NSStringFromCGSize(keyboardSize));
    
    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         CGRect rect = self.bodyView.frame;
                         [_textView setHeight:rect.size.height];
                     }
                     completion:nil
     ];
}

- (void) dismissKeyboard{
    [_textView endEditing:YES];
}

#pragma mark -
#pragma mark UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    NSString *string = [textView.text stringByReplacingCharactersInRange:range withString:text];
    
    _placeHolder.hidden = string.length > 0;
    
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
