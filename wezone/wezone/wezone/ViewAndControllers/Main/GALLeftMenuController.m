//
//  GALLeftMenuController.m
//  Langtudy
//
//  Created by SinSuMin on 2016. 8. 19..
//  Copyright © 2016년 galuster. All rights reserved.
//

#import "GALLeftMenuController.h"


//#import "GALReviewController.h"

//
//#import "GALMyProfileController.h"
//
//
//#import "GALPayController.h"
//
//#import "GALSettingController.h"
//
//#import "GALFavoriteController.h"
#import "GALWebViewController.h"
//
//#import "GALLanguageController.h"
//
//#import "GALAssessController.h"


@interface GALLeftMenuController ()

//static views
//@property (weak, nonatomic) IBOutlet UIButton *myprofileButton;
//@property (weak, nonatomic) IBOutlet UILabel *mylevelLabel;
//@property (weak, nonatomic) IBOutlet UILabel *myrateLabel;
//@property (weak, nonatomic) IBOutlet UILabel *favoriteLabel;
//@property (weak, nonatomic) IBOutlet UILabel *inviteLabel;
//@property (weak, nonatomic) IBOutlet UILabel *settingLabel;
//@property (weak, nonatomic) IBOutlet UILabel *faqLabel;
//@property (weak, nonatomic) IBOutlet UILabel *applinkLabel;
//@property (weak, nonatomic) IBOutlet UILabel *logoutLabel;
////
//
//
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;
//@property (weak, nonatomic) IBOutlet UIView *contentsView;
//
//@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
//@property (weak, nonatomic) IBOutlet UIImageView *flagImageView;
//@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
//@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
//@property (weak, nonatomic) IBOutlet UILabel *costLabel;
//
//
//@property (weak, nonatomic) IBOutlet UIView *myLevelWithTitle;
//@property (weak, nonatomic) IBOutlet UIView *myLevelArea;
//
//@property (weak, nonatomic) IBOutlet UIView *myScoreWithTitle;
//@property (weak, nonatomic) IBOutlet UIView *myScoreArea;
//
//
//@property (weak, nonatomic) IBOutlet UIView *buttonArea;
//
//@property (weak, nonatomic) IBOutlet UILabel *eventLabel;
//@property (weak, nonatomic) IBOutlet UIImageView *blogImageView;

@end

@implementation GALLeftMenuController
{
    CGFloat mLearnPosY;
    CGFloat mTeachPosY;
    CGFloat mHeight;
    CGFloat mWidth;
    CGFloat mDiffHeight;
    
    NSMutableArray *langItemList;
    
    UIView *_contentsView;
    UIImageView *_profileImg;
    UILabel *_nameLabel;
    UILabel *_emailLabel;
    UILabel *_friendsCountLabel;
    
    UIImageView *_eventImg;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //static strings
    
//    [self.myprofileButton setTitle:LSSTRING(@"setting_my_profile") forState:UIControlStateNormal];
//    [self.mylevelLabel setText:LSSTRING(@"my_level")];
//    [self.myrateLabel setText:LSSTRING(@"my_rating")];
//    [self.favoriteLabel setText:LSSTRING(@"favorites")];
//    [self.inviteLabel setText:LSSTRING(@"invite_friends")];
//    [self.settingLabel setText:LSSTRING(@"setting")];
//    [self.faqLabel setText:LSSTRING(@"faq")];
//    [self.applinkLabel setText:LSSTRING(@"app_review")];
//    [self.logoutLabel setText:LSSTRING(@"logout")];
//
//    [self.eventLabel setText:LSSTRING(@"new_event")];
    
    [self makeLayout];
}

