//
//  UIView+UIAnimation.m
//  Shinhan_Gori
//
//  Created by sumin on 2014. 2. 14..
//  Copyright (c) 2014년 SDS 스마트개발센터. All rights reserved.
//

#import "UIView+UIAnimation.h"
#import <AudioToolbox/AudioToolbox.h>

@implementation UIView (UIAnimation)

- (void) setHiddenWithAnimation:(BOOL)isHidden{
    
    if(isHidden){
        [UIView animateWithDuration:0.3f animations:^{
            [self setAlpha:0.0f];
        } completion:^(BOOL finished) {
            if(finished)
                [self setHidden:YES];
        }];
    }else{
        [UIView animateWithDuration:0.5f animations:^{
            [self setAlpha:1.0f];
        } completion:^(BOOL finished) {
            if(finished)
                [self setHidden:NO];
        }];
    }
}

- (void) setDimAnimation:(BOOL)isDim{
    [self setDimAnimation:isDim completion:nil];
}

- (void) setDimAnimation:(BOOL)isDim completion:(void (^)(BOOL finished))completion{
    if(isDim){
        [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4f];
                         }
                         completion:completion];
    }else{
        [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.0f];
                         }
                         completion:completion];
    }
}

- (void) moveAnimationWithX:(float)x y:(float)y delay:(NSTimeInterval)delay duration:(NSTimeInterval)duration{
    CGRect frame = self.frame;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:duration];
    [UIView setAnimationDelay:delay];
    [self setFrame:CGRectMake(x, y,frame.size.width, frame.size.height)];
    [UIView commitAnimations];
}

- (void) moveAnimationWithX:(float)x y:(float)y duration:(NSTimeInterval)duration{
    [self moveAnimationWithX:x y:y delay:0.2 duration:duration];
}

- (void) moveAnimationWithX:(float)x duration:(NSTimeInterval)duration{
    CGRect frame = self.frame;
    [self moveAnimationWithX:x y:frame.origin.y duration:duration];
}

- (void) moveAnimationWithY:(float)y duration:(NSTimeInterval)duration{
    CGRect frame = self.frame;
    [self moveAnimationWithX:frame.origin.x y:y duration:duration];
}

- (void) moveAnimationToCenter:(CGPoint)center duration:(NSTimeInterval)duration{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:duration];
    [UIView setAnimationDelay:0.2];
    [self setCenter:center];
    [UIView commitAnimations];
}

- (void) shakeAnimationWithVibrate:(BOOL)isVibrate{
    
    if(isVibrate){
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    }
    
    CGFloat t = 5.0f;
    CGAffineTransform translateRight = CGAffineTransformTranslate(CGAffineTransformIdentity, t, 0);
    CGAffineTransform translateLeft = CGAffineTransformTranslate(CGAffineTransformIdentity, -t, 0);
    
    self.transform = translateLeft;
    
    [UIView animateWithDuration:0.08 delay:0.0 options:UIViewAnimationOptionAutoreverse|UIViewAnimationOptionRepeat|UIViewAnimationCurveEaseIn animations:^
     {
         [UIView setAnimationRepeatCount:7.0];
         self.transform = translateRight;
     } completion:^(BOOL finished)
     
     {
         if (finished)
         {
             [UIView animateWithDuration:0.08 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^
             {
                  self.transform = CGAffineTransformIdentity;
             }
            completion:NULL];
         }
     }];

}

@end
