//
//  GALLoginPasswordController.m
//  Langtudy
//
//  Created by SinSuMin on 2016. 8. 16..
//  Copyright © 2016년 galuster. All rights reserved.
//

#import "GALLoginPasswordController.h"
#import "UITextField+GALPaddingText.h"
#import "GALToastView.h"

#import "GALFindPasswordViewController.h"
#import "GALEmailConfirmController.h"


#import "GALNewPasswordViewController.h"

@interface GALLoginPasswordController ()<GALFindPasswordViewControllerDelegate, GALEmailConfirmControllerDelegate,GALNewPasswordViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;

@property (weak, nonatomic) IBOutlet UIButton *lostpwButton;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@property (weak, nonatomic) IBOutlet UITextField *pwField;


@property (strong, nonatomic) NSString *mCode;

@end

@implementation GALLoginPasswordController

- (void) viewDidLoad{
    [super viewDidLoad];
    
//    UIButton *button  = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
//    [button setImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
//    [button setImage:[UIImage imageNamed:@"btn_back_touch"] forState:UIControlStateHighlighted];
//    
//    [button addTarget:self action:@selector(goBackinLogin) forControlEvents:UIControlEventTouchUpInside];
//    
//    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];

//    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
//    
//    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
    
//    [self setTitle:[self getStringWithKey:@"login"]];
//    
//    [self.titleLabel setText:[self getStringWithKey:@"already_on_wezone"]];
//    
//    [self.descLabel setText:[self getStringWithKey:@"please_enter_your_password"]];
//    
//    
//    [self.lostpwButton setTitle:[self getStringWithKey:@"forgot_your_password"] forState:UIControlStateNormal];
//    
//    [self.loginButton setTitle:[self getStringWithKey:@"login"] forState:UIControlStateNormal];
//    
    [self.pwField setText:@"00000000"];
    
//    [self.pwField setLeftPadding:20.0f];
//    [self.pwField setRightPadding:20.0f];
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
//    [self.view addGestureRecognizer:tap];
//    [tap setCancelsTouchesInView:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void) makeLayout {
    
    [self makeRoot:NO title:[self getStringWithKey:@"login"] bgColor:UIColor_main];
    [self makeLeftBackButton];
    
    float x = 20;
    float y = 32;
    
    self.titleLabel = [[UILabel alloc] init:[Layout aspecRect:CGRectMake(x, y, LAYOUT_WIDTH - x * 2, 19)] parent:self.bodyView tag:0 text:[self getStringWithKey:@"already_on_wezone"] color:UIColorFromRGB(0x000000) bgColor:nil align:NSTextAlignmentLeft font:@"bold" size:[Layout aspecValue:17.0f]];
    y += 19 + 10;
    
    self.descLabel = [[UILabel alloc] init:[Layout aspecRect:CGRectMake(x, y, LAYOUT_WIDTH - x * 2, 16)] parent:self.bodyView tag:0 text:[self getStringWithKey:@"please_enter_your_password"] color:UIColorFromRGB(0x6C6C6C) bgColor:nil align:NSTextAlignmentLeft font:nil size:[Layout aspecValue:14.0f]];
    y += 16 + 10;

    self.pwField = [[[UITextField alloc]init:[Layout aspecRect:CGRectMake(x, y, LAYOUT_WIDTH - x * 2, 44)] parent:self.bodyView tag:0] defaultStyle:@"" placeholder:[self getStringWithKey:@"password"] type:UIKeyboardTypeDefault password:YES delegate:nil];
    y += 44 + 6;
  
    self.lostpwButton = [[[[UIButton alloc] init:[Layout aspecRect:CGRectMake(8, y, LAYOUT_WIDTH - 16, 50)] parent:self.bodyView tag:0 target:self action:@selector(onClickLostPasswd:)]
                           addTitle:NSLocalizedString(@"forgot_your_password", @"") font:nil size:[Layout aspecValue:14]] addTitleColor:UIColorFromRGB(0x757575)];
    [self.lostpwButton sizeToFit];
    [self.lostpwButton setX:(self.bodyView.frame.size.width - self.lostpwButton.frame.size.width) / 2];
     
    y += 50 + 6;
    
    self.loginButton = [[[[UIButton alloc] init:[Layout aspecRect:CGRectMake(0, y, LAYOUT_WIDTH, 50)] parent:self.bodyView tag:0 target:self action:@selector(onClickLogin:)]
                         addTitle:[self getStringWithKey:@"start"]]
                        addBackgroundColor:UIColorFromRGB(0x669cf8) highlightedColor:nil disabledColor:nil] ;

    [self.loginButton setY:self.bodyView.frame.size.height - self.loginButton.frame.size.height];
 
    [self.bodyView addTarget:self action:@selector(dismissKeyboard)];
}