- (void) makeLayout {
    
    GALUserInfo *userInfo = ApplicationDelegate.loginData.user_info;
    
    
    CGRect rect = self.scrollview.frame;
    
    self.view.backgroundColor = [ThemeUtil naviColor];
    
    UIView *view = [[UIView alloc] init:CGRectMake(0, 0, rect.size.width, rect.size.height) parent:self.scrollview tag:0 color:UIColorFromRGB(0xffffff)];
    _contentsView = view;
    
    float x = 20;
    float y = 20;
    float w = [Layout revert:view.frame.size.width];
    
    _profileImg = [[UIImageView alloc] init:[Layout aspecRect:CGRectMake(x, y, 67, 67)] parent:view tag:0 imageName:@"im_bunny_photo"];
    [_profileImg setBackgroundColor:UIColorFromRGB(0xeeeeee)];
    [_profileImg addTarget:self action:@selector(onClickMyProfile)];
    
    _profileImg.layer.cornerRadius = _profileImg.frame.size.width / 2;
    _profileImg.clipsToBounds = YES;
    if ( userInfo.img_url ) {
        
        [[GALLangtudyEngine sharedEngine] getImageWithUrl:userInfo.img_url completionHandler:^(UIImage *image, BOOL isInCache) {
            if ( image ) {
                _profileImg.image = image;
            }
        } errorHandler:^(NSDictionary *data, NSError *error) {
            
        }];
    }
    
    y += 67 + 10;
    
    _nameLabel = [[UILabel alloc] init:[Layout aspecRect:CGRectMake(x, y, w - x * 2, SIZE_TEXT_S + 2)] parent:view tag:0 text:userInfo.user_name color:UIColor_text bgColor:nil align:NSTextAlignmentLeft font:nil size:SIZE_TEXT_S];
    y += SIZE_TEXT_S + 10;
    
    _emailLabel = [[UILabel alloc] init:[Layout aspecRect:CGRectMake(x, y, w - x * 2, SIZE_TEXT_S + 2)] parent:view tag:0 text:ApplicationDelegate.loginData.loginParam.login_id color:UIColor_text bgColor:nil align:NSTextAlignmentLeft font:nil size:SIZE_TEXT_S];
    y += SIZE_TEXT_S + 20;
    
    [UIView makeHorizontalLine:CGRectMake(0, [Layout aspecValue:y], rect.size.width, 1) parent:view tag:0 color:UIColor_line];
    y += 21;
    
    float line = 40;
    
    y += [self makeMenuLine:STR(@"main_menu_market") icon:@"ic_menu_beacon_market" parent:view x:x y:y w:w - x * 2 h:line selector:@selector(onClickMarket)];
    
    UIView *view1 = [[UIView alloc] init:[Layout aspecRect:CGRectMake(x, y, w - x * 2, line)] parent:view tag:0 color:nil];
    [view1 addTarget:self action:@selector(onClickFriend)];
    [[UIImageView alloc] init:[Layout aspecRect:CGRectMake(0, (line - 25) / 2, 25, 25)] parent:view1 tag:0 imageName:@"ic_menu_people"];
    UILabel *label = [[UILabel alloc] init:[Layout aspecRect:CGRectMake(30, (line - 25) / 2, w - 30, 25)] parent:view1 tag:0 text:STR(@"main_menu_friend") color:UIColor_text bgColor:nil align:NSTextAlignmentLeft font:nil size:SIZE_TEXT_S];
    [label sizeToFitWidth];
    
    NSString *count = [NSString stringWithFormat:@"%d", 0];
    _friendsCountLabel = [[UILabel alloc] init:[Layout aspecRect:CGRectMake(30, (line - 25) / 2, w - 30, 25)] parent:view1 tag:0 text:count color:UIColor_sub_text bgColor:nil align:NSTextAlignmentLeft font:nil size:SIZE_TEXT_S];
    [_friendsCountLabel posRight:label margin:5];
    y += 40;
    
    y += [self makeMenuLine:STR(@"main_menu_setting") icon:@"ic_menu_set" parent:view x:x y:y w:w - x * 2 h:line selector:@selector(onClickSetting)];
    y += [self makeMenuLine:STR(@"main_menu_callcenter") icon:@"ic_menu_help" parent:view x:x y:y w:w - x * 2 h:line selector:@selector(onClickFAQ)];
    y += [self makeMenuLine:STR(@"main_menu_logout") icon:@"ic_menu_exit_to_app" parent:view x:x y:y w:w - x * 2 h:line selector:@selector(onClickLogout)];
    
    y += 20;
    UIView *view2 = [[UIView alloc] init:[Layout aspecRect:CGRectMake(x, y, w - x * 2, 158)] parent:view tag:0 color:nil];
    [view1 addTarget:self action:@selector(onClickEvent)];
    [[UILabel alloc] init:[Layout aspecRect:CGRectMake(0, 0, w - x * 2, SIZE_TEXT_S + 2)] parent:view2 tag:0 text:STR(@"main_menu_event") color:UIColor_text bgColor:nil align:NSTextAlignmentLeft font:nil size:SIZE_TEXT_S];
    
    _eventImg = [[UIImageView alloc] init:[Layout aspecRect:CGRectMake(0, SIZE_TEXT_S + 10, w - x * 2, line)] parent:view2 tag:0 imageName:@"im_event"];
    
    if ( view2.frame.origin.y + view2.frame.size.height >= view.frame.size.height ) {
        
    }
//    NSString *imgUrl = [userInfo user_img_url];
//    
//    if(imgUrl != nil){
//        
//        NSString *fullUrl = [NSString stringWithFormat:@"%@%@",SERVICE_FILE_URL,imgUrl];
//        [self.profileImageView setImageAndCacheWithURLString:fullUrl placeholderImage:[UIImage imageNamed:@"nopicture"]];
//    }
//    
//    NSString *nationality = [userInfo user_country];
//    if(nationality != nil){
//        [self.flagImageView setHidden:NO];
//        [self.flagImageView setImage:[UIImage imageNamed:nationality]];
//    }else{
//        [self.flagImageView setHidden:YES];
//    }
//    
//    [self.nameLabel setText:[userInfo user_name]];
//    
//    NSString *loaction;
//    if([GALangtudyUtils isNull:[userInfo countryname]] && [GALangtudyUtils isNull:[userInfo statename]]){
//        loaction = @"위치 정보 없음";
//    }else{
//        loaction = [NSString stringWithFormat:@"%@, %@",[userInfo countryname],[userInfo statename]];
//    }
//    
//    [self.locationLabel setText:loaction];
//    
//    
//    NSString *langcoinCnt = [userInfo langcoin_count];
//    if(langcoinCnt == nil){
//        [self.costLabel setText:@"0"];
//    }else{
//        [self.costLabel setText:langcoinCnt];
//    }
//    
//    if(userInfo.languages != nil){
//        
//        langItemList = [NSMutableArray array];
//        
//        mLearnPosY = 10.0f;
//        mTeachPosY = 10.0f;
//        mHeight = 40.0f;
//        mWidth = 280.0f;
//        mDiffHeight = 0.0f;
//        
//        for(NSInteger i=0; i<userInfo.languages.count; i++){
//            
//            NSObject *data = [userInfo.languages objectAtIndex:i];
//            
//            GALLangData *langData;
//            if([data isKindOfClass:[GALLangData class]]){
//                langData = (GALLangData *)data;
//            }else{
//                langData = [GALLangData new];
//                [langData injectFromObject:data arrayClass:[GALLangData class]];
//            }
//            
//            GALLeftMenuLangItem *item = [[GALLeftMenuLangItem alloc] initWithLangData:langData];
//            
//            if([@"L" isEqualToString:[langData lang_mode]]){
//                CGRect frame = CGRectMake(0.0f, mLearnPosY, mWidth, mHeight);
//                [item setFrame:frame];
//                [self.myLevelArea addSubview:item];
//                
//                UIButton *itemButton = [UIButton buttonWithType:UIButtonTypeCustom];
//                [itemButton setFrame:frame];
//                [itemButton addTarget:self action:@selector(onItemClick:) forControlEvents:UIControlEventTouchUpInside];
//                [itemButton setTag:i];
//                [self.myLevelArea addSubview:itemButton];
//                
//                mLearnPosY += mHeight;
//                
//                mDiffHeight += mHeight;
//                
//            }else{
//                CGRect frame = CGRectMake(0.0f, mTeachPosY, mWidth, mHeight);
//                [item setFrame:frame];
//                
//                [self.myScoreArea addSubview:item];
//                
//                UIButton *itemButton = [UIButton buttonWithType:UIButtonTypeCustom];
//                [itemButton setFrame:frame];
//                [itemButton addTarget:self action:@selector(onItemClick:) forControlEvents:UIControlEventTouchUpInside];
//                [itemButton setTag:i];
//                
//                [self.myScoreArea addSubview:itemButton];
//                
//                mTeachPosY += mHeight;
//                mDiffHeight += mHeight;
//            }
//
//            if([self.mainLang.lang_mode isEqualToString:langData.lang_mode]){
//                if([self.mainLang.lang_code isEqualToString:langData.lang_code]){
//                    [item selectedLayout];
//                }
//            }
//
//            [langItemList addObject:item];
//            
//        }
//        
//    }
//    
//    if([@"kor" isEqualToString:ApplicationDelegate.loginData.user_sys_lang]){
//        [self.blogImageView setImage:[UIImage imageNamed:@"btn_menu_naver.png"]];
//    }else{
//        [self.blogImageView setImage:[UIImage imageNamed:@"btn_menu_blog.png"]];
//    }
//    
//    
//    CGRect levelFrame = self.myLevelArea.frame;
//    levelFrame.size.height = mLearnPosY + 10.0f;
//    [self.myLevelArea setFrame:levelFrame];
//    
//    
//    CGRect levelWithTitleFrame = self.myLevelWithTitle.frame;
//    levelWithTitleFrame.size.height = levelFrame.size.height + 40.0f;
//    [self.myLevelWithTitle setFrame:levelWithTitleFrame];
//    
//    
//    CGRect scoreFrame = self.myScoreArea.frame;
//    scoreFrame.size.height = mTeachPosY + 10.0f;
//    [self.myScoreArea setFrame:scoreFrame];
//    
//    CGRect scoreWithTitleFrame = self.myScoreWithTitle.frame;
//    scoreWithTitleFrame.origin.y = levelWithTitleFrame.size.height;
//    scoreWithTitleFrame.size.height = scoreFrame.size.height + 40.0f;
//    [self.myScoreWithTitle setFrame:scoreWithTitleFrame];
//    
//    CGFloat headerHeight = 160.0f;
//    
//    CGRect buttonFrame = self.buttonArea.frame;
//    buttonFrame.origin.y = headerHeight + levelWithTitleFrame.size.height + scoreWithTitleFrame.size.height;
//    [self.buttonArea setFrame:buttonFrame];
//    
//    
//    CGRect contentsFrame = self.contentsView.frame;
//    contentsFrame.size.height = buttonFrame.origin.y + self.buttonArea.frame.size.height;
//    [self.contentsView setFrame:contentsFrame];
//    
//    
//    //    [self.contentsView setExclusiveTouch:YES];
//    
//    self.scrollview.translatesAutoresizingMaskIntoConstraints = NO;
//    self.contentsView.translatesAutoresizingMaskIntoConstraints = NO;
//    
//    self.scrollview.canCancelContentTouches = YES;
//    self.scrollview.delaysContentTouches = YES;
//    
//    self.scrollview.contentSize = self.contentsView.frame.size;
//    
//    [self.view layoutSubviews];
    
}


