//
//  GALLoginViewController.m
//  Langtudy
//
//  Created by SinSuMin on 2015. 9. 3..
//  Copyright (c) 2015년 galuster. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GALLoginViewController.h"

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

//#import "GALLearnLangController.h"

#import "GALSignPasswordController.h"
#import "GALLoginPasswordController.h"

#import "UITextField+GALPaddingText.h"

#import "GALGoogle.h"
#import "GALFacebook.h"

#import "GALWebViewController.h"


#import "GALEmailConfirmController.h"
#import "GALNewPasswordViewController.h"

@interface GALLoginViewController ()<GALEmailConfirmControllerDelegate,GALNewPasswordViewControllerDelegate>

//static views
@property (weak, nonatomic) IBOutlet UIButton *emailButton;
@property (weak, nonatomic) IBOutlet UIButton *kakaotalkButton;
@property (weak, nonatomic) IBOutlet UIButton *facebookButton;
@property (weak, nonatomic) IBOutlet UIButton *googleButton;
@property (weak, nonatomic) IBOutlet UIButton *privacyButton;


//@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollviewHeight;

@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UITextField *idField;


@property (strong, nonatomic) NSString *mCode;


- (IBAction)onClickLangtudyLogin:(id)sender;
- (IBAction)onClickGoogleLogin:(id)sender;
- (IBAction)onClickFacebookLogin:(id)sender;
- (IBAction)onClickPrivacy:(id)sender;

@end

@implementation GALLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization

    }
    return self;
}

- (void) viewDidLoad{
    
    [super viewDidLoad];
    
//    [self.emailButton setTitle:[self getStringWithKey:@"Login"] forState:UIControlStateNormal];
//    [self.emailButton setTitle:[self getStringWithKey:@"Login"] forState:UIControlStateHighlighted];
//    
//    [self.kakaotalkButton setTitle:[self getStringWithKey:@"KakaoTalk"] forState:UIControlStateNormal];
//    [self.kakaotalkButton setTitle:[self getStringWithKey:@"KakaoTalk"] forState:UIControlStateHighlighted];
//    
//    [self.googleButton setTitle:[self getStringWithKey:@"Google+"] forState:UIControlStateNormal];
//    [self.googleButton setTitle:[self getStringWithKey:@"Google+"] forState:UIControlStateHighlighted];
//    
//    [self.facebookButton setTitle:[self getStringWithKey:@"Facebook"] forState:UIControlStateNormal];
//    [self.facebookButton setTitle:[self getStringWithKey:@"Facebook"] forState:UIControlStateHighlighted];
//    
//    [self.privacyButton setTitle:[self getStringWithKey:@"login_terms_of_service"] forState:UIControlStateNormal];
//    [self.privacyButton setTitle:[self getStringWithKey:@"login_terms_of_service"] forState:UIControlStateHighlighted];
//    
//    [self.idField setPlaceholder:[self getStringWithKey:@"email"]];
    
    [self.idField setText:@"test3333@galuster.com"];
    
//    [self setScrollviewLayout];
    
    NSArray *currentScopes = [GIDSignIn sharedInstance].scopes;
    [currentScopes arrayByAddingObject:GOOGLE_API_SCOPE_YOUTUBE];
    [currentScopes arrayByAddingObject:GOOGLE_API_SCOPE_YOUTUBE_UPLOAD];
    
//    NSArray *currentScopes = [NSArray arrayWithObjects:GOOGLE_API_SCOPE_PLUS_ME,GOOGLE_API_SCOPE_YOUTUBE,GOOGLE_API_SCOPE_YOUTUBE_UPLOAD,nil];
    
    [[GIDSignIn sharedInstance] setScopes:currentScopes];
    [[GIDSignIn sharedInstance] setDelegate:self];
    [[GIDSignIn sharedInstance] setUiDelegate:self];
    
    
//    [self.idField setLeftPadding:20.0f];
//    [self.idField setRightPadding:20.0f];
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
//    [self.view addGestureRecognizer:tap];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
//    
    
    
    NSString *isNeedConfirm = [GALangtudyUtils getValue:SHARE_IS_EMAIL_CONFIRM];
    if([@"T" isEqualToString:isNeedConfirm]){

        NSString *email = [GALangtudyUtils getValue:SHARE_SEND_MAIL];
        
        GALEmailConfirmController *mGALEmailConfirmController = [[GALEmailConfirmController alloc] initWithEmail:email];
        [mGALEmailConfirmController setDelegate:self];
        
        [ApplicationDelegate.loginNaviController presentPopupViewController:mGALEmailConfirmController animationType:MJPopupViewAnimationFade];
    }
}

