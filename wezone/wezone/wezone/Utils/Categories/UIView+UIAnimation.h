//
//  UIView+UIAnimation.h
//  Shinhan_Gori
//
//  Created by sumin on 2014. 2. 14..
//  Copyright (c) 2014년 SDS 스마트개발센터. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (UIAnimation)

- (void) setHiddenWithAnimation:(BOOL)isHidden;
- (void) setDimAnimation:(BOOL)isDim;
- (void) setDimAnimation:(BOOL)isDim completion:(void (^)(BOOL finished))completion;

- (void) moveAnimationWithX:(float)x duration:(NSTimeInterval)duration;
- (void) moveAnimationWithY:(float)y duration:(NSTimeInterval)duration;
- (void) moveAnimationWithX:(float)x y:(float)y duration:(NSTimeInterval)duration;
- (void) moveAnimationWithX:(float)x y:(float)y delay:(NSTimeInterval)delay duration:(NSTimeInterval)duration;

- (void) moveAnimationToCenter:(CGPoint)center duration:(NSTimeInterval)duration;

- (void) shakeAnimationWithVibrate:(BOOL)isVibrate;

@end