- (float) makeMenuLine:(NSString *)title icon:(NSString *)icon parent:(UIView *)parent x:(float)x y:(float)y w:(float)w h:(float)h selector:(SEL)selector {

    UIView *view = [[UIView alloc] init:[Layout aspecRect:CGRectMake(x, y, w, h)] parent:parent tag:0 color:nil];
    
    [view addTarget:self action:selector];
    
    [[UIImageView alloc] init:[Layout aspecRect:CGRectMake(0, (h - 25) / 2, 25, 25)] parent:view tag:0 imageName:icon];
    
    [[UILabel alloc] init:[Layout aspecRect:CGRectMake(30, (h - 25) / 2, w - 30, 25)] parent:view tag:0 text:title color:UIColor_text bgColor:nil align:NSTextAlignmentLeft font:nil size:SIZE_TEXT_S];
    
    return h;
}

- (void) setLayout {

    GALUserInfo *userInfo = ApplicationDelegate.loginData.user_info;
    
    if ( userInfo.img_url ) {
        
        [[GALLangtudyEngine sharedEngine] getImageWithUrl:userInfo.img_url completionHandler:^(UIImage *image, BOOL isInCache) {
            if ( image ) {
                _profileImg.image = image;
            }
        } errorHandler:^(NSDictionary *data, NSError *error) {
            
        }];
    }

    _nameLabel.text = userInfo.user_name;
    _emailLabel.text = ApplicationDelegate.loginData.loginParam.login_id;
    
    _friendsCountLabel.text = [NSString stringWithFormat:@"%d", 0];
    
    _eventImg.image = [UIImage imageNamed:@"im_event"];
    float rate = _eventImg.image.size.height / _eventImg.image.size.width;
    [_eventImg setHeight:_eventImg.frame.size.width * rate];
    
    UIView *eventView = _eventImg.superview;
    
    [eventView sizeToFitHeight:_eventImg padding:0];
    [_contentsView setHeight:_scrollview.frame.size.height];
    
    if ( _contentsView.frame.size.height > eventView.frame.origin.y + eventView.frame.size.height ) {
        [eventView alignBottom:_contentsView margin:0];
    } else {
        [_contentsView sizeToFitHeight:eventView padding:0];
        _scrollview.contentSize = _contentsView.frame.size;
    }
    
}

