//
//  EditViewController.h
//  wezone
//
//  Created by Kim Sunmi on 2017. 3. 21..
//  Copyright © 2017년 Kim Sunmi. All rights reserved.
//

#import "GALBaseController.h"

typedef void (^EditCompletionBlock)(NSString *content);

@interface EditViewController : GALBaseController<UITextViewDelegate>

-(instancetype)init:(NSString *)title content:(NSString *)content placeholder:(NSString *)placeholder completion:(EditCompletionBlock)completion;

@end
