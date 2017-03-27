//
//  LocationDistanceViewController.h
//  wezone
//
//  Created by Kim Sunmi on 2017. 3. 21..
//  Copyright © 2017년 Kim Sunmi. All rights reserved.
//

#import "GALBaseController.h"

typedef void (^LocationDistanceCompletionBlock)(int distance);
typedef void (^DistanceValueChanged)(int index);

@interface DistanceSliderView : UIView

-(instancetype)init:(CGRect)rect index:(int)index valueChanged:(DistanceValueChanged)valueChanged;

@end

@interface LocationDistanceViewController : GALBaseController

-(instancetype)init:(int)distance completion:(LocationDistanceCompletionBlock)completion;

@end
