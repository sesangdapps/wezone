//
//  GALSignPasswordController.m
//  Langtudy
//
//  Created by SinSuMin on 2016. 8. 11..
//  Copyright © 2016년 galuster. All rights reserved.
//

#import "GALSignPasswordController.h"
#import "UITextField+GALPaddingText.h"
#import "GALNameController.h"


//#import "GALLearnLangController.h"

@interface GALSignPasswordController ()


//static views
@property (strong, nonatomic) IBOutlet UILabel *descLabel;
@property (strong, nonatomic) IBOutlet UIButton *nextButton;



@property NSInteger totalCnt;

@property (strong, nonatomic) IBOutlet UIView *progressView;

@property (strong, nonatomic) IBOutlet UIImageView *progressBg;

@property (strong, nonatomic) IBOutlet UILabel *notice;
@property (strong, nonatomic) IBOutlet UITextField *pwField;

@property (nonatomic) CGFloat originalY;

@end

@implementation GALSignPasswordController

- (id) initWithTotalCount:(NSInteger)total_cnt
{
    //self = [super initWithNibName:@"GALSignPasswordController" bundle:nil];
    self = [super init];
    if (self) {
        // Custom initialization
        self.totalCnt = total_cnt;
        
    }
    return self;
}

- (void) viewDidLoad{
    
    [super viewDidLoad];
    
    self.originalY = self.view.frame.origin.y;
    
//    [self setTitle:[self getStringWithKey:@"sing_up"]];
//    
//    [self.notice setText:[NSString stringWithFormat:[self getStringWithKey:@"login_pass_notice"],ApplicationDelegate.loginNaviController.email]];
//    
//    [self.descLabel setText:[self getStringWithKey:@"please_enter_your_password"]];
//    
//    [self.pwField setPlaceholder:[self getStringWithKey:@"password"]];
//    
//    [self.nextButton setTitle:[self getStringWithKey:@"next"] forState:UIControlStateNormal];
    
    
//    [[ApplicationDelegate loginNaviController] setProgressLayout:self.progressView withBg:self.progressBg withTotalCount:self.totalCnt withCount:1];
    
//    [self.pwField setLeftPadding:20.0f];
//    [self.pwField setRightPadding:20.0f];
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
//    [self.view addGestureRecognizer:tap];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void) viewDidAppear:(BOOL)animated{
//    [ApplicationDelegate.loginNaviController setNavigationBarHidden:NO animated:YES];
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void) makeLayout {
    
    [self makeRoot:NO title:[self getStringWithKey:@"sing_up"] bgColor:UIColor_main];
    [self makeLeftBackButton];
    
    float x = 20;
    float y = 32;
    
    self.notice = [[UILabel alloc] init:[Layout aspecRect:CGRectMake(x, y, LAYOUT_WIDTH - x * 2, 19)] parent:self.bodyView tag:0 text:[NSString stringWithFormat:[self getStringWithKey:@"login_pass_notice"],ApplicationDelegate.loginNaviController.email] color:UIColorFromRGB(0x000000) bgColor:nil align:NSTextAlignmentLeft font:@"bold" size:[Layout aspecValue:17.0f]];
    [self.notice sizeToFit];
    y += [Layout revert:self.notice.frame.size.height] + 10;
    
    self.descLabel = [[UILabel alloc] init:[Layout aspecRect:CGRectMake(x, y, LAYOUT_WIDTH - x * 2, 16)] parent:self.bodyView tag:0 text:[self getStringWithKey:@"please_enter_your_password"] color:UIColorFromRGB(0x6C6C6C) bgColor:nil align:NSTextAlignmentLeft font:nil size:[Layout aspecValue:14.0f]];
    y += 16 + 10;
    
    self.pwField = [[[UITextField alloc]init:[Layout aspecRect:CGRectMake(x, y, LAYOUT_WIDTH - x * 2, 44)] parent:self.bodyView tag:0] defaultStyle:@"" placeholder:[self getStringWithKey:@"password"] type:UIKeyboardTypeDefault password:YES delegate:nil];
    y += 44 + 6;
    
    
    self.nextButton = [[[[UIButton alloc] init:[Layout aspecRect:CGRectMake(0, y, LAYOUT_WIDTH, 60)] parent:self.bodyView tag:0 target:self action:@selector(onClickNext:)]
                         addTitle:[self getStringWithKey:@"next"]]
                        addBackgroundColor:UIColorFromRGB(0x669cf8) highlightedColor:nil disabledColor:nil] ;
    
    [self.nextButton setY:self.bodyView.frame.size.height - self.nextButton.frame.size.height];
    
    [self.bodyView addTarget:self action:@selector(dismissKeyboard)];
}


- (IBAction)onClickNext:(id)sender {
    
    NSString *strPass = [[self.pwField text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if([strPass length] < 1){
        //        [self.idField shakeAnimationWithVibrate:YES];
        [GALToastView showWithText:[self getStringWithKey:@"please_enter_your_password"]];
        return;
    }
    
    if([strPass length] < 8){
        //        [self.idField shakeAnimationWithVibrate:YES];
        [GALToastView showWithText:[self getStringWithKey:@"password_limit_error"]];
        return;
    }
    
//    [ApplicationDelegate.loginNaviController setTeachLang:langData];
    
    [ApplicationDelegate.loginNaviController setPass:strPass];
    
    GALNameController *mGALNameController = [[GALNameController alloc] initWithTotalCount:self.totalCnt];
    
    [ApplicationDelegate.loginNaviController pushViewController:mGALNameController animated:YES];

//    GALLearnLangController *mGALLearnLangController = [[GALLearnLangController alloc] initWithTotalCount:self.totalCnt];
//    
//    [ApplicationDelegate.loginNaviController setPass:strPass];
//    
//    [ApplicationDelegate.loginNaviController pushViewController:mGALLearnLangController animated:YES];
    
//    [self.navigationController pushViewController:mGALLearnLangController animated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)txtField
{
    [txtField resignFirstResponder];
    [self onClickNext:nil];
    return NO;
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
    [self.pwField endEditing:YES];
}

@end
