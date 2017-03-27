//
//  WezoneCommentViewController.m
//  wezone
//
//  Created by Kim Sunmi on 2017. 3. 19..
//  Copyright © 2017년 Kim Sunmi. All rights reserved.
//

#import "WezoneCommentViewController.h"

@interface WezoneCommentViewController ()
{
    UITextView *_textView;
    UILabel *_placeHolder;
    
    WezoneModel *_wezone;
    WezoneComment *_comment;
}
@end

@implementation WezoneCommentViewController

- (instancetype)init:(WezoneModel *)wezone comment:(WezoneComment *)comment {

    self = [self init];
    if ( self ) {
        
        _wezone = wezone;
        _comment = comment;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

#pragma mark -
#pragma mark Layout

- (void)makeLayout {
    
    [self makeRoot:NO title:[self getStringWithKey:@"wezone_review_write"] bgColor:UIColorFromRGB(0xeeeeee)];
    [self makeLeftBackButton];
    [self makeRightButton:@"btn_check" target:self selector:@selector(onClickRegist)];
    
    CGRect rect = CGRectMake(0, 0, self.bodyView.frame.size.width, self.bodyView.frame.size.height);
    
    _textView = [[UITextView alloc] init:CGRectMake(0, 0, self.bodyView.frame.size.width, self.bodyView.frame.size.height) parent:self.bodyView tag:0 text:@"" color:UIColor_text align:NSTextAlignmentLeft font:nil size:SIZE_TEXT_M delegate:self];
    
    rect.origin.x = _textView.contentInset.left + _textView.textContainerInset.left + _textView.textContainer.lineFragmentPadding;
    rect.origin.y = _textView.textContainerInset.top;
    
    _placeHolder = [[UILabel alloc] init:rect parent:self.bodyView tag:0 text:[self getStringWithKey:@"wezone_review_write_placeholder"] color:UIColor_hint bgColor:nil align:NSTextAlignmentLeft font:nil size:SIZE_TEXT_M];
    [_placeHolder sizeToFit];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)onClickRegist {
    
    if ( _textView.text.length == 0 ) {
        [GALToastView showWithText:[self getStringWithKey:@"wezone_review_write_placeholder"]];
        return;
    }
    
    GALLangtudyEngine *engine = [GALLangtudyEngine sharedEngine];
    [engine sendRegistComment:_wezone.wezone_id type:@"W" board_id:nil content:_textView.text resultHandler:^(){
        
        [self goBack];
        
    } errorHandler:^(NSDictionary *data, NSError *error) {
        
        [self showErrorToast:data error:error];
    }];
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 
#pragma mark UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {

    NSString *string = [textView.text stringByReplacingCharactersInRange:range withString:text];
    
    _placeHolder.hidden = string.length > 0;

    return YES;
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
