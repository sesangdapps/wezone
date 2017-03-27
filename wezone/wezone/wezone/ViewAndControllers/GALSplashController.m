//
//  GALSplashController.m
//  Langtudy
//
//  Created by SinSuMin on 2016. 8. 1..
//  Copyright © 2016년 galuster. All rights reserved.
//

#import "GALSplashController.h"
#import "LocationManager.h"

@interface GALSplashController ()

@property (weak, nonatomic) IBOutlet UIImageView *splash_ani;

@end

@implementation GALSplashController{
    BOOL isNetFinish;
    BOOL isAniFinish;
    BOOL isLocationFinish;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    self.splash_ani = [[UIImageView alloc] initWithFrame:splashscreenmovieclipframe];
    
    // load all the frames of our animation
//    self.splash_ani.animationImages = [NSArray arrayWithObjects:
//                                             [UIImage imageNamed:@"s_01.png"],
//                                             [UIImage imageNamed:@"s_02.png"],
//                                             [UIImage imageNamed:@"s_03.png"],
//                                             [UIImage imageNamed:@"s_04.png"],
//                                       [UIImage imageNamed:@"s_05.png"],
//                                       [UIImage imageNamed:@"s_06.png"],
//                                       [UIImage imageNamed:@"s_07.png"],
//                                       [UIImage imageNamed:@"s_08.png"],
//                                       [UIImage imageNamed:@"s_09.png"],
//                                       [UIImage imageNamed:@"s_10.png"],
//                                       [UIImage imageNamed:@"s_11.png"],
//                                       [UIImage imageNamed:@"s_12.png"],
//                                       [UIImage imageNamed:@"s_13.png"],
//                                       [UIImage imageNamed:@"s_14.png"],
//                                       nil];
//    
//        self.splash_ani.animationDuration = 1.5;
//
//        self.splash_ani.animationRepeatCount = 1;
    
    [self.titleDesc01Label setText:LSSTRING(@"splash_msg")];
    [self.titleDesc02Label setText:LSSTRING(@"splash_msg_title")];

    CGRect rect = self.view.frame;
    NSLog(@"%f, %f, %f, %f", rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
    
    // start animating
//    [self.splash_ani startAnimating];
//    // add the animation view to the main window
//    
//    [NSTimer scheduledTimerWithTimeInterval:1.5f target:self selector:@selector(doneAnimation) userInfo:nil repeats:NO];
//    
    [NSTimer scheduledTimerWithTimeInterval:2.5f target:self selector:@selector(doneAnimation) userInfo:nil repeats:NO];
    
   //    isAniFinish = YES;
    
    [[LocationManager sharedLocationManager] requestLocation];
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(locationChanged:) name: @"locationChanged" object: nil];

}

-(void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"locationChanged" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) doneAnimation {
//    self.splash_ani.animationImages = nil;
//    [self.splash_ani setImage:[UIImage imageNamed:@"s_14.png"]];
    
    isAniFinish = YES;
    [self goToNext];
}

- (void) sendLogin {
    
    ApplicationDelegate.loginData.loginParam.provider_type = [GALangtudyUtils getValue:SHARE_KEY_PROVIDER_TYPE];
    ApplicationDelegate.loginData.loginParam.latitude = ApplicationDelegate.loginData.user_latitude;
    ApplicationDelegate.loginData.loginParam.longitude = ApplicationDelegate.loginData.user_longitude;
    
    if(ApplicationDelegate.loginData.loginParam.provider_type != nil){
    
        if([@"F" isEqualToString:ApplicationDelegate.loginData.loginParam.provider_type]){
            ApplicationDelegate.loginData.loginParam.login_id = [GALangtudyUtils getValue:SHARE_KEY_LANGTUDY_ID];
            ApplicationDelegate.loginData.loginParam.login_passwd = [GALangtudyUtils getValue:SHARE_KEY_LANGTUDY_PW];
        } else if([@"F" isEqualToString:ApplicationDelegate.loginData.loginParam.provider_type]){
            //ApplicationDelegate.loginData.loginParam.provider_id = [GALangtudyUtils getValue:SHARE_KEY_PROVIDER_ID];
            ApplicationDelegate.loginData.loginParam.login_id = [GALangtudyUtils getValue:SHARE_KEY_PROVIDER_MAIL];
            
        } else {
            ApplicationDelegate.loginData.loginParam.login_id = [GALangtudyUtils getValue:SHARE_KEY_LANGTUDY_ID];
            ApplicationDelegate.loginData.loginParam.login_passwd = [GALangtudyUtils getValue:SHARE_KEY_LANGTUDY_PW];
        }
        
        GALLangtudyEngine *engine = [GALLangtudyEngine sharedEngine];
        
        [engine requestLogin:ApplicationDelegate.loginData.loginParam resultHandler:^(GALServerInfo *serverInfo, GALUserInfo *userInfo, NSMutableArray *payInfoList, NSString *email_auth) {
            
            if([@"G" isEqualToString:ApplicationDelegate.loginData.loginParam.provider_type]){
                
                //                [GALangtudyUtils saveValue:@"G" Key:SHARE_KEY_PROVIDER_TYPE];
                //                [GALangtudyUtils saveValue:ApplicationDelegate.loginNaviController.googleData.userId Key:SHARE_KEY_PROVIDER_ID];
                //                [GALangtudyUtils saveValue:ApplicationDelegate.loginData.loginParam.provider_email Key:SHARE_KEY_PROVIDER_MAIL];
                
            }else if([@"F" isEqualToString:ApplicationDelegate.loginData.loginParam.provider_type]){
                
                //                [GALangtudyUtils saveValue:@"F" Key:SHARE_KEY_PROVIDER_TYPE];
                //                [GALangtudyUtils saveValue:ApplicationDelegate.loginNaviController.facebookData.userId Key:SHARE_KEY_PROVIDER_ID];
                
                
            }else{
                
                [GALangtudyUtils saveValue:@"W" Key:SHARE_KEY_PROVIDER_TYPE];
                [GALangtudyUtils saveValue:ApplicationDelegate.loginData.loginParam.login_id Key:SHARE_KEY_LANGTUDY_ID];
                [GALangtudyUtils saveValue:ApplicationDelegate.loginData.loginParam.login_passwd Key:SHARE_KEY_LANGTUDY_PW];
            }
            
            ApplicationDelegate.loginData.server_info = serverInfo;
            ApplicationDelegate.loginData.user_info = userInfo;
            
            ApplicationDelegate.loginData.email_auth = email_auth;
            
            isNetFinish = YES;
            [self goToNext];
            
        } errorHandler:^(NSDictionary *data, NSError *error) {
            
            isNetFinish = YES;
            [self goToNext];
            
        }].isDisableActivityIndicator = YES;
        
    }else{
       
        isNetFinish = YES;
        [self goToNext];
    }
}

- (void) goToNext {
    
    if(isAniFinish && isNetFinish ){
        
        if([ApplicationDelegate isLogin]){
            [ApplicationDelegate changeRootViewControllerWithMain:YES];
        }else{
            [ApplicationDelegate changeRootViewControllerWithMain:NO];
        }
        
    }
}

- (void) locationChanged:(NSNotification *)notification {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"locationChanged" object:nil];
    
    [self sendLogin];
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
