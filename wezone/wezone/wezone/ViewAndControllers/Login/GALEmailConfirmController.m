//
//  GALEmailConfirmController.m
//  Langtudy
//
//  Created by SinSuMin on 2016. 11. 14..
//  Copyright © 2016년 galuster. All rights reserved.
//

#import "GALEmailConfirmController.h"
#import "GALToastView.h"

@interface GALEmailConfirmController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *descLabel;

@property (weak, nonatomic) IBOutlet UITextField *codeTextField;


@property (weak, nonatomic) IBOutlet UIButton *notRecieveBtn;
@property (weak, nonatomic) IBOutlet UIButton *confirmLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *verticalCenterConstraints;

@property (strong,nonatomic) NSString *mail;

@end

@implementation GALEmailConfirmController

- (id)initWithEmail:(NSString *)email{
    
    self = [super initWithNibName:@"GALEmailConfirmController" bundle:nil];
    if (self) {
        // Custom initialization
        [self setMail:email];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    [self.titleLabel setText:LSSTRING(@"code")];
    
    [self.codeTextField setPlaceholder:LSSTRING(@"code")];
    
    [self.descLabel setText:[NSString stringWithFormat:LSSTRING(@"we_have_sent_a_push_message"),self.mail]];
    
    [self.notRecieveBtn setTitle:LSSTRING(@"not_receive_mail") forState:UIControlStateNormal];
    [self.notRecieveBtn setTitle:LSSTRING(@"not_receive_mail") forState:UIControlStateHighlighted];
    
    [self.confirmLabel setTitle:LSSTRING(@"send") forState:UIControlStateNormal];
    [self.confirmLabel setTitle:LSSTRING(@"send") forState:UIControlStateHighlighted];
    
    
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
    [self.codeTextField endEditing:YES];
}

- (void) closePopup{
    [ApplicationDelegate.loginNaviController dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
}

- (IBAction)onClickNotRecieve:(id)sender {
    
    [GALangtudyUtils saveValue:@"F" Key:SHARE_IS_EMAIL_CONFIRM];
    [GALangtudyUtils saveValue:@"" Key:SHARE_SEND_MAIL];
    
    [self closePopup];
}

- (IBAction)onClickSend:(id)sender {
    
    NSString *strId = [[self.codeTextField text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if([strId length] < 1){
        //        [self.idField shakeAnimationWithVibrate:YES];
        [GALToastView showWithText:LSSTRING(@"please_enter_your_code")];
        return;
    }
    
    [self.delegate onClickSendCode:strId];
    [self closePopup];
}

- (IBAction)onClickOther:(id)sender {
    
    [self closePopup];
}

@end