- (void) makeLayout {

    [self makeRoot:YES title:nil bgColor:UIColor_main];
    
    
    UIView *view = [[UIView alloc] init:[Layout aspecRect:CGRectMake(0, 0, LAYOUT_WIDTH, 100)] parent:self.bodyView tag:0 color:[UIColor clearColor]];

    float y = 0;
    float h = 44;
    float g = 3;
    
    self.idField = [[[UITextField alloc]init:[Layout aspecRect:CGRectMake(8, y, LAYOUT_WIDTH - 16, h)] parent:view tag:0] defaultStyle:@"" placeholder:@"" type:UIKeyboardTypeEmailAddress password:NO delegate:self];
    y += h + g;

    UIFont *font = [UIFont systemFontOfSize:15];
    
    self.emailButton = [[[[UIButton alloc] init:[Layout aspecRect:CGRectMake(8, y, LAYOUT_WIDTH - 16, h)] parent:view tag:0 target:self action:@selector(onClickLangtudyLogin:)]
                          addTitle:[self getStringWithKey:@"Login"]] blueStyle];
    y += h + g;
    
    self.kakaotalkButton = [[[[UIButton alloc] init:[Layout aspecRect:CGRectMake(8, y, LAYOUT_WIDTH - 16, h)] parent:view tag:0 target:self action:@selector(onClickKakaotalkLogin:)]
                         addTitle:[self getStringWithKey:@"KakaoTalk"]] outlineStyle] ;
    y += h + g;
    
    self.googleButton = [[[[UIButton alloc] init:[Layout aspecRect:CGRectMake(8, y, LAYOUT_WIDTH - 16, h)] parent:view tag:0 target:self action:@selector(onClickGoogleLogin:)]
                         addTitle:[self getStringWithKey:@"Google+"]] outlineStyle];
    y += h + g;
    
    self.facebookButton = [[[[UIButton alloc] init:[Layout aspecRect:CGRectMake(8, y, LAYOUT_WIDTH - 16, h)] parent:view tag:0 target:self action:@selector(onClickFacebookLogin:)]
                         addTitle:[self getStringWithKey:@"Facebook"]] outlineStyle];
    y += h + g;
    
    self.privacyButton = [[[[UIButton alloc] init:[Layout aspecRect:CGRectMake(8, y, LAYOUT_WIDTH - 16, 25)] parent:view tag:0 target:self action:@selector(onClickPrivacy:)]
                           addTitle:NSLocalizedString(@"login_terms_of_service", @"") font:nil size:[Layout aspecValue:SIZE_TEXT_S]] addTitleColor:UIColor_text];
    y += 25 + 10;
    
    [view setHeight:[Layout aspecValue:y]];
    [view setY:self.bodyView.frame.size.height - view.frame.size.height];
    
    UIImageView *thumbnail = [[UIImageView alloc] init:CGRectMake(0, 0, self.bodyView.frame.size.width, y) parent:self.bodyView tag:0 imageName:nil];
    
    [self.bodyView addTarget:self action:@selector(dismissKeyboard)];
}

//- (void) viewWillAppear:(BOOL)animated{
//    
//    [ApplicationDelegate.loginNaviController setNavigationBarHidden:YES];
////        [self.navigationController setNavigationBarHidden:YES];
//    [self dismissKeyboard];
//}
//
//- (void) viewWillDisappear:(BOOL)animated{
//       [ApplicationDelegate.loginNaviController setNavigationBarHidden:YES];
//    
//    [self dismissKeyboard];
//}