- (void) onClickMyProfile {
    
    [self.delegate onClickButton:GALLeftMenuMyProfile];
}

- (void) onClickMarket {
    
    [self.delegate onClickButton:GALLeftMenuMarket];
}

- (void) onClickFriend {
    
    [self.delegate onClickButton:GALLeftMenuFriend];
}

- (void) onClickSetting {
    
    [self.delegate onClickButton:GALLeftMenuSetting];
}

- (void) onClickFAQ {
    
    [self.delegate onClickButton:GALLeftMenuFAQ];
}

- (void) onClickLogout {
    
    [self.delegate onClickButton:GALLeftMenuLogout];
    [ApplicationDelegate logout];
    
}

- (void) onClickEvent {
    
    [self.delegate onClickButton:GALLeftMenuBanner];
}


//- (void) resetLangData{
//    
////    for (GALLeftMenuLangItem *item in langItemList){
////        [item unSelectedLayout];
////    }
//}

//- (void) onItemClick:(id)sender{
//    UIButton *button = (UIButton *)sender;
//    NSInteger idx = [button tag];
//    
//    [self resetLangData];
//    
////    GALLeftMenuLangItem *item = [langItemList objectAtIndex:idx];
////    [item selectedLayout];
////    
////    [self setMainLang:item.langData];
////    
////    [self.delegate onClickLanguage:item.langData];
//}



