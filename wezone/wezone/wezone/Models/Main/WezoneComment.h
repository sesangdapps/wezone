//
//  WezoneComment.h
//  wezone
//
//  Created by Kim Sunmi on 2017. 3. 17..
//  Copyright © 2017년 Kim Sunmi. All rights reserved.
//

#import "GALBaseModel.h"

@interface WezoneComment : GALBaseModel

@property (strong, nonatomic) NSString *comment_id;
@property (strong, nonatomic) NSString *wezone_id;
@property (strong, nonatomic) NSString *uuid;
@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSString *board_id;
@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) NSString *user_name;
@property (strong, nonatomic) NSString *img_url;
@property (strong, nonatomic) NSString *create_datetime;
@property (strong, nonatomic) NSString *update_datetime;

@end
