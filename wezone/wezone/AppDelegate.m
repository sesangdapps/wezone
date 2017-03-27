
//
//  AppDelegate.m
//  Langtudy
//
//  Created by SinSuMin on 2015. 8. 20..
//  Copyright (c) 2015년 galuster. All rights reserved.
//

#import "AppDelegate.h"
#import "GALSplashController.h"

//#import "GALMainController.h"
#import "GALLoginViewController.h"

//#import "GALCallParam.h"
//#import "ARTCVideoChatViewController.h"
//
//
//#import "GALChattingController.h"
//#import "GALScheduleController.h"
//#import "GALReviewController.h"
//#import "GALPayController.h"
//
//#import "GALAssessController.h"
//
//#import "JTSImageInfo.h"
//#import "JTSImageViewController.h"

#import "MainViewController.h"

@interface AppDelegate ()//<ARTCVideoChatViewControllerDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    NSLog(@"%f, %f, %f, %f", rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
    
    // Override point for customization after application launch.
    
    self.window.backgroundColor = [UIColor whiteColor];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    //[[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    //id setting
    [[GIDSignIn sharedInstance] setClientID:kClientID];
    
    //viewcontroller 생성
    
    [self initLoginParam];
    
    GALSplashController *viewController = [[GALSplashController alloc]initWithNibName:@"GALSplashController" bundle:nil];
    
    self.window.rootViewController = viewController;
    
    [self.window makeKeyAndVisible];
    
    
    // 푸쉬 설정
    NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    if(userInfo == nil){
        if (IS_IOS8_OR_LATER) {
            [[UIApplication sharedApplication] registerUserNotificationSettings:
             [UIUserNotificationSettings settingsForTypes:(UIRemoteNotificationTypeAlert|
                                                           UIRemoteNotificationTypeBadge|
                                                           UIRemoteNotificationTypeSound)
                                               categories:nil]];
            [[UIApplication sharedApplication] registerForRemoteNotifications];
        }
        else {
            [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
             UIRemoteNotificationTypeAlert |
             UIRemoteNotificationTypeBadge |
             UIRemoteNotificationTypeSound];
        }
    }
    
    return YES;
}

- (void) changeRootViewControllerWithMain:(BOOL)isMain{
    
    
    UIView *snapShot = [self.window snapshotViewAfterScreenUpdates:YES];
    
    if(isMain){
  
        MainViewController *mGALMainController = [[MainViewController alloc] init];

        self.mainNaviController = [[GALNaviController alloc] initWithRootViewController:mGALMainController];
        
        [self.mainNaviController.view addSubview:snapShot];
        
        self.window.rootViewController = self.mainNaviController;
        
    }else{
        
        NSString *nibName;
        if(IS_3_5_INCH){
            nibName = @"GALLoginViewController_4s";
        }else{
            nibName = @"GALLoginViewController";
        }
        //GALLoginViewController *mGALLoginViewController = [[GALLoginViewController alloc] initWithNibName:nibName bundle:nil];
        GALLoginViewController *mGALLoginViewController = [[GALLoginViewController alloc] init];
        
        self.loginNaviController = [[GALLoginNaviController alloc] initWithRootViewController:mGALLoginViewController];
        
        [self.loginNaviController.view addSubview:snapShot];
        
        self.window.rootViewController = self.loginNaviController;
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        snapShot.layer.opacity = 0;
        snapShot.layer.transform = CATransform3DMakeScale(1.5, 1.5, 1.5);
    } completion:^(BOOL finished) {
        [snapShot removeFromSuperview];
    }];
    
}


- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    
    BOOL isFb = [[FBSDKApplicationDelegate sharedInstance] application:application
                                                               openURL:url
                                                     sourceApplication:sourceApplication
                                                            annotation:annotation];
    
    BOOL isGg = [[GIDSignIn sharedInstance] handleURL:url
                                    sourceApplication:sourceApplication
                                           annotation:annotation];
    
    return isFb || isGg;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[NSNotificationCenter defaultCenter] postNotificationName: @"applicationDidEnterBackground" object: nil userInfo:nil];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [[NSNotificationCenter defaultCenter] postNotificationName: @"applicationWillEnterForeground" object: nil userInfo:nil];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    [FBSDKAppEvents activateApp];
    
    [[NSNotificationCenter defaultCenter] postNotificationName: @"applicationDidBecomeActive" object: nil userInfo:nil];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    [[NSNotificationCenter defaultCenter] postNotificationName: @"applicationWillTerminate" object: nil userInfo:nil];
}