//- (void)scrollViewDidScroll:(UIScrollView *) sender{
//    
//    CGFloat pageWidth = self.scrollView.frame.size.width;
//    int page = floor((self.scrollView.contentOffset.x - pageWidth/2) /pageWidth) +1;
//    self.pageControl.currentPage = page;
//}
//
//- (void) setScrollviewLayout{
//    
//    NSArray *imgArray = [NSArray arrayWithObjects:
//                         [UIImage imageNamed:@"im_langtudy_one.png"],
//                         [UIImage imageNamed:@"im_langtudy_two.png"],
//                         [UIImage imageNamed:@"im_langtudy_three.png"],
//                         [UIImage imageNamed:@"im_langtudy_four.png"],
//                         nil];
//    
//    NSArray *textArray = [NSArray arrayWithObjects:
//                          [self getStringWithKey:@"login_noti_01"],
//                          [self getStringWithKey:@"login_noti_02"],
//                          [self getStringWithKey:@"login_noti_03"],
//                          [self getStringWithKey:@"login_noti_04"],
//                          nil];
//    
//    [self.view setNeedsLayout];
//    [self.view layoutIfNeeded];
//
//    
//    CGRect scrollviewRect = self.scrollView.bounds;
//    CGFloat scrollWidth = scrollviewRect.size.width;
//    CGFloat screenHeight = scrollWidth / 1.2f; //이미지 비율에 맞춤(1440 x 1117)
//
//    //    self.scrollView.frame = screenRect;
//    CGFloat scrollviewHeight = self.scrollView.bounds.size.height;
//    
//    for(int i=0; i<4; i++){
//        
//        UIView *itemView = [[UIView alloc] initWithFrame:CGRectMake(scrollWidth*i, 0.0f, scrollWidth, scrollviewHeight)];
//        
//        CGRect imageRect;
//        imageRect = CGRectMake(0.0f, 0.0f, scrollWidth, screenHeight);
//        
//        if(i==0){
//            UIImageView *imageBg = [[UIImageView alloc] initWithFrame:imageRect];
//            [imageBg setImage:[UIImage imageNamed:@"im_map.png"]];
//            [itemView addSubview:imageBg];
//        }
//        
//        UIImageView *imageView = [[UIImageView alloc] initWithFrame:imageRect];
//        [imageView setImage:[imgArray objectAtIndex:i]];
//        
//        [itemView addSubview:imageView];
//        
//        CGFloat lableHeight = scrollviewHeight - screenHeight;
//        
//        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, screenHeight, scrollWidth - 20.0f, lableHeight)];
//        [textLabel setNumberOfLines:3];
//        [textLabel setFont:[UIFont systemFontOfSize:12.0f]];
//        [textLabel setTextAlignment:NSTextAlignmentCenter];
//        [textLabel setText:[textArray objectAtIndex:i]];
//        
//        [itemView addSubview:textLabel];
//        
//        [self.scrollView addSubview:itemView];
//    }
//    
//    if(IS_3_5_INCH){
//        self.scrollView.frame = CGRectMake(0.0f, 20.0f, scrollWidth, scrollviewHeight);
//    }else{
//        self.scrollView.frame = CGRectMake(0.0f, scrollviewRect.origin.y, scrollWidth, scrollviewHeight);
//    }
//    
//    self.scrollView.contentSize = CGSizeMake(scrollWidth * 4, screenHeight);
//    
//    self.pageControl.pageIndicatorTintColor = UIColorFromRGB(0xe9e3e4);
//    self.pageControl.currentPageIndicatorTintColor = UIColorFromRGB(0xc3c3c4);
//    
//    self.pageControl.currentPage = 0;
//    self.pageControl.numberOfPages = 4;
//}


//-(void)dealloc{
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
//}
//
//
//
//#pragma mark - Keyboard Notification Function
//- (void)keyboardWillShow: (NSNotification *)notification{
//    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
//    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
//    if (UIInterfaceOrientationIsLandscape(interfaceOrientation)) {
//        CGFloat tmp = keyboardSize.height;
//        keyboardSize.height = keyboardSize.width;
//        keyboardSize.width = tmp;
//    }
//    NSLog(@">> %s - keyboardSize:%@", __func__, NSStringFromCGSize(keyboardSize));
//    
//    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionTransitionNone
//                     animations:^{
//                         CGRect rect = self.view.frame;
//                         
//                         if(rect.origin.y < 0){
//                             
//                         }else{
//                             rect.origin.y -= keyboardSize.height;
//                             self.view.frame = rect;
//                         }
//                         
//                     }
//                     completion:nil
//     ];
//}
//
//- (void)keyboardWillHide: (NSNotification *)notification{
//    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
//    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
//    if (UIInterfaceOrientationIsLandscape(interfaceOrientation)) {
//        CGFloat tmp = keyboardSize.height;
//        keyboardSize.height = keyboardSize.width;
//        keyboardSize.width = tmp;
//    }
//    NSLog(@">> %s - keyboardSize:%@", __func__, NSStringFromCGSize(keyboardSize));
//    
//    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionTransitionNone
//                     animations:^{
//                         CGRect rect = self.view.frame;
//                         
//                         if(rect.origin.y < 0){
//                             rect.origin.y += keyboardSize.height;
//                             self.view.frame = rect;
//                         }
//                     }
//                     completion:nil
//     ];
//}
//
//- (void) dismissKeyboard{
//    [self.idField endEditing:YES];
//}


