//
//  GALNewPasswordViewController.h
//  Langtudy
//
//  Created by SinSuMin on 2016. 11. 14..
//  Copyright © 2016년 galuster. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GALNewPasswordViewControllerDelegate
@optional
- (void) onClickChangePassword:(NSString *)pw;
@end

@interface GALNewPasswordViewController : UIViewController
@property (weak,nonatomic) id <GALNewPasswordViewControllerDelegate> delegate;

- (id)initWithEmail:(NSString *)email;

@end