#pragma mark -
#pragma mark 로그인

- (void) initLoginParam{
    self.loginData = [GALLogin new];
    
    GALLoginParam *loginParam = [GALLoginParam new];
    
#if TARGET_IPHONE_SIMULATOR
    loginParam.push_token = @"";
#else
    loginParam.push_token = [GALangtudyUtils getValue:PUSH_TOKEN];
#endif
    
    UIDevice *device = [UIDevice currentDevice];
    NSUUID *uuid = device.identifierForVendor;
    
    loginParam.device_id = uuid.UUIDString;
    loginParam.device_model = device.model;
    loginParam.device_os_ver = device.systemVersion;
    loginParam.device_os_type = @"IOS";
    loginParam.device_app_ver = BundleVersion;
    
//    self.loginData.user_sys_lang = [[NSLocale currentLocale] ISO639_2LanguageCode];
    self.loginData.loginParam = loginParam;
}

- (BOOL)isLogin {
    
    if(self.loginData == nil)
        return NO;
    
    if (self.loginData.user_info == nil)
        return NO;
    else
        return YES;
}


- (void) resetLoginData{
    
    //[[SDXmppManager sharedInstance] down];
    
    [GALangtudyUtils saveValue:nil Key:SHARE_KEY_PROVIDER_TYPE];
    [GALangtudyUtils saveValue:nil Key:SHARE_KEY_PROVIDER_ID];
    [GALangtudyUtils saveValue:nil Key:SHARE_KEY_PROVIDER_MAIL];
    [GALangtudyUtils saveValue:nil Key:SHARE_KEY_LANGTUDY_ID];
    [GALangtudyUtils saveValue:nil Key:SHARE_KEY_LANGTUDY_PW];
    
    self.loginData = nil;
    
    [self initLoginParam];
}

- (void) login {
    
    
    
}

- (void) logout {
    
    [[GALLangtudyEngine sharedEngine] requestLogout:^() {
        
        [self resetLoginData];
        [self changeRootViewControllerWithMain:NO];
        
    } errorHandler:^(NSDictionary *data, NSError *error) {
        
        [self resetLoginData];
        [self changeRootViewControllerWithMain:NO];
        
    }].isDisableActivityIndicator = YES;
}

#pragma mark badge

- (NSInteger)badgeNumber {
    return [UIApplication sharedApplication].applicationIconBadgeNumber; // set to 0 to hide. default is 0
}

- (void)setBadgeNumber:(NSInteger)number {
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:number];
}


#pragma mark - APNS

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    NSMutableString *deviceId = [NSMutableString string];
    const unsigned char* ptr = (const unsigned char*) [deviceToken bytes];
    
    for(int i = 0 ; i < 32 ; i++) {
        [deviceId appendFormat:@"%02x", ptr[i]];
    }
    
    NSLog(@"APNS Device Token: %@", deviceId);
    
    [GALangtudyUtils saveValue:deviceId Key:PUSH_TOKEN];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    NSLog(@"userInfo : %@", [userInfo class]);
    NSLog(@"userInfo : %@", userInfo);