//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
//    
//    if ( [touch.view isKindOfClass:[UITableView class]] ) {
//        return NO;
//    } else if ( [touch.view isKindOfClass:[UIButton class]] ) {
//        //[self hideKeyboard];
//        return NO;
//    }
//    return YES;
//}

//- (UIStatusBarStyle)preferredStatusBarStyle
//{
//    return UIStatusBarStyleLightContent;
//}

- (void) viewDidAppear:(BOOL)animated{
    
}


- (IBAction)onClickLostPasswd:(id)sender {
    GALFindPasswordViewController *mGALFindPasswordViewController = [[GALFindPasswordViewController alloc] initWithNibName:@"GALFindPasswordViewController" bundle:nil];
    [mGALFindPasswordViewController setDelegate:self];
    
    [ApplicationDelegate.loginNaviController presentPopupViewController:mGALFindPasswordViewController animationType:MJPopupViewAnimationFade];
}


- (IBAction)onClickLogin:(id)sender {

    NSString *strPass = [[self.pwField text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if([strPass length] < 1){
        [GALToastView showWithText:[self getStringWithKey:@"please_enter_your_password"]];
        return;
    }
    
    if([strPass length] < 8){
        [GALToastView showWithText:[self getStringWithKey:@"password_limit_error"]];
        return;
    }

    [self requestLoginWithPw:strPass];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)txtField
{
    [txtField resignFirstResponder];
    [self onClickLogin:nil];
    return NO;
}


- (void) requestLoginWithPw:(NSString *)pw{
        
    GALLangtudyEngine *engine = [GALLangtudyEngine sharedEngine];
    
    ApplicationDelegate.loginData.loginParam.provider_type = @"W";
    ApplicationDelegate.loginData.loginParam.login_id = ApplicationDelegate.loginNaviController.email;
    ApplicationDelegate.loginData.loginParam.login_passwd = pw;
    
    ApplicationDelegate.loginData.loginParam.latitude = ApplicationDelegate.loginData.user_latitude;
    ApplicationDelegate.loginData.loginParam.longitude = ApplicationDelegate.loginData.user_longitude;
    
    [engine requestLogin:ApplicationDelegate.loginData.loginParam resultHandler:^(GALServerInfo *serverInfo, GALUserInfo *userInfo, NSMutableArray *payInfoList, NSString *email_auth) {
        
        if([@"G" isEqualToString:ApplicationDelegate.loginData.loginParam.provider_type]){
            
            [GALangtudyUtils saveValue:@"G" Key:SHARE_KEY_PROVIDER_TYPE];
            [GALangtudyUtils saveValue:ApplicationDelegate.loginNaviController.googleData.userId Key:SHARE_KEY_PROVIDER_ID];
            [GALangtudyUtils saveValue:ApplicationDelegate.loginData.loginParam.provider_email Key:SHARE_KEY_PROVIDER_MAIL];
            
        }else if([@"F" isEqualToString:ApplicationDelegate.loginData.loginParam.provider_type]){
            
            [GALangtudyUtils saveValue:@"F" Key:SHARE_KEY_PROVIDER_TYPE];
            [GALangtudyUtils saveValue:ApplicationDelegate.loginNaviController.facebookData.userId Key:SHARE_KEY_PROVIDER_ID];
            //            [GALangtudyUtils saveValue:ApplicationDelegate.loginNaviController.facebookData.userId Key:SHARE_KEY_PROVIDER_ID];
            
        }else{
            
            [GALangtudyUtils saveValue:@"W" Key:SHARE_KEY_PROVIDER_TYPE];
            [GALangtudyUtils saveValue:ApplicationDelegate.loginData.loginParam.login_id Key:SHARE_KEY_LANGTUDY_ID];
            [GALangtudyUtils saveValue:ApplicationDelegate.loginData.loginParam.login_passwd Key:SHARE_KEY_LANGTUDY_PW];
        }
        
        
        ApplicationDelegate.loginData.server_info = serverInfo;
        ApplicationDelegate.loginData.user_info = userInfo;
        
        ApplicationDelegate.loginData.email_auth = email_auth;
        
        
//        //pay info 추출
//        for(NSInteger i=0; i<[payInfoList count]; i++){
//            GALPayInfo *payinfo = [payInfoList objectAtIndex:i];
//            
//            if([STORE_APPLEAPPSTORE isEqualToString:payinfo.store_name]){
//                ApplicationDelegate.loginData.pay_info = payinfo;
//            }
//        }
        
        [ApplicationDelegate changeRootViewControllerWithMain:YES];
        
    } errorHandler:^(NSDictionary *data, NSError *error) {
        NSString *errorCode = data[@"code"];
        
        NSLog(@"%@",errorCode);

        [self checkLoginError:errorCode];
    }];
    
}

- (void) checkLoginError:(NSString *)errorCode{
    
    if([LOGIN_ERROR_ID isEqualToString:errorCode]){
       
        [self worngPasswordAlert];
       
    }else if([LOGIN_ERROR_PW isEqualToString:errorCode]){
        
        [self worngPasswordAlert];
        
    }else if([LOGIN_ERROR_LANGTUDY isEqualToString:errorCode]){
        
        [self worngPasswordAlert];
        
    }else if([LOGIN_ERROR_TYPE isEqualToString:errorCode]){
        
    }else if([LOGIN_ERROR_UUID isEqualToString:errorCode]){
        
    }else if([LOGIN_ERROR_PROVIDER isEqualToString:errorCode]){
        
    }else if([LOGIN_ERROR_EMAIL isEqualToString:errorCode]){

        [GALToastView showWithText:[self getStringWithKey:@"the_unregistered_email"]];
        
    }else if([LOGIN_ERROR_CODE isEqualToString:errorCode]){
        
    }else if([LOGIN_ERROR_PW_FAIL isEqualToString:errorCode]){
        
        [GALToastView showWithText:[self getStringWithKey:@"the_password_change_failed"]];
        
    }else if([LOGIN_ERROR_ALREADY_EMAIL isEqualToString:errorCode]){
        
        
    }else if([LOGIN_ERROR_ALREADY_REGI isEqualToString:errorCode]){
        
    }else{
        [GALToastView showWithText:[self getStringWithKey:@"login_error"]];
    }
}

- (void) worngPasswordAlert{
    
    [GALangtudyUtils showAlertWithButtons:@[[self getStringWithKey:@"forgot_password"], [self getStringWithKey:@"try_again"]] message:[self getStringWithKey:@"wrong_email_or_password"] close:^(int buttonIndex) {
        
        if(buttonIndex == 0){
            GALFindPasswordViewController *mGALFindPasswordViewController = [[GALFindPasswordViewController alloc] initWithNibName:@"GALFindPasswordViewController" bundle:nil];
            [mGALFindPasswordViewController setDelegate:self];
            
            [ApplicationDelegate.loginNaviController presentPopupViewController:mGALFindPasswordViewController animationType:MJPopupViewAnimationFade];
        }else{
            [self.pwField becomeFirstResponder];
        }
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
    
    //if(IS_4_INCH){
        [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionTransitionNone
                         animations:^{
                             if(IS_3_5_INCH){
                                 CGRect rect = self.view.frame;
                                 rect.origin.y -= (keyboardSize.height / 4);
                                 self.view.frame = rect;
                                 
                                 rect = self.loginButton.frame;
                                 rect.origin.y = self.view.frame.size.height - rect.size.height - keyboardSize.height + (keyboardSize.height / 4);
                                 self.loginButton.frame = rect;

                             } else {
                                 CGRect rect = self.loginButton.frame;
                                 rect.origin.y = self.view.frame.size.height - rect.size.height - keyboardSize.height;
                                 self.loginButton.frame = rect;
                             }
                             
                         }
                         completion:nil
         ];
   // }
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
    
    //if(IS_4_INCH){
        [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionTransitionNone
                         animations:^{
                             if(IS_3_5_INCH){
                                 CGRect rect = self.view.frame;
                                 rect.origin.y += (keyboardSize.height / 4);
                                 self.view.frame = rect;
                             }
                             CGRect rect = self.loginButton.frame;
                             rect.origin.y = self.view.frame.size.height - rect.size.height;
                             self.loginButton.frame = rect;
                         }
                         completion:nil
         ];
    //}
}


- (void) dismissKeyboard{
    [self.pwField endEditing:YES];
}


- (void)onClickSendMail:(NSString *)email{
    
    GALLangtudyEngine *engine = [GALLangtudyEngine sharedEngine];
    [engine sendFindPasswd:email resultHandler:^{
        
        [GALangtudyUtils saveValue:@"T" Key:SHARE_IS_EMAIL_CONFIRM];
        [GALangtudyUtils saveValue:email Key:SHARE_SEND_MAIL];
        
        GALEmailConfirmController *mGALEmailConfirmController = [[GALEmailConfirmController alloc] initWithEmail:ApplicationDelegate.loginNaviController.email];
        [mGALEmailConfirmController setDelegate:self];
        
        [ApplicationDelegate.loginNaviController presentPopupViewController:mGALEmailConfirmController animationType:MJPopupViewAnimationFade];
        
        
    } errorHandler:^(NSDictionary *data, NSError *error) {
    
    }];
}

- (void) onClickSendCode:(NSString *)code{
    
    GALLangtudyEngine *engine = [GALLangtudyEngine sharedEngine];
    
    NSString *email = [GALangtudyUtils getValue:SHARE_SEND_MAIL];
    self.mCode = code;
    
    [engine sendCheckCode:email withCode:code withPass:nil resultHandler:^{
        GALNewPasswordViewController *mGALNewPasswordViewController = [[GALNewPasswordViewController alloc] initWithEmail:email];
        [mGALNewPasswordViewController setDelegate:self];
        
        [ApplicationDelegate.loginNaviController presentPopupViewController:mGALNewPasswordViewController animationType:MJPopupViewAnimationFade];
        
    } errorHandler:^(NSDictionary *data, NSError *error) {
       
        NSString *errorCode = data[@"code"];
        
        if([LOGIN_ERROR_CODE isEqualToString:errorCode]){
            [GALToastView showWithText:[self getStringWithKey:@"the_verification_number_is_incorrect"]];
        }else{
            [GALToastView showWithText:[self getStringWithKey:@"network_error"]];
        }
    }];
}


- (void)onClickChangePassword:(NSString *)pw{
    
    GALLangtudyEngine *engine = [GALLangtudyEngine sharedEngine];
    
    NSString *email = ApplicationDelegate.loginNaviController.email;
    
    [engine sendCheckCode:email withCode:self.mCode withPass:pw resultHandler:^{
        [GALangtudyUtils saveValue:@"F" Key:SHARE_IS_EMAIL_CONFIRM];
        [GALangtudyUtils saveValue:@"" Key:SHARE_SEND_MAIL];
    } errorHandler:^(NSDictionary *data, NSError *error) {
        
        NSString *errorCode = data[@"code"];
        if([LOGIN_ERROR_CODE isEqualToString:errorCode]){
            [GALToastView showWithText:[self getStringWithKey:@"the_password_change_failed"]];
        }else{
            [GALToastView showWithText:[self getStringWithKey:@"network_error"]];
        }
    }];
}
@end
