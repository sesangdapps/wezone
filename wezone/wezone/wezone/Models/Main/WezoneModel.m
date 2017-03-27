//
//  WezoneModel.m
//  wezone
//
//  Created by Kim Sunmi on 2017. 3. 16..
//  Copyright © 2017년 Kim Sunmi. All rights reserved.
//

#import "WezoneModel.h"

@implementation WezoneModel

- (instancetype)initWithDefault {
    
    self = [self init];
    if ( self ) {
        self.title = @"";
        self.introduction = @"";
        self.location_type = @"G";
        self.location_data = @"200";
        self.member_limit = @"100";
        self.push_flag = @"T";
        self.wezone_type = @"F";
        self.beacon = [NSArray array];
        self.zone_in = [NSArray array];
        self.zone_out = [NSArray array];
        
        
        
//        img_url
//        bg_img_url
//        wezone_type
//        member_limit
//        location_type
//        beacon
//        location_data
//        push
        
    }
    return self;
}

@end