//    [self pushDataSetDic:userInfo];
//    
//    // 내부통지
//    //    [[NSNotificationCenter defaultCenter] postNotificationName:kOnReceiveApnsMessegeNotificationName object:nil userInfo:@{kOnReceiveApnsMessegeDictionaryKey:self.pushData}];
//    
//    UIApplicationState state = [application applicationState];
//    
//    
//    //포그라운드면 푸시 무시
//    if ( state == UIApplicationStateActive ) {
//        
//        
//        if([GALangtudyUtils isLogin]){
//            
//            
//            if([MESSAGE_TYPE_CALL isEqualToString:self.pushData.send_type]){
//                
//            }else{
//                GALToastView *msgToast = [GALToastView toastView];
//                [msgToast showWithImageUrl:self.pushData.sender_url Title:self.pushData.sender_name Text:self.pushData.message target:self selector:@selector(moveWithPushData)];
//            }
//            
//        }else{
//            if([MESSAGE_TYPE_CALL isEqualToString:self.pushData.send_type]){
//                
//            }else{
//                GALToastView *msgToast = [GALToastView toastView];
//                [msgToast showWithImageUrl:self.pushData.sender_url Title:self.pushData.sender_name Text:self.pushData.message target:self selector:nil];
//            }
//        }
//        
//    }
//    else {
//        // 백그라운드, 잠금상태에서 노티 클릭으로 들어온 경우
//        //        NSInteger count = [self badgeNumber];
//        //        [self setBadgeNumber:0];
//        //        [self setBadgeNumber:count];
//        
//        if([GALangtudyUtils isLogin]){
//            
//            if([MESSAGE_TYPE_CALL isEqualToString:self.pushData.send_type]){
//                
//                NSString *timeStr = [GALDateUtils getCurrentTime:@"yyyyMMddHHmm"];
//                NSString *localSendTime = [GALDateUtils getCalTimeWithGMT:@"yyyyMMddHHmm" withStrDate:self.pushData.send_time];
//                NSInteger diff = [GALDateUtils diffOfMinWithType:@"yyyyMMddHHmm" Begin:timeStr End:localSendTime];
//                
//                //2분잡자..
//                if(diff >= -2 && diff <= 2){
//                    
//                    
//                    GALCallParam *param = [GALCallParam new];
//                    [param setOtherUserUuid:self.pushData.sender_id];
//                    [param setUserName:self.pushData.sender_name];
//                    [param setUserImgUrl:self.pushData.sender_url];
//                    [param setFromMode:@"L"];
//                    [param setLangCode:self.pushData.lang_code];
//                    [param setUsedCost:self.pushData.used_cost];
//                    [param setLangCoinSesstionId:self.pushData.langcoin_id];
//                    [param setScheduleId:self.pushData.schedule_id];
//                    [param setScheduleDate:self.pushData.schedule_date];
//                    [param setScheduleItemCnt:self.pushData.schedule_item_cnt];
//                    
//                    ARTCVideoChatViewController *mARTCVideoChatViewController = [[ARTCVideoChatViewController alloc] initWithCallMode:CALL_MODE_RESPONSE CallParam:param];
//                    [mARTCVideoChatViewController setDelegate:self];
//                    [ApplicationDelegate.mainNaviController presentViewController:mARTCVideoChatViewController animated:YES completion:^{
//                        
//                    }];
//                    
//                }else{
//                    [GALToastView showWithText:@"상대방의 전화가 끊어졌습니다"];
//                }
//                
//                [self setPushData:nil];
//            }else{
//                [self moveWithPushData];
//            }
//            
//        }
//    }
}
//
//- (void) goToAssessController:(GALCallParam *) callParam{
//    GALAssessController *mGALAssessController = [[GALAssessController alloc] initWithCallParam:callParam];
//    [ApplicationDelegate.mainNaviController pushViewController:mGALAssessController animated:YES];
//}
//
//- (void)pushDataSetDic:(NSDictionary *)userInfo {
//    NSDictionary *dict = [userInfo objectForKey:@"aps"];
//    NSString *message = [dict objectForKey:@"alert"];
//    [self setBadgeNumber:[[dict objectForKey:@"badge"] intValue]];
//    
//    NSDictionary *keyvalue = [dict objectForKey:@"value"];
//    
//    NSString *item_id = [keyvalue objectForKey:@"item_id"];
//    NSString *receiver_id = [keyvalue objectForKey:@"receiver_id"];
//    NSString *send_type = [keyvalue objectForKey:@"send_type"];
//    NSString *sender_id = [keyvalue objectForKey:@"sender_id"];
//    NSString *sender_name = [keyvalue objectForKey:@"sender_name"];
//    NSString *sender_url = [keyvalue objectForKey:@"sender_url"];
//    
//    NSString *type = [keyvalue objectForKey:@"type"];
//    
//    self.pushData = [GALPushData new];
//    
//    [self.pushData setMessage:message];
//    [self.pushData setItem_id:item_id];
//    [self.pushData setReceiver_id:receiver_id];
//    [self.pushData setSend_type:send_type];
//    [self.pushData setSender_id:sender_id];
//    [self.pushData setSender_name:sender_name];
//    [self.pushData setSender_url:sender_url];
//    [self.pushData setType:type];
//    
//    
//    NSDictionary *item_ids = [keyvalue objectForKey:@"item_ids"];
//    
//    if([item_ids isKindOfClass:[NSDictionary class]] && item_ids != nil){
//        NSString *lang_code = [item_ids objectForKey:@"lang_code"];
//        NSString *langcoin_id = [item_ids objectForKey:@"langcoin_id"];
//        NSString *schedule_date = [item_ids objectForKey:@"schedule_date"];
//        NSString *schedule_id = [item_ids objectForKey:@"schedule_id"];
//        NSString *schedule_item_cnt = [item_ids objectForKey:@"schedule_item_cnt"];
//        NSString *send_time = [item_ids objectForKey:@"send_time"];
//        NSString *time = [item_ids objectForKey:@"time"];
//        NSString *used_cost = [item_ids objectForKey:@"used_cost"];
//        
//        [self.pushData setLang_code:lang_code];
//        [self.pushData setLangcoin_id:langcoin_id];
//        [self.pushData setSchedule_date:schedule_date];
//        [self.pushData setSchedule_id:schedule_id];
//        [self.pushData setSchedule_item_cnt:schedule_item_cnt];
//        [self.pushData setSend_time:send_time];
//        [self.pushData setTime:time];
//        [self.pushData setUsed_cost:used_cost];
//    }
//}
//
//- (void)moveWithPushData{
//    if([MESSAGE_TYPE_CHAT isEqualToString:self.pushData.send_type]){
//        
//        GALChattingController *mGALChattingController = [[GALChattingController alloc] initWithUserUuid:self.pushData.sender_id withName:self.pushData.sender_name];
//        [ApplicationDelegate.mainNaviController pushViewController:mGALChattingController animated:YES];
//        
//    }else if([MESSAGE_TYPE_SCHEDULE isEqualToString:self.pushData.send_type]){
//        
//        GALScheduleController *mGALScheduleController = [[GALScheduleController alloc] initWithNibName:@"GALScheduleController" bundle:nil];
//        [ApplicationDelegate.mainNaviController pushViewController:mGALScheduleController animated:YES];
//        
//    }else if([MESSAGE_TYPE_REVIEW isEqualToString:self.pushData.send_type]){
//        
//        GALReviewController *mGALReviewController = [[GALReviewController alloc] initWithOtherUuid:self.pushData.sender_id withLangMode:nil withLangCode:nil                                                                                withLangList:nil];
//        
//        [ApplicationDelegate.mainNaviController pushViewController:mGALReviewController animated:YES];
//        
//    }else if([MESSAGE_TYPE_PAY isEqualToString:self.pushData.send_type]){
//        GALPayController *mGALPayController= [[GALPayController alloc] initWithNibName:@"GALPayController" bundle:nil];
//        [ApplicationDelegate.mainNaviController pushViewController:mGALPayController animated:YES];
//    }
//    
//    [self setPushData:nil];
//}
//
//- (void) showImagePopupView:(NSString *)url withImage:(UIImageView *)imageview{
//    
//    JTSImageInfo *imageInfo = [[JTSImageInfo alloc] init];
//    if(url != nil){
//        imageInfo.imageURL = [NSURL URLWithString:url];
//    }else{
//        imageInfo.image = [UIImage imageNamed:@"nopicture"];
//    }
//    
//    imageInfo.referenceRect = imageview.frame;
//    imageInfo.referenceView = imageview.superview;
//    imageInfo.referenceContentMode = imageview.contentMode;
//    imageInfo.referenceCornerRadius = imageview.layer.cornerRadius;
//    
//    // Setup view controller
//    JTSImageViewController *imageViewer = [[JTSImageViewController alloc]
//                                           initWithImageInfo:imageInfo
//                                           mode:JTSImageViewControllerMode_Image
//                                           backgroundStyle:JTSImageViewControllerBackgroundOption_Scaled];
//    
//    // Present the view controller.
//    [imageViewer showFromViewController:self.mainNaviController transition:JTSImageViewControllerTransition_FromOriginalPosition];
//}

@end
