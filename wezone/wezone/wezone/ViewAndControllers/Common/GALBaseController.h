//
//  NSObject_GALBaseController.h
//  Langtudy
//
//  Created by SinSuMin on 2015. 9. 3..
//  Copyright (c) 2015년 galuster. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "GALToastView.h"
#import "CommonViewController.h"

//#import "MXSegmentedPagerController.h"

//#import "GALCallOption.h"

//#import "ARTCVideoChatViewController.h"


typedef NS_ENUM(NSInteger, GALType) {
    GALTypeLearner = 0,
    GALTypeTeacher,
};


@interface GALBaseController : CommonViewController//<SDXmppDelegate,ARTCVideoChatViewControllerDelegate>
- (void) goBackinLogin;
- (void) goBackinMain;
- (void) goBackinMainTwice;
- (void) goBackinMainThreeStep;

- (NSString *) getStringWithKey:(NSString *)key;

- (void) sendUserStatus:(NSString *)status;
//- (void) sendUserStatus:(NSString *)status OtherUuid:(NSString *)other_user_uuid CallOption:(GALCallOption *)option resultBloc:(userStatusBlock) resultBlock;

@end

