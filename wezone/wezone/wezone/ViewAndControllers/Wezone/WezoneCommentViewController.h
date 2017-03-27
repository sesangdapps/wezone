//
//  WezoneCommentViewController.h
//  wezone
//
//  Created by Kim Sunmi on 2017. 3. 19..
//  Copyright © 2017년 Kim Sunmi. All rights reserved.
//

#import "GALBaseController.h"

@interface WezoneCommentViewController : GALBaseController<UITextViewDelegate>

- (instancetype)init:(WezoneModel *)wezone comment:(WezoneComment *)comment;

@end
