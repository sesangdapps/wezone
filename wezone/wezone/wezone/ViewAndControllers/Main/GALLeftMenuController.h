//
//  GALLeftMenuController.h
//  Langtudy
//
//  Created by SinSuMin on 2016. 8. 19..
//  Copyright © 2016년 galuster. All rights reserved.
//

#import "ViewController.h"
//#import "GALLangData.h"
//#import "GALLeftMenuLangItem.h"
#import "UIViewController+MJPopupViewController.h"

//#import "GALIntroductionController.h"

typedef NS_ENUM(NSInteger, GALLeftMenuType) {
    GALLeftMenuMyProfile= 0,
    GALLeftMenuMarket,
    GALLeftMenuFriend,
    GALLeftMenuSetting,
    GALLeftMenuFAQ,
    GALLeftMenuLogout,
    GALLeftMenuBanner
};

@protocol GALLeftMenuControllerDelegate
@optional
- (void) onClickButton:(GALLeftMenuType) menuType;
//- (void) onClickLanguage:(GALLangData *) langData;
@end

@interface GALLeftMenuController : UIViewController//<GALIntroductionControllerDelegate>
//@property (strong, nonatomic) GALLangData *mainLang;
@property (weak,nonatomic) id <GALLeftMenuControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIImageView *advertImageView;

- (void) setLayout;
@end
