//
//  GALFindPasswordViewController.m
//  Langtudy
//
//  Created by SinSuMin on 2016. 11. 14..
//  Copyright © 2016년 galuster. All rights reserved.
//

#import "GALFindPasswordViewController.h"
#import "GALToastView.h"
#import "GALAlertView.h"

@interface GALFindPasswordViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *verticalCenterConstraints;

@end

@implementation GALFindPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.titleLabel setText:LSSTRING(@"forgot_password")];
    
    [self.emailTextField setPlaceholder:LSSTRING(@"email")];
    [self.emailTextField setLeftPadding:20];
    [self.emailTextField setRightPadding:20];
    
    [self.emailTextField setText:ApplicationDelegate.loginNaviController.email];
    
    [self.descLabel setText:LSSTRING(@"login_find_email_desc")];
    
    [self.sendBtn setTitle:LSSTRING(@"send") forState:UIControlStateNormal];
    [self.sendBtn setTitle:LSSTRING(@"send") forState:UIControlStateHighlighted];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
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
    
    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         CGFloat height = keyboardSize.height / 2;
                         [self.verticalCenterConstraints setConstant:-height];
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
    
    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         [self.verticalCenterConstraints setConstant:0];
                     }
                     completion:nil
     ];
}

- (void) dismissKeyboard{
    [self.emailTextField endEditing:YES];
}



- (void) closePopup{
    [ApplicationDelegate.loginNaviController dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
}


- (IBAction)onClickSend:(id)sender {
    
    NSString *strId = [[self.emailTextField text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if([strId length] < 1){
        //        [self.idField shakeAnimationWithVibrate:YES];
        [GALToastView showWithText:LSSTRING(@"please_enter_id")];
        return;
    }
    
    if([GALangtudyUtils validateEmail:strId] == NO){
        [GALToastView showWithText:LSSTRING(@"not_the_email_type")];
        return;
    }
    
    [self.delegate onClickSendMail:strId];
    
    [self closePopup];
}

- (IBAction)onClickOther:(id)sender {
    [self closePopup];
}

@end
