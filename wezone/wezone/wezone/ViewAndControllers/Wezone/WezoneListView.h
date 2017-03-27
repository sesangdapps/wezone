//
//  WezoneListView.h
//  wezone
//
//  Created by Kim Sunmi on 2017. 3. 23..
//  Copyright © 2017년 Kim Sunmi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^sizeChangedBlock)(CGRect rect);

@interface WezoneListView : UIView

- (instancetype)init:(NSString *)title rect:(CGRect)rect parent:(UIView *)parent sizeChanged:(sizeChangedBlock)sizeChanged;
- (void)reloadData:(NSArray *)list;

@end
