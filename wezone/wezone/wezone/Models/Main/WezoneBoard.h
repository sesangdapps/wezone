//
//  WezoneBoard.h
//  wezone
//
//  Created by Kim Sunmi on 2017. 3. 19..
//  Copyright © 2017년 Kim Sunmi. All rights reserved.
//

#import "GALBaseModel.h"

@interface WezoneBoardFile : GALBaseModel

@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSString *format;

@end

@interface WezoneBoard : GALBaseModel

@property (strong, nonatomic) NSString *board_id;
@property (strong, nonatomic) NSString *wezone_id;
@property (strong, nonatomic) NSString *uuid;
@property (strong, nonatomic) NSString *notice_flag;
@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) NSString *user_name;
@property (strong, nonatomic) NSString *img_url;
@property (strong, nonatomic) NSString *create_datetime;
@property (strong, nonatomic) NSString *update_datetime;
@property (strong, nonatomic) NSArray *board_file;
@property (strong, nonatomic) NSMutableArray *comments;
@property (assign, nonatomic) int comment_count;

@end
