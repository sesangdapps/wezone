//
//  UserModel.h
//  wezone
//
//  Created by Kim Sunmi on 2017. 3. 17..
//  Copyright © 2017년 Kim Sunmi. All rights reserved.
//

#import "GALBaseModel.h"

@interface UserModel : GALBaseModel

@property (strong, nonatomic) NSString *uuid;
@property (strong, nonatomic) NSString *user_name;
@property (strong, nonatomic) NSString *img_url;
@property (strong, nonatomic) NSString *bg_img_url;
@property (strong, nonatomic) NSString *longitude;
@property (strong, nonatomic) NSString *latitude;
@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSString *geonameId;
@property (strong, nonatomic) NSString *state_id;
@property (strong, nonatomic) NSString *state_name;
@property (strong, nonatomic) NSString *suburb_id;
@property (strong, nonatomic) NSString *suburb_name;
@property (strong, nonatomic) NSString *status_message;
@property (strong, nonatomic) NSString *friend_count;
@property (strong, nonatomic) NSString *create_datetime;
@property (strong, nonatomic) NSString *is_friend;


@property (assign, nonatomic) int beacon_count;
@property (assign, nonatomic) int bunnyzone_count;
@property (assign, nonatomic) float distance;

@property (strong, nonatomic) NSString *manage_type;
@property (strong, nonatomic) NSString *friend_uuid;

@end