- (void) viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//
//- (IBAction)onClickMyProfile:(id)sender {
//    
//    [self.delegate onClickButton:GALLeftMenuMyProfile];
//    
////    GALIntroductionController *mGALIntroductionController = [[GALIntroductionController alloc] initWithNibName:@"GALIntroductionController" bundle:nil];
////    [mGALIntroductionController setDelegate:self];
//
////    [ApplicationDelegate.mainNaviController presentPopupViewController:mGALIntroductionController animationType:MJPopupViewAnimationFade];
//
//    
////    GALMyProfileController *mGALMyProfileController = [[GALMyProfileController alloc] initWithNibName:@"GALMyProfileController" bundle:nil];
////
////    [ApplicationDelegate.mainNaviController pushViewController:mGALMyProfileController animated:YES];
//}
//
//- (void) onClickConfirmWithIntroduction:(NSString *)introduction{
//    
//}
//
//- (void) onClickCancel{
//    
//}
//
//- (IBAction)onClickPay:(id)sender {
//    
//    [self.delegate onClickButton:GALLeftMenuMyProfile];
//    
////    GALPayController *mGALPayController= [[GALPayController alloc] initWithNibName:@"GALPayController" bundle:nil];
////    [ApplicationDelegate.mainNaviController pushViewController:mGALPayController animated:YES];
//}
//
//
//- (IBAction)onClickFavorite:(id)sender {
//    
//    [self.delegate onClickButton:GALLeftMenuFavorite];
//    
////    GALFavoriteController *fc = [[GALFavoriteController alloc] init];
////    
////    [ApplicationDelegate.mainNaviController pushViewController:fc animated:YES];
//}
//
//- (IBAction)onClickInviteFriend:(id)sender {
//    [self.delegate onClickButton:GALLeftMenuInvite];
//    
//    NSArray * activityItems = @[[NSString stringWithFormat:LSSTRING(@"invitation_msg"),ApplicationDelegate.loginData.user_info.user_name]];
//    NSArray * applicationActivities = nil;
//    NSArray * excludeActivities = @[UIActivityTypeAssignToContact,
//                                    UIActivityTypeCopyToPasteboard,
//                                    UIActivityTypePostToWeibo,
//                                    UIActivityTypePostToFacebook,
//                                    UIActivityTypeMessage];
//    
//    UIActivityViewController * activityController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:applicationActivities];
//    activityController.excludedActivityTypes = excludeActivities;
//    
//    [self presentViewController:activityController animated:YES completion:nil];
//    
//}
//
//- (IBAction)onClickSetting:(id)sender {
//    [self.delegate onClickButton:GALLeftMenuSetting];
//    
////    GALSettingController *mGALSettingController = [[GALSettingController alloc] initWithNibName:@"GALSettingController" bundle:nil];
////    [ApplicationDelegate.mainNaviController pushViewController:mGALSettingController animated:YES];
//}
//
//
//- (IBAction)onClickFAQ:(id)sender {
//    
//    [self.delegate onClickButton:GALLeftMenuFAQ];
//    
//    NSString *location = ApplicationDelegate.loginData.user_sys_lang;
//    
////    NSString *url = [NSString stringWithFormat:NETURL_FAQ,location];
////    GALWebViewController *wvController = [[GALWebViewController alloc] initWithType:WebViewTypeFAQ withURL:url withTitle:LSSTRING(@"faq")];
////    
////    [ApplicationDelegate.mainNaviController pushViewController:wvController animated:YES];
//    
//}
//
//- (IBAction)onClickStore:(id)sender {
//    [self.delegate onClickButton:GALLeftMenuStore];
//    
//    NSString *iTunesLink = @"itms-apps://itunes.com/apps/Langtudy";
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];
//    
//}
//
//
//- (IBAction)onClickLogout:(id)sender {
//    [self.delegate onClickButton:GALLeftMenuLogout];
//    
//    [ApplicationDelegate resetLoginData];
//    [ApplicationDelegate changeRootViewControllerWithMain:NO];
//}
//
//- (IBAction)onClickBanner:(id)sender {
//    
//    [self.delegate onClickButton:GALLeftMenuBanner];
//}
//
//
//- (IBAction)onClickFacebook:(id)sender {
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:(NETURL_FACEBOOK)]];
//}
//
//- (IBAction)onClickInstar:(id)sender {
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:(NETURL_INSTART)]];
//}
//
//
//- (IBAction)onClickBlog:(id)sender {
//    
//    if([@"kor" isEqualToString:ApplicationDelegate.loginData.user_sys_lang]){
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:(NETURL_NAVER)]];
//    }else{
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:(NETURL_BLOG_SPOT)]];
//    }
//}

- (BOOL)touchesShouldCancelInContentView:(UIView *)view
{
    return ![view isKindOfClass:[UIButton class]];
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
