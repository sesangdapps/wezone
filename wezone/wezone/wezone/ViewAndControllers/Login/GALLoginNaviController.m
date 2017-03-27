//
//  GALLoginNaviController.m
//  Langtudy
//
//  Created by SinSuMin on 2016. 8. 9..
//  Copyright © 2016년 galuster. All rights reserved.
//

#import <Foundation/Foundation.h>
//  GALHomeNaviController.m
//  Langtudy
//
//  Created by SinSuMin on 2016. 8. 9..
//  Copyright © 2016년 galuster. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ThemeUtil.h"

#import "GALBaseController.h"
#import "GALLoginNaviController.h"

#import "GALSignPasswordController.h"

@interface GALLoginNaviController ()

@end

@implementation GALLoginNaviController


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
    self.navigationBar.barStyle = UIStatusBarStyleLightContent;
    
    
    if (IS_IOS7_OR_LATER) {
        self.navigationBar.barTintColor = [ThemeUtil naviColor];
        
//        self.navigationBar.tintColor = [UIColor whiteColor];
        
        // iOS7에서 left버튼을 사용한 뒤에 기본 백버튼 이미지가 보이는 현상을 제거
        [self.navigationBar setBackIndicatorImage:[UIImage new]];
        [self.navigationBar setBackIndicatorTransitionMaskImage:[UIImage new]];
    }
    else {
        self.navigationBar.tintColor = [ThemeUtil naviColor];
//                [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"bg_titlebar"] forBarMetrics:UIBarMetricsDefault];
    }
    
//
        [self.navigationBar setTitleTextAttributes:@{
                                                     NSForegroundColorAttributeName: UIColorFromRGB(0xffffff),
                                                     //NSShadowAttributeName: shadow,
                                                     UITextAttributeTextShadowColor: [UIColor clearColor],
                                                     NSFontAttributeName: [UIFont systemFontOfSize:20.0]
                                                     }];
//    }
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
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
    
    // 보여질 VC가 루트가 아니면
    if ([self isRoot:navigationController] == NO) {
        [self setNavigationBarHidden:NO animated:NO];
        //[self changeBarButtonItem:viewController.navigationItem withImage:@"btn_back" withOverImage:@"btn_back_touch"];
    }else{
        [self setNavigationBarHidden:YES animated:NO];
    }
    
}

- (void)changeBarButtonItem:(UINavigationItem *)navItem withImage:(NSString *)img withOverImage:(NSString *)OverImg {
//    UIImage *btn_back_nm = [[UIImage imageNamed:img] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 22.f, 0, 0)]; // 22x22
//    UIImage *btn_back_ov = [[UIImage imageNamed:OverImg] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 22.f, 0, 0)];
    
    // http://stackoverflow.com/questions/18870128/ios-7-navigation-bar-custom-back-button-without-title
    UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithTitle:@" "
                                                            style:UIBarButtonItemStylePlain
                                                           target:nil
                                                           action:nil];
    
//    [bbi setBackButtonBackgroundImage:[UIImage imageNamed:img] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
//    [bbi setBackButtonBackgroundImage:[UIImage imageNamed:OverImg] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    
    [[UINavigationBar appearance] setBackIndicatorImage:[UIImage imageNamed:img]];
    [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:[UIImage imageNamed:img]];
    
//    navItem.backBarButtonItem = bbi;
    
}

- (BOOL) isRoot:(UINavigationController *) naviController{
    
    if (naviController.viewControllers.count > 1) {
        return NO;
    }else{
        return YES;
    }
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
    
//    return NO;
    
    
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
    
}


- (void) setProgressLayout:(UIView *)progressView withBg:(UIImageView *)progressBg withTotalCount:(NSInteger)totalCnt withCount:(NSInteger)cnt{
    
    CGRect rect = progressView.frame;
    rect.size.width = self.view.frame.size.width;
    progressView.frame = rect;
    
    progressBg.frame = rect;
    
    
    float itemWidth = (rect.size.width / totalCnt) -1 ;
    CGFloat floatX = 0.0f;
    CGFloat space = 0.0f;
    for(NSInteger i=0; i<cnt; i++){
        
        if(i != 0){
            space += 2;
        }
        
        floatX = (itemWidth * i) + space;
        
        CGRect viewRect = CGRectMake(floatX, 0.0f, itemWidth, 10.0f);
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn_replay_touch"]];
        [imgView setFrame:viewRect];
        
        [progressView addSubview:imgView];
        
    }
}

@end

