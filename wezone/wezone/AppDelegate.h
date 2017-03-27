//
//  AppDelegate.h
//  Langtudy
//
//  Created by SinSuMin on 2015. 8. 20..
//  Copyright (c) 2015년 galuster. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <GoogleSignIn/GoogleSignIn.h>

#import "GALNaviController.h"
#import "GALLoginNaviController.h"
#import "NSLocale+ISO639_2.h"
#import "GALLogin.h"
#import "GALangtudyUtils.h"

#import "GALPushData.h"

//#import "SDPhotoViewController.h"
//#import "CLImageEditor.h"

#define ApplicationDelegate ((AppDelegate *)[UIApplication sharedApplication].delegate)
#define BundleVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) GALLoginNaviController *loginNaviController;

@property (strong, nonatomic) GALNaviController *mainNaviController;

@property (strong, nonatomic) GALPushData *pushData;
//
@property (strong, nonatomic) GALLogin *loginData;            //로그인 데이터

@property (strong, nonatomic) NSString *theme;

//@property (strong, nonatomic) SDPhotoViewController *photoViewController;   //현재 사용중인 포토뷰어 미사용시 nil
//@property (strong, nonatomic) CLImageEditor * imageEditViewController;      //현재 사용중인 이미지편집, 미사용시 nil;

- (void) changeRootViewControllerWithMain:(BOOL)isMain;

- (void) moveWithPushData;

- (BOOL)isLogin;
- (void) resetLoginData;
- (void) login;
- (void) logout;

- (void) showImagePopupView:(NSString *)url withImage:(UIImageView *)imageview;
@end

