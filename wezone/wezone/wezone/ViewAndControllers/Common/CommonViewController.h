//
//  CommonViewController.h
//  wezone
//
//  Created by Kim Sunmi on 2017. 3. 13..
//  Copyright © 2017년 Kim Sunmi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Layout.h"
#import "Style.h"
#import "ThemeUtil.h"

@interface CommonViewController : UIViewController<UIScrollViewDelegate>

@property (strong, nonatomic) UIView *rootView;
@property (strong, nonatomic) UIView *bodyView;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (assign, nonatomic) float statusHeight;
@property (assign, nonatomic) float titleHeight;

@property (strong, nonatomic) UIView *titleView;
@property (strong, nonatomic) UIView *subTitleView;

- (void)makeRoot:(BOOL)scroll title:(NSString *)title bgColor:(UIColor *)bgColor;
- (void)makeRoot:(BOOL)scroll rect:(CGRect) rect title:(NSString *)title bgColor:(UIColor *)bgColor;
- (void)makeLeftBackButton;
- (void)makeLeftBackButton:(NSString *)normalImageName selector:(SEL)selector;
- (void)makeRightButton:(NSString *)image target:(id)target selector:(SEL)selector;
- (void)makeLayout;
- (void)setBodyHiehgt:(float)h;
- (void)goBack;
- (void)showErrorToast:(NSDictionary *)data error:(NSError *)error;

@end
