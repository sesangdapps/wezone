//
//  MainBottomView.h
//  wezone
//
//  Created by Kim Sunmi on 2017. 3. 15..
//  Copyright © 2017년 Kim Sunmi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainBottomView : UIView<UIScrollViewDelegate>

-(instancetype) init:(UIView *)parent;
-(void)reload;

@end
