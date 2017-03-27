//
//  GALEmailConfirmController.h
//  Langtudy
//
//  Created by SinSuMin on 2016. 11. 14..
//  Copyright © 2016년 galuster. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GALEmailConfirmControllerDelegate
@optional
- (void) onClickSendCode:(NSString *)code;
@end

@interface GALEmailConfirmController : UIViewController
@property (weak,nonatomic) id <GALEmailConfirmControllerDelegate> delegate;

- (id)initWithEmail:(NSString *)email;
@end
