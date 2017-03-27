//
//  GALNameController.m
//  Langtudy
//
//  Created by SinSuMin on 2016. 8. 16..
//  Copyright © 2016년 galuster. All rights reserved.
//

#import "GALNameController.h"
#import "UITextField+GALPaddingText.h"
#import "LocationManager.h"

//#import "GALGenderController.h"

@interface GALNameController ()

//static views
@property (strong, nonatomic) IBOutlet UILabel *nameTitleLabel;
@property (strong, nonatomic) IBOutlet UIButton *nextButton;


@property NSInteger totalCnt;

@property (strong, nonatomic) IBOutlet UIView *progressView;

@property (strong, nonatomic) IBOutlet UIImageView *progressBg;

@property (strong, nonatomic) IBOutlet UITextField *nameField;

@end

@implementation GALNameController

- (id) initWithTotalCount:(NSInteger)total_cnt
{
    //self = [super initWithNibName:@"GALNameController" bundle:nil];
    self = [super init];
    if (self) {
        // Custom initialization
        self.totalCnt = total_cnt;
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
//    UIButton *button  = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
//    [button setImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
//    [button setImage:[UIImage imageNamed:@"btn_back_touch"] forState:UIControlStateHighlighted];
//    
//    [button addTarget:self action:@selector(goBackinLogin) forControlEvents:UIControlEventTouchUpInside];
//    
//    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
//    
//    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
//    
//    
//    [self setTitle:[self getStringWithKey:@"sing_up"]];
//    
//    [self.nameTitleLabel setText:[self getStringWithKey:@"please_enter_your_name"]];
//    
//    [self.nameField setPlaceholder:[self getStringWithKey:@"name"]];
//    
//    [self.nextButton setTitle:[self getStringWithKey:@"next"] forState:UIControlStateNormal];
//    
//    
//    
//    [[ApplicationDelegate loginNaviController] setProgressLayout:self.progressView withBg:self.progressBg withTotalCount:self.totalCnt withCount:4];
    
    //    [self setProgressLayout];
    
//    [self.nameField setLeftPadding:20.0f];
//    [self.nameField setRightPadding:20.0f];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
}

- (void) makeLayout {
    
    [self makeRoot:NO title:[self getStringWithKey:@"sing_up"] bgColor:UIColor_main];
    [self makeLeftBackButton];
    
    float x = 20;
    float y = 32;
    
//    self.nameTitleLabel = [[UILabel alloc] init:[Layout aspecRect:CGRectMake(x, y, LAYOUT_WIDTH - x * 2, 19)] parent:self.bodyView tag:0 text:[NSString stringWithFormat:[self getStringWithKey:@"please_enter_your_name"],ApplicationDelegate.loginNaviController.email] color:UIColorFromRGB(0x000000) bgColor:nil align:NSTextAlignmentLeft font:@"bold" size:[Layout aspecValue:17.0f]];
//    [self.nameTitleLabel sizeToFit];
//    y += [Layout revert:self.nameTitleLabel.frame.size.height] + 10;
    
    self.self.nameTitleLabel = [[UILabel alloc] init:[Layout aspecRect:CGRectMake(x, y, LAYOUT_WIDTH - x * 2, 16)] parent:self.bodyView tag:0 text:[self getStringWithKey:@"please_enter_your_name"] color:UIColorFromRGB(0x6C6C6C) bgColor:nil align:NSTextAlignmentLeft font:nil size:[Layout aspecValue:14.0f]];
    y += 16 + 10;
    
    self.nameField = [[[UITextField alloc]init:[Layout aspecRect:CGRectMake(x, y, LAYOUT_WIDTH - x * 2, 44)] parent:self.bodyView tag:0] defaultStyle:@"" placeholder:[self getStringWithKey:@"password"] delegate:nil];
    y += 44 + 6;
    
    
    self.nextButton = [[[[UIButton alloc] init:[Layout aspecRect:CGRectMake(0, y, LAYOUT_WIDTH, 60)] parent:self.bodyView tag:0 target:self action:@selector(onClickNext:)]
                        addTitle:[self getStringWithKey:@"start"]]
                       addBackgroundColor:UIColorFromRGB(0x669cf8) highlightedColor:nil disabledColor:nil] ;
    
    [self.nextButton setY:self.bodyView.frame.size.height - self.nextButton.frame.size.height];
    
    [self.bodyView addTarget:self action:@selector(dismissKeyboard)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)onClickNext:(id)sender {
    
    NSString *strName = [[self.nameField text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if([strName length] < 1){
        [GALToastView showWithText:[self getStringWithKey:@"please_enter_your_name"]];
        return;
    }
    
    if( [LocationManager sharedLocationManager].hasLocationInfo ){
        ApplicationDelegate.loginData.user_latitude = [NSString stringWithFormat:@"%f", [LocationManager sharedLocationManager].latitude];
        ApplicationDelegate.loginData.user_longitude = [NSString stringWithFormat:@"%f", [LocationManager sharedLocationManager].longitude];
    }
    
    [ApplicationDelegate.loginNaviController setName:strName];
    
    [self requestRegiUser];
    
//
//    GALGenderController *mGALGenderController = [[GALGenderController alloc] initWithTotalCount:self.totalCnt];
//    
//    [ApplicationDelegate.loginNaviController pushViewController:mGALGenderController animated:YES];
    
}


- (void) requestRegiUser{
    
    GALRegiUserParam *param = [GALRegiUserParam new];
    
    param.provider_type = [ApplicationDelegate.loginNaviController provideType];
    param.user_name = [ApplicationDelegate.loginNaviController name];
    
    if([@"G" isEqualToString:param.provider_type]){
        GALGoogle *gg = [ApplicationDelegate.loginNaviController googleData];
        param.provider_id = gg.userId;
        param.provider_email = gg.email;
        param.provider_img = [ApplicationDelegate.loginNaviController provideImgUrl];
        
    }else if([@"F" isEqualToString:param.provider_type]){
        GALFacebook *fb = [ApplicationDelegate.loginNaviController facebookData];
        param.provider_id = fb.userId;
        param.provider_email = @"";
        param.provider_img = [ApplicationDelegate.loginNaviController provideImgUrl];
    }else{
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
        
        [GALToastView showWithText:data[@"msg"]];
    }];
    
}

- (void) requestLogin:(NSString *)provider_type withId:(NSString *)strId withPw:(NSString *)pw withMail:(NSString *)mail{
    
    GALLangtudyEngine *engine = [GALLangtudyEngine sharedEngine];
    
    ApplicationDelegate.loginData.loginParam.provider_type = provider_type;
    
    if([@"W" isEqualToString:provider_type]){
        ApplicationDelegate.loginData.loginParam.user_uuid = strId;
        ApplicationDelegate.loginData.loginParam.login_id = ApplicationDelegate.loginNaviController.email;
    }else{
        ApplicationDelegate.loginData.loginParam.user_uuid = strId;
        
        if([@"G" isEqualToString:provider_type]){
            ApplicationDelegate.loginData.loginParam.provider_id = ApplicationDelegate.loginNaviController.googleData.userId;
        }else{
            ApplicationDelegate.loginData.loginParam.provider_id = ApplicationDelegate.loginNaviController.facebookData.userId;
        }
        ApplicationDelegate.loginData.loginParam.provider_email = mail;
    }
    ApplicationDelegate.loginData.loginParam.login_passwd = pw;
    
    
    [engine requestLogin:ApplicationDelegate.loginData.loginParam resultHandler:^(GALServerInfo *serverInfo, GALUserInfo *userInfo, NSMutableArray *payInfoList, NSString *email_auth) {
        
        if([@"G" isEqualToString:ApplicationDelegate.loginData.loginParam.provider_type]){
            
            [GALangtudyUtils saveValue:@"G" Key:SHARE_KEY_PROVIDER_TYPE];
            [GALangtudyUtils saveValue:ApplicationDelegate.loginNaviController.googleData.userId Key:SHARE_KEY_PROVIDER_ID];
            [GALangtudyUtils saveValue:ApplicationDelegate.loginData.loginParam.provider_email Key:SHARE_KEY_PROVIDER_MAIL];
            
        }else if([@"F" isEqualToString:ApplicationDelegate.loginData.loginParam.provider_type]){
            
            [GALangtudyUtils saveValue:@"F" Key:SHARE_KEY_PROVIDER_TYPE];
            [GALangtudyUtils saveValue:ApplicationDelegate.loginNaviController.facebookData.userId Key:SHARE_KEY_PROVIDER_ID];
            
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
//        
        [ApplicationDelegate changeRootViewControllerWithMain:YES];
        
    } errorHandler:^(NSDictionary *data, NSError *error) {
        NSString *errorCode = data[@"code"];
        
        NSLog(@"%@",errorCode);
        
        [GALToastView showWithText:data[@"msg"]];
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
                             
                             rect = self.nextButton.frame;
                             rect.origin.y = self.view.frame.size.height - rect.size.height - keyboardSize.height + (keyboardSize.height / 4);
                             self.nextButton.frame = rect;
                             
                         } else {
                             CGRect rect = self.nextButton.frame;
                             rect.origin.y = self.view.frame.size.height - rect.size.height - keyboardSize.height;
                             self.nextButton.frame = rect;
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
                         CGRect rect = self.nextButton.frame;
                         rect.origin.y = self.view.frame.size.height - rect.size.height;
                         self.nextButton.frame = rect;
                     }
                     completion:nil
     ];
    //}
}


- (void) dismissKeyboard{
    [self.nameField endEditing:YES];
}


@end