#pragma mark - Button Action
- (IBAction)onClickLangtudyLogin:(id)sender {
//    [self requestLogin];
    
    NSString *strId = [[self.idField text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if([strId length] < 1){
//        [self.idField shakeAnimationWithVibrate:YES];
        [GALToastView showWithText:[self getStringWithKey:@"please_enter_id"]];
        return;
    }
    
    if([GALangtudyUtils validateEmail:strId] == NO){
        [GALToastView showWithText:[self getStringWithKey:@"not_the_email_type"]];
        return;
    }
    
    
    
    GALLangtudyEngine *engine = [GALLangtudyEngine sharedEngine];
    
    [engine requestCheckMail:strId resultHandler:^{
        
        NSString *strId = [[self.idField text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
//        GALLoginPasswordController *mGALLoginPasswordController = [[GALLoginPasswordController alloc] initWithNibName:@"GALLoginPasswordController" bundle:nil];
//        
//        [ApplicationDelegate.loginNaviController setEmail:strId];
//        
//        [ApplicationDelegate.loginNaviController pushViewController:mGALLoginPasswordController animated:YES];
        
        
        GALSignPasswordController *mGALSignPasswordController = [[GALSignPasswordController alloc] initWithTotalCount:5];

        [ApplicationDelegate.loginNaviController setProvideType:@"W"];
        [ApplicationDelegate.loginNaviController setEmail:strId];

        [ApplicationDelegate.loginNaviController pushViewController:mGALSignPasswordController animated:YES];
        
//        [self.navigationController pushViewController:mGALSignPasswordController animated:YES];
        
//        [ApplicationDelegate.loginNaviController pushViewController:mGALSignPasswordController animated:YES];
        
    } errorHandler:^(NSDictionary *data, NSError *error) {

        NSString *errorCode = data[@"code"];
        
        NSString *email = data[@"email"];
        NSString *provider = data[@"provider"];
        
        NSLog(@"%@",errorCode);
        [self checkLoginError:errorCode withEmail:email withProvider:provider];
        
//        [ApplicationDelegate.loginNaviController chechLoginError:errorCode];
    }];
    
}

- (IBAction)onClickKakaotalkLogin:(id)sender {
    
   
    
}

- (IBAction)onClickGoogleLogin:(id)sender {

    [GALangtudyUtils showActivityIndicator];
    
    [[GIDSignIn sharedInstance] signIn];
    
}

- (IBAction)onClickFacebookLogin:(id)sender {
    
    [GALangtudyUtils showActivityIndicator];
    
    if ([FBSDKAccessToken currentAccessToken]){
        [self getFacebookProfileInfos];
    }else{
        FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
        [login logInWithReadPermissions: @[@"public_profile"] fromViewController:self
                                handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
                                    if (error) {
                                        NSLog(@"Process error");
                                        [GALangtudyUtils hideActivityIndicator];
                                        
                                    } else if (result.isCancelled) {
                                        NSLog(@"Cancelled");
                                        
                                        [GALangtudyUtils hideActivityIndicator];
                                        
                                    } else {
                                        [GALangtudyUtils showActivityIndicator];
                                        [self getFacebookProfileInfos];
                                        NSLog(@"Logged in");
                                    }
                                }];
    }
    [GALangtudyUtils hideActivityIndicator];
}


- (IBAction)onClickPrivacy:(id)sender {
    
    GALWebViewController *wvController = [[GALWebViewController alloc] initWithType:WebViewTypePrivacy withURL:NETURL_TERMS_OF_SERVICE withTitle:[self getStringWithKey:@"terms_of_service"]];
    
    [ApplicationDelegate.loginNaviController pushViewController:wvController animated:YES];
}

- (IBAction)onClickPageControll:(id)sender {
    
    UIPageControl *pager=sender;
    int page = pager.currentPage;
    CGRect frame = self.scrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [self.scrollView scrollRectToVisible:frame animated:YES];
}


#pragma mark - Google & Facebook
- (void)signIn:(GIDSignIn *)signIn
didSignInForUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    // Perform any operations on signed in user here.
    
    [GALangtudyUtils hideActivityIndicator];
    
    if(user != nil){
        [ApplicationDelegate.loginNaviController setProvideType:@"G"];
        
        GALGoogle *googleData = [GALGoogle new];
        [googleData setUserId:user.userID];
        [googleData setIdToken:user.authentication.idToken];
        [googleData setFullName:user.profile.name];
        [googleData setGivenName:user.profile.givenName];
        [googleData setFamilyName:user.profile.familyName];
        [googleData setEmail:user.profile.email];
        [googleData setImgUrl:[[user.profile imageURLWithDimension:500] absoluteString]];
        
        _idField.text = user.profile.email;
        
        [ApplicationDelegate.loginNaviController setGoogleData:googleData];
        
        [self requestLogin:@"G" withId:[googleData userId] withPw:nil withMail:[googleData email]];
    }
}

- (void)signIn:(GIDSignIn *)signIn
didDisconnectWithUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    // Perform any operations when the user disconnects from app here.
    // ...
    
    [GALangtudyUtils hideActivityIndicator];
}


// Stop the UIActivityIndicatorView animation that was started when the user
// pressed the Sign In button
- (void)signInWillDispatch:(GIDSignIn *)signIn error:(NSError *)error {
    [GALangtudyUtils hideActivityIndicator];
}

// Present a view that prompts the user to sign in with Google
- (void)signIn:(GIDSignIn *)signIn
presentViewController:(UIViewController *)viewController {
    [self presentViewController:viewController animated:YES completion:nil];
}

// Dismiss the "Sign in with Google" view
- (void)signIn:(GIDSignIn *)signIn
dismissViewController:(UIViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)getFacebookProfileInfos {
    
    
    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"id, name, link, first_name, last_name, picture.type(large), email, birthday ,location ,friends ,hometown , friendlists"}]
     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
         
         dispatch_async(dispatch_get_main_queue(), ^{
             [GALangtudyUtils hideActivityIndicator];
             
             if (!error)
             {
                 
                 [ApplicationDelegate.loginNaviController setProvideType:@"F"];
                 
                 GALFacebook *fbData = [GALFacebook new];
                 fbData.userId = result[@"id"];
                 fbData.first_name = result[@"first_name"];
                 fbData.last_name = result[@"last_name"];
                 fbData.name = result[@"name"];
                 fbData.link = result[@"link"];
                 fbData.email = result[@"email"];
                 
                 NSDictionary *dic = result[@"picture"];
                 NSDictionary *dataDic = dic[@"data"];
                 
                 fbData.photo_url = dataDic[@"url"];
                 
                 [ApplicationDelegate.loginNaviController setFacebookData:fbData];
                 
                 [self requestLogin:@"F" withId:[fbData userId] withPw:nil withMail:[fbData email]];
                 
             }
             else
             {
                 NSLog(@"Error %@",error);
             }
         });
     }];
}


