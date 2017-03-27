//
//  MainViewController.m
//  wezone
//
//  Created by Kim Sunmi on 2017. 3. 14..
//  Copyright © 2017년 Kim Sunmi. All rights reserved.
//

#import "MainViewController.h"
#import "MainBottomView.h"

#define kMenuAnimationDuration 0.2

@interface MainViewController ()

@property (nonatomic, retain) GALLeftMenuController *leftMenuController;
@property (nonatomic, assign) BOOL mainMenuDisplay;
@property (nonatomic, strong) MainBottomView * bottomView;

@end

@implementation MainViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self makeLeftMenu];
    
    [self makeTop];
    
//    [self.tableView addPullToRefreshWithInset:UIEdgeInsetsMake(TABLE_CONTENT_OFFSETTOP, 0, 0, 0) withHeader:NO isBottom:YES];
//    [self.tableView addDelegateToRefresh:self];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    if ( self.bottomView ) {
        [self.bottomView reload];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.tintColor = [ThemeUtil naviColor];
}

#pragma mark -
#pragma mark Layout

- (void)makeLayout {
    
    [self makeRoot:NO title:@"" bgColor:UIColor_main];
    
    self.bottomView = [[MainBottomView alloc] init:self.bodyView];
    
//    UIView *scanView = [[UIView alloc] init:[Layout aspecRect:CGRectMake(0, 0, LAYOUT_WIDTH, 100)] parent:self.bodyView tag:0 color:[UIColor clearColor]];
//    
//    UIView *beconeView = [[UIView alloc] init:[Layout aspecRect:CGRectMake(0, 0, LAYOUT_WIDTH, 100)] parent:self.bodyView tag:0 color:[UIColor clearColor]];
//    
//    UIView *themeView = [[UIView alloc] init:[Layout aspecRect:CGRectMake(0, 0, LAYOUT_WIDTH, 100)] parent:self.bodyView tag:0 color:[UIColor clearColor]];
    
}
- (void)makeTop {
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_app_tit"]];
    
    [self makeLeftBackButton:@"btn_menu" selector:@selector(toggleLeftMenu)];
    
    UIButton *messageBtn  = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 22, 22)];
    [messageBtn setImage:[UIImage imageNamed:@"btn_message"] forState:UIControlStateNormal];
    
    [messageBtn addTarget:self action:@selector(onClickMessage) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *messageBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:messageBtn];
    messageBarButtonItem.badgeBGColor = [UIColor redColor];
    
    UIButton *scheduleBtn  = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 22, 22)];
    [scheduleBtn setImage:[UIImage imageNamed:@"btn_notifications"] forState:UIControlStateNormal];
    
    [scheduleBtn addTarget:self action:@selector(onClickSchedule) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *scheduleBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:scheduleBtn];
    
    scheduleBarButtonItem.badgeBGColor = [UIColor redColor];
    //scheduleBarButtonItem.badgeValue = ApplicationDelegate.loginData.user_info.schedule_count;
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -6;
    
    
    NSMutableArray *rightBarButtonArray = [[NSMutableArray alloc] initWithCapacity:2];
    [rightBarButtonArray addObject:messageBarButtonItem];
    [rightBarButtonArray addObject:scheduleBarButtonItem];
    
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:negativeSpacer, scheduleBarButtonItem, messageBarButtonItem, nil]];
    
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
}

#pragma mark -
#pragma mark Left menu

- (void)makeLeftMenu {
 
    self.leftMenuController = [[GALLeftMenuController alloc] initWithNibName:@"GALLeftMenuController" bundle:nil];
    //[self.leftMenuController setMainLang:self.mainLang];
    
    self.leftMenuController.view.frame = CGRectMake(-self.navigationController.view.frame.size.width, 0.0f, self.navigationController.view.frame.size.width, ApplicationDelegate.window.frame.size.height);
    
    [self.leftMenuController setDelegate:self];
    
    [ApplicationDelegate.window addSubview:self.leftMenuController.view];
    
    UISwipeGestureRecognizer *leftGest = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(hideLeftMenu)];
    leftGest.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:leftGest];
    [self.leftMenuController.view addGestureRecognizer:leftGest];
    
    UISwipeGestureRecognizer *rightGest = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showLeftMenu)];
    rightGest.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:rightGest];
}


- (void)hideLeftMenu
{
    [UIView animateWithDuration:kMenuAnimationDuration animations:^{
        
        self.leftMenuController.view.frame = CGRectMake(-self.navigationController.view.frame.size.width, 0.0f, self.navigationController.view.frame.size.width, ApplicationDelegate.window.frame.size.height);
        
    }completion:^(BOOL finished){
        
        self.mainMenuDisplay = NO;
        [self.leftMenuController.view setHidden:YES];
    }];
}

- (void)showLeftMenu
{
//    if([self.searchOptionLangteeView alpha] != 0 || [self.searchOptionLangtorView alpha] != 0){
//        return;
//    }
    
    [self.leftMenuController.view setHidden:NO];
    [self.leftMenuController setLayout];
    
    [UIView animateWithDuration:kMenuAnimationDuration animations:^{
        
        self.leftMenuController.view.frame = CGRectMake(0.0f, 0.0f, self.leftMenuController.view.frame.size.width, ApplicationDelegate.window.frame.size.height);
        
    }completion:^(BOOL finished){
        self.mainMenuDisplay = YES;
    }];
}

- (void) toggleLeftMenu{
    if (self.mainMenuDisplay) {
        [self hideLeftMenu];
    }
    else
    {
        [self showLeftMenu];
    }
}

- (void) onClickSchedule{
    
//    GALScheduleController *mGALScheduleController = [[GALScheduleController alloc] initWithNibName:@"GALScheduleController" bundle:nil];
//    [ApplicationDelegate.mainNaviController pushViewController:mGALScheduleController animated:YES];
}

- (void) onClickMessage{
//    GALMessageController *mGALMessageController = [[GALMessageController alloc] initWithNibName:@"GALMessageController" bundle:nil];
//    [ApplicationDelegate.mainNaviController pushViewController:mGALMessageController animated:YES];
}

#pragma mark - GALLeftMenuControllerDelegate
- (void) onClickButton:(GALLeftMenuType) menuType {
    
    if(menuType == GALLeftMenuBanner){
//        if(self.advertList != nil && [self.advertList count] > 0){
//            GALAdvert *advert = [self.advertList objectAtIndex:0];
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:advert.advert_data]];
//        }else{
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:(@"https://www.langtudy.com")]];
//        }
    }
    [self hideLeftMenu];
}

@end
