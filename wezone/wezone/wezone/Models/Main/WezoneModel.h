//
//  WezoneModel.h
//  wezone
//
//  Created by Kim Sunmi on 2017. 3. 16..
//  Copyright © 2017년 Kim Sunmi. All rights reserved.
//

@interface WezoneModel : GALBaseModel

@property (assign, nonatomic) int id;
@property (assign, nonatomic) float distance;
@property (assign, nonatomic) BOOL isJoin;
@property (strong, nonatomic) NSString *uuid;
@property (strong, nonatomic) NSString *zone_type;
@property (strong, nonatomic) NSString *zone_id;
@property (strong, nonatomic) NSString *manage_type;
@property (strong, nonatomic) NSString *push_flag;
@property (strong, nonatomic) NSString *wait_datetime;
@property (strong, nonatomic) NSString *join_datetime;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *introduction;
@property (strong, nonatomic) NSString *img_url;
@property (strong, nonatomic) NSString *bg_img_url;
@property (strong, nonatomic) NSString *longitude;
@property (strong, nonatomic) NSString *latitude;
@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSString *hashtag;
@property (strong, nonatomic) NSString *wezone_type;
@property (strong, nonatomic) NSString *member_limit;
@property (strong, nonatomic) NSString *location_type;
@property (strong, nonatomic) NSString *location_data;
@property (strong, nonatomic) NSString *update_datetime;
@property (strong, nonatomic) NSString *create_datetime;
@property (strong, nonatomic) NSString *zone_possible;
@property (strong, nonatomic) NSString *wezone_id;

@property (strong, nonatomic) NSArray *beacon;
//@property (strong, nonatomic) NSArray *location_data;

@property (strong, nonatomic) NSArray *zone_in;
@property (strong, nonatomic) NSArray *zone_out;

- (instancetype)initWithDefault;

@end