#pragma mark - Langtudy API

- (void) requestLogin:(NSString *)provider_type withId:(NSString *)strId withPw:(NSString *)pw withMail:(NSString *)mail{
    
    GALLangtudyEngine *engine = [GALLangtudyEngine sharedEngine];
    
    ApplicationDelegate.loginData.loginParam.provider_type = provider_type;
    
    if([@"G" isEqualToString:provider_type]){
        
        ApplicationDelegate.loginData.loginParam.provider_id = strId;
        ApplicationDelegate.loginData.loginParam.provider_email = mail;
        
    } else if([@"F" isEqualToString:provider_type]){
        
        ApplicationDelegate.loginData.loginParam.provider_id = strId;
        ApplicationDelegate.loginData.loginParam.provider_email = mail;
        
    } else {
    
        ApplicationDelegate.loginData.loginParam.login_id = strId;
        ApplicationDelegate.loginData.loginParam.login_passwd = pw;
    }
    
    [engine requestLogin:ApplicationDelegate.loginData.loginParam resultHandler:^(GALServerInfo *serverInfo, GALUserInfo *userInfo, NSMutableArray *payInfoList, NSString *email_auth) {
        
        if([@"G" isEqualToString:ApplicationDelegate.loginData.loginParam.provider_type]){
            
            [GALangtudyUtils saveValue:@"G" Key:SHARE_KEY_PROVIDER_TYPE];
            [GALangtudyUtils saveValue:ApplicationDelegate.loginNaviController.googleData.userId Key:SHARE_KEY_PROVIDER_ID];
            [GALangtudyUtils saveValue:ApplicationDelegate.loginData.loginParam.login_id Key:SHARE_KEY_PROVIDER_MAIL];
            
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
        
        [ApplicationDelegate changeRootViewControllerWithMain:YES];
        
    } errorHandler:^(NSDictionary *data, NSError *error) {
        NSString *errorCode = data[@"code"];
        
        NSString *email = data[@"email"];
        NSString *provider = data[@"provider"];
        
        NSLog(@"%@",errorCode);
        
        [self checkLoginError:errorCode withEmail:email withProvider:provider];
    }];
}

- (void) requestRegiUserByGoogle {
    
    GALGoogle *gg = [ApplicationDelegate.loginNaviController googleData];
    NSString *imgUrl = gg.imgUrl;
    
    if([GALangtudyUtils isNull:imgUrl]){
        
        [self requestRegiUser];
        
    }else{
        
        GALLangtudyEngine *engine = [GALLangtudyEngine sharedEngine];
        
        [engine getImageWithUrl:imgUrl completionHandler:^(UIImage *image, BOOL isInCache) {
            
            [engine uploadImage:image withUuid:[@"g" stringByAppendingString:gg.userId] type:@"pr" id:nil status:@"2" resultHandler:^(NSString *imageUrl) {
                
                ApplicationDelegate.loginNaviController.provideImgUrl = imageUrl;
                [self requestRegiUser];
                
            } errorHandler:^(NSDictionary *data, NSError *error) {
                [GALToastView showWithText:[self getStringWithKey:@"file_upload_failed"]];
            }];
            
        } errorHandler:^(NSDictionary *data, NSError *error) {
            [GALToastView showWithText:[self getStringWithKey:@"file_upload_failed"]];
        }];
    }
}

- (void) requestRegiUserByFacebook {
    
    GALFacebook *fb = [ApplicationDelegate.loginNaviController facebookData];
    NSString *imgUrl = fb.photo_url;
    
    if([GALangtudyUtils isNull:imgUrl]){
        [self requestRegiUser];
    }else{
        GALLangtudyEngine *engine = [GALLangtudyEngine sharedEngine];
        
        [engine getImageWithUrl:imgUrl completionHandler:^(UIImage *image, BOOL isInCache) {
            
            [engine uploadImage:image withUuid:[@"f" stringByAppendingString:fb.userId] type:@"pr" id:nil status:@"2" resultHandler:^(NSString *imageUrl) {
                
                ApplicationDelegate.loginNaviController.provideImgUrl = imageUrl;
                [self requestRegiUser];
                
            } errorHandler:^(NSDictionary *data, NSError *error) {
                
                [GALToastView showWithText:[self getStringWithKey:@"file_upload_failed"]];
                
            }];
            
        } errorHandler:^(NSDictionary *data, NSError *error) {
            
            [GALToastView showWithText:[self getStringWithKey:@"file_upload_failed"]];
        }];
    }

}

- (void) requestRegiUserByKakao {
    
//    GALFacebook *fb = [ApplicationDelegate.loginNaviController facebookData];
//    NSString *imgUrl = fb.photo_url;
//    
//    if([GALangtudyUtils isNull:imgUrl]){
//        [self requestRegiUser];
//    }else{
//        GALLangtudyEngine *engine = [GALLangtudyEngine sharedEngine];
//        
//        [engine getImageWithUrl:imgUrl completionHandler:^(UIImage *image, BOOL isInCache) {
//            
//            [engine uploadImage:image withUuid:[@"f" stringByAppendingString:fb.userId] type:@"pr" id:nil status:@"2" resultHandler:^(NSString *imageUrl) {
//                
//                ApplicationDelegate.loginNaviController.provideImgUrl = imageUrl;
//                [self requestRegiUser];
//                
//            } errorHandler:^(NSDictionary *data, NSError *error) {
//                
//                [GALToastView showWithText:[self getStringWithKey:@"file_upload_failed"]];
//                
//            }];
//            
//        } errorHandler:^(NSDictionary *data, NSError *error) {
//            
//            [GALToastView showWithText:[self getStringWithKey:@"file_upload_failed"]];
//        }];
//    }
    
}

- (void) requestRegiUser {
    
    GALRegiUserParam *param = [GALRegiUserParam new];
    
    param.provider_type = [ApplicationDelegate.loginNaviController provideType];
    param.user_name = [ApplicationDelegate.loginNaviController name];
    
    if([@"G" isEqualToString:param.provider_type]){
        GALGoogle *gg = [ApplicationDelegate.loginNaviController googleData];
        param.provider_id = gg.userId;
        param.provider_email = gg.email;
        param.provider_img = [ApplicationDelegate.loginNaviController provideImgUrl];
        param.user_name = gg.fullName;
        
    } else if([@"F" isEqualToString:param.provider_type]){
        GALFacebook *fb = [ApplicationDelegate.loginNaviController facebookData];
        param.provider_id = fb.userId;
        param.provider_email = fb.email;
        param.user_name=fb.name;
        param.provider_img = [ApplicationDelegate.loginNaviController provideImgUrl];
    } else{
        param.login_id = [ApplicationDelegate.loginNaviController email];
        param.login_passwd = [ApplicationDelegate.loginNaviController pass];
    }
    
    //    param.user_sys_lang = [[ApplicationDelegate loginData] user_sys_lang];
    //    param.user_gender = [[ApplicationDelegate loginNaviController] gender];
    
    param.longitude = [[ApplicationDelegate loginData] user_longitude];
    param.latitude = [[ApplicationDelegate loginData] user_latitude];
    
    //    param.continentCode = [[ApplicationDelegate loginData] continentCode];
    //    param.user_localtime_gmt = [[ApplicationDelegate loginData] user_localtime_gmt];
    //    param.country_id = [[ApplicationDelegate loginData] countryId];
    //    param.country_name = [[ApplicationDelegate loginData] countryName];
    //    param.state_id = [[ApplicationDelegate loginData] stateId];
    //    param.state_name = [[ApplicationDelegate loginData] stateName];
    //
    //    param.is_search_teach = [[ApplicationDelegate loginNaviController] isSearch];
    
    //    NSMutableArray *langList = [NSMutableArray array];
    //    [langList addObject:[[ApplicationDelegate loginNaviController] learnLang]];
    //    [langList addObject:[[ApplicationDelegate loginNaviController] teachLang]];
    //
    //    param.languages = langList;
    
    GALLangtudyEngine *engine = [GALLangtudyEngine sharedEngine];
    
    [engine requestRegiUser:param resultHandler:^(NSString *user_uuid) {
        
        NSString *provider_type = [ApplicationDelegate.loginNaviController provideType];
        
        [self requestLogin:param.provider_type withId:user_uuid withPw:param.login_passwd withMail:param.provider_email];
        
    } errorHandler:^(NSDictionary *data, NSError *error) {
        
        NSString *errorCode = data[@"code"];
        NSLog(@"%@",errorCode);
        
        NSString *email = data[@"data"][@"provider_email"];
        NSString *provider = data[@"data"][@"provider_type"];
        
        [self checkRegistError:errorCode withEmail:email withProvider:provider];
    }];
    
}


- (void) checkLoginError:(NSString *)errorCode withEmail:(NSString *) email withProvider:(NSString *)provider{
    if([LOGIN_ERROR_ID isEqualToString:errorCode]){
        
    }else if([LOGIN_ERROR_PW isEqualToString:errorCode]){
        
    }else if([LOGIN_ERROR_LANGTUDY isEqualToString:errorCode]){
        
        NSString *strId = [[self.idField text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        //랭터디 로그인 에러 .. 가입 유도
        GALSignPasswordController *mGALSignPasswordController = [[GALSignPasswordController alloc] initWithTotalCount:5];
        
        [ApplicationDelegate.loginNaviController setProvideType:@"L"];
        [ApplicationDelegate.loginNaviController setEmail:strId];
        
        [ApplicationDelegate.loginNaviController pushViewController:mGALSignPasswordController animated:YES];
        
    }else if([LOGIN_ERROR_TYPE isEqualToString:errorCode]){
        
    }else if([LOGIN_ERROR_UUID isEqualToString:errorCode]){
        
    }else if([LOGIN_ERROR_PROVIDER isEqualToString:errorCode]){
        
        NSString *provider_type = ApplicationDelegate.loginData.loginParam.provider_type;
        NSString *provider_email = ApplicationDelegate.loginData.loginParam.login_id;

        if ( [provider_type isEqualToString:@"G"] ) {
            [self requestRegiUserByGoogle];
        } else if ( [provider_type isEqualToString:@"F"] ) {
            [self requestRegiUserByFacebook];
        } else if ( [provider_type isEqualToString:@"K"] ) {
            [self requestRegiUserByKakao];
        } else {
            [self requestRegiUser];
        }
        
        
//        //구글 페북 상관없이 바로 배우는 언어선택으로 이동
//        GALNameController *vc = [[GALNameController alloc] init];
//        
//        [ApplicationDelegate.loginNaviController setEmail:provider_email];
//        
//        [ApplicationDelegate.loginNaviController pushViewController:vc animated:YES];
    
        
    }else if([LOGIN_ERROR_EMAIL isEqualToString:errorCode]){
        
    }else if([LOGIN_ERROR_CODE isEqualToString:errorCode]){
        
    }else if([LOGIN_ERROR_PW_FAIL isEqualToString:errorCode]){
        
    }else if([LOGIN_ERROR_ALREADY_EMAIL isEqualToString:errorCode]){
        
        if([@"G" isEqualToString:provider]){
            
            NSString *provider_email = ApplicationDelegate.loginData.loginParam.login_id;
            NSString *strTemp  = [NSString stringWithFormat:[self getStringWithKey:@"already_on_other_language"],provider_email,@"Google"];
            
            [GALToastView showWithText:strTemp];
            
        }else if([@"F" isEqualToString:provider]){
            NSString *provider_email = ApplicationDelegate.loginData.loginParam.login_id;
            NSString *strTemp  = [NSString stringWithFormat:[self getStringWithKey:@"already_on_other_language"],provider_email,@"Facebook"];
            
            [GALToastView showWithText:strTemp];
        }else{
            
            NSString *strId = [[self.idField text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            
            //GALLoginPasswordController *mGALLoginPasswordController = [[GALLoginPasswordController alloc] initWithNibName:@"GALLoginPasswordController" bundle:nil];
            GALLoginPasswordController *mGALLoginPasswordController = [[GALLoginPasswordController alloc] init];
            
            
            [ApplicationDelegate.loginNaviController setEmail:strId];
            
            [ApplicationDelegate.loginNaviController pushViewController:mGALLoginPasswordController animated:YES];
        }
        
        
    }else if([LOGIN_ERROR_ALREADY_REGI isEqualToString:errorCode]){
        
    }
}

- (void) checkRegistError:(NSString *)errorCode withEmail:(NSString *) email withProvider:(NSString *)provider{
  
    if([LOGIN_ERROR_ALREADY_EMAIL isEqualToString:errorCode]){
        
        if([@"G" isEqualToString:provider]){
            
            NSString *provider_email = email;
            NSString *strTemp  = [NSString stringWithFormat:[self getStringWithKey:@"already_on_other_language"],provider_email,@"Google"];
            dispatch_async(dispatch_get_main_queue(), ^{
                [GALToastView showWithText:strTemp];
            });
            
        }else if([@"F" isEqualToString:provider]){
            
            NSString *provider_email = email;
            NSString *strTemp  = [NSString stringWithFormat:[self getStringWithKey:@"already_on_other_language"],provider_email,@"Facebook"];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [GALToastView showWithText:strTemp];
            });
            
        }else{
            
            NSString *strId = [[self.idField text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            
            //GALLoginPasswordController *mGALLoginPasswordController = [[GALLoginPasswordController alloc] initWithNibName:@"GALLoginPasswordController" bundle:nil];
            GALLoginPasswordController *mGALLoginPasswordController = [[GALLoginPasswordController alloc] init];
            
            
            [ApplicationDelegate.loginNaviController setEmail:strId];
            
            [ApplicationDelegate.loginNaviController pushViewController:mGALLoginPasswordController animated:YES];
        }
        
        
    }else if([LOGIN_ERROR_ALREADY_REGI isEqualToString:errorCode]){
        
    }
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
