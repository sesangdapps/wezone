//
//  SDToastView.h
//  ShinhanGori
//
//  Created by sumin on 2014. 2. 12..
//  Copyright (c) 2014년 SDS 스마트개발센터. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GALToastView : UIView
+ (GALToastView *) toastView;

- (void)showWithImageUrl:(NSString *)aImgUrl Title:(NSString *)aTitle Text:(NSString *)aText target:(id)aTarget selector:(SEL)aSelector;
- (void)showWithIcon:(UIImage *)aIcon Title:(NSString *)aTitle Text:(NSString *)aText target:(id)aTarget selector:(SEL)aSelector;

+ (void)showWithText:(NSString *)aText originY:(CGFloat)aOriginY;
+ (void)showWithText:(NSString *)aText;
- (void)__hide;
@end
