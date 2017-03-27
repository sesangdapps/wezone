//
//  LocationTypeViewController.h
//  wezone
//
//  Created by Kim Sunmi on 2017. 3. 21..
//  Copyright © 2017년 Kim Sunmi. All rights reserved.
//

#import "GALBaseController.h"

typedef void (^LocationTypeCompletionBlock)(NSString *locationType, NSString *value);

@interface LocationTypeViewController : GALBaseController

-(instancetype)init:(NSString *)title wezone:(WezoneModel *)wezone completion:(LocationTypeCompletionBlock)completion;

@end
