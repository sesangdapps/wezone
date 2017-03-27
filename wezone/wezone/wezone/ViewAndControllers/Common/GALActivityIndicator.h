//
//  SDActivityIndicator.h
//  Shinhan_Gori
//
//  Created by jhkim.sds on 2014. 2. 14..
//  Copyright (c) 2014년 SDS 스마트개발센터. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GALActivityIndicator : UIView

+ (instancetype)sharedInstance;
- (void)show;
- (void)hide;

@end
