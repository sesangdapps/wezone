//
//  GALFindPasswordViewController.h
//  Langtudy
//
//  Created by SinSuMin on 2016. 11. 14..
//  Copyright © 2016년 galuster. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GALFindPasswordViewControllerDelegate
@optional
- (void) onClickSendMail:(NSString *)email;
@end

@interface GALFindPasswordViewController : UIViewController
@property (weak,nonatomic) id <GALFindPasswordViewControllerDelegate> delegate;
@end
