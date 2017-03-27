//
//  GALHomeNaviController.m
//  Langtudy
//
//  Created by SinSuMin on 2016. 8. 9..
//  Copyright © 2016년 galuster. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ThemeUtil.h"

#import "GALBaseController.h"
#import "GALNaviController.h"

@interface GALNaviController ()

@end

@implementation GALNaviController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationBar.translucent = NO;
    self.delegate = self;
    
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.shadowImage = [UIImage new];
//    self.navigationController.navigationBar.translucent = YES;
//    self.navigationController.view.backgroundColor = [UIColor clearColor];
//    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    
    if (IS_IOS7_OR_LATER) {
        self.navigationBar.barTintColor = [ThemeUtil naviColor];
        self.navigationBar.tintColor = [UIColor whiteColor];
        
        // iOS7에서 left버튼을 사용한 뒤에 기본 백버튼 이미지가 보이는 현상을 제거
        [self.navigationBar setBackIndicatorImage:[UIImage new]];
        [self.navigationBar setBackIndicatorTransitionMaskImage:[UIImage new]];
        
        
    }
    else {
        self.navigationBar.tintColor = [ThemeUtil naviColor];
        //        [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"bg_titlebar"] forBarMetrics:UIBarMetricsDefault];
    }
    
    //    UIImage *btn_back_nm = [[UIImage imageNamed:@"btn_back"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 22.f, 0, 0)]; // 22x22
    //    UIImage *btn_back_ov = [[UIImage imageNamed:@"btn_back_ov"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 22.f, 0, 0)];
    //    [[UIBarButtonItem appearanceWhenContainedIn:[SDHomeNaviController class], nil] setBackButtonBackgroundImage:btn_back_nm
    //                                                                                                       forState:UIControlStateNormal
    //                                                                                                     barMetrics:UIBarMetricsDefault];
    //    [[UIBarButtonItem appearanceWhenContainedIn:[SDHomeNaviController class], nil] setBackButtonBackgroundImage:btn_back_ov
    //                                                                                                       forState:UIControlStateHighlighted
    //                                                                                                     barMetrics:UIBarMetricsDefault];
    
    [self.navigationBar setTitleTextAttributes:@{
                                                 NSForegroundColorAttributeName: UIColorFromRGB(0xfefefe),
                                                 //NSShadowAttributeName: shadow,
                                                 UITextAttributeTextShadowColor: [UIColor clearColor],
                                                 NSFontAttributeName: [UIFont systemFontOfSize:15.0]
                                                 }];
    
    
//    GALLeftMenuController *leftMenu = [[GALLeftMenuController alloc] initWithNibName:@"GALLeftMenuController" bundle:nil];
    
//    self.leftMenu = leftMenu;
//    self.enableSwipeGesture = YES;
    
//    UIButton *button  = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
//    [button setImage:[UIImage imageNamed:@"btn_menu"] forState:UIControlStateNormal];
//    [button setImage:[UIImage imageNamed:@"btn_menu_touch"] forState:UIControlStateHighlighted];
//    
//    [button addTarget:[SlideNavigationController sharedInstance] action:@selector(toggleLeftMenu) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
//    //    ApplicationDelegate.mainNaviController.navigationItem.leftBarButtonItem = leftBarButtonItem;
//    
//    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
//    self.navigationItem.title = @"dkdkdkdk";
    
//    self.leftBarButtonItem = leftBarButtonItem;
//    self.title = @"안나와";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[navigationController.navigationBar subviews] makeObjectsPerformSelector:@selector(setNeedsDisplay)];
    });
    
}

/**********************************************************/
- (BOOL)shouldAutorotate
{
    return NO;
    
//    if ([self.topViewController isMemberOfClass:[SDPhotoViewController class]]) {
//        return YES;
//        
//    } else {
//        return NO;
//        
//    }
    
    return NO;
    
    
    //    if ([self.topViewController respondsToSelector:@selector(supportedInterfaceOrientations)]) {
    //        NSLog(@"SDHomeNaviController shouldAutorotate : %i", [self.topViewController shouldAutorotate]);
    //        return [self.topViewController shouldAutorotate];
    //    }else{
    //        NSLog(@"SDHomeNaviController shouldAutorotate : %i", [self.topViewController shouldAutorotate]);
    //        return YES;
    //
    //    }
}



- (NSUInteger)supportedInterfaceOrientations
{
//    NSLog(@"self.topViewController is %@", self.topViewController);
    
    return UIInterfaceOrientationMaskPortrait;
    
//    if ([self.topViewController isMemberOfClass:[SDPhotoViewController class]]) {
//        return UIInterfaceOrientationMaskAll;
//        
//    } else {
//        return UIInterfaceOrientationMaskPortrait;
//        
//    }
    
    
    //    NSLog(@"TabBar supportedInterfaceOrientations class : %@", [tempViewController class]);
    //    NSLog(@"TabBar supportedInterfaceOrientations count : %i", [self.viewControllers count]);
    //    if ([self.topViewController respondsToSelector:@selector(supportedInterfaceOrientations)]) {
    //        NSLog(@"SDHomeNaviController if supportedInterfaceOrientations : %i", [self.topViewController supportedInterfaceOrientations]);
    //        return [self.topViewController supportedInterfaceOrientations];
    //    }else{
    //        NSLog(@"SDHomeNaviController else supportedInterfaceOrientations : %i", [self.topViewController supportedInterfaceOrientations]);
    //        return UIInterfaceOrientationMaskPortrait|UIInterfaceOrientationMaskPortraitUpsideDown;
    //
    //    }
    
    
}

@end

