//
//  WezoneBoardViewController.h
//  wezone
//
//  Created by Kim Sunmi on 2017. 3. 19..
//  Copyright © 2017년 Kim Sunmi. All rights reserved.
//

#import "GALBaseController.h"

@interface WezoneBoardViewController : GALBaseController<UITextViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

- (instancetype)init:(WezoneModel *)wezone board:(WezoneBoard *)board;

@end
