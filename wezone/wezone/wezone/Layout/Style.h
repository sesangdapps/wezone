//
//  Style.h
//  wezone
//
//  Created by Kim Sunmi on 2017. 3. 13..
//  Copyright © 2017년 Kim Sunmi. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN



@interface UITextField(Style)


-(instancetype) defaultStyle:(NSString *)text placeholder:(NSString *)placeholder delegate:(id<UITextFieldDelegate>)delegate;
-(instancetype) defaultStyle:(NSString *)text placeholder:(NSString *)placeholder type:(UIKeyboardType)type password:(BOOL)password delegate:(id<UITextFieldDelegate>)delegate;

@end

@interface UIButton(Style)


-(instancetype) blueStyle;
-(instancetype) outlineStyle;
-(instancetype) icontextStyle:(NSString *)iconName;

@end

NS_ASSUME_NONNULL_END
