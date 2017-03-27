//
//  GALBaseModel_GALUserInfo.h
//  Langtudy
//
//  Created by SinSuMin on 2016. 2. 11..
//  Copyright © 2016년 galuster. All rights reserved.
//

#import "GALBaseModel.h"
//#import "GALInterest.h"
//#import "GALInterestUser.h"

@interface GALUserInfo : GALBaseModel
//@property (strong, nonatomic) NSString *user_uuid;
//@property (strong, nonatomic) NSString *user_name;
//@property (strong, nonatomic) NSString *user_gender;
//@property (strong, nonatomic) NSString *user_status;
//@property (strong, nonatomic) NSString *user_img_url;
//@property (strong, nonatomic) NSString *user_video_url;
//@property (strong, nonatomic) NSString *user_audio_url;
//@property (strong, nonatomic) NSString *user_cost;
//@property (strong, nonatomic) NSString *is_search_learn;
//@property (strong, nonatomic) NSString *is_search_teach;
//@property (strong, nonatomic) NSString *user_score;
//@property (strong, nonatomic) NSString *user_score_cnt;
//@property (strong, nonatomic) NSString *user_recommend_cnt;
//@property (strong, nonatomic) NSString *user_sys_lang;
//@property (strong, nonatomic) NSString *user_country;
//@property (strong, nonatomic) NSString *user_longitude;
//@property (strong, nonatomic) NSString *user_latitude;
//@property (strong, nonatomic) NSString *user_localtime_gmt;
//@property (strong, nonatomic) NSString *countryname;
//@property (strong, nonatomic) NSString *country_id;
//@property (strong, nonatomic) NSString *statename;
//@property (strong, nonatomic) NSString *state_id;
//@property (strong, nonatomic) NSString *user_introduction;
//@property (strong, nonatomic) NSString *is_notice_message;
//@property (strong, nonatomic) NSString *is_notice_email;
//@property (strong, nonatomic) NSString *schedule_count;
//@property (strong, nonatomic) NSString *langcoin_count;
//@property (strong, nonatomic) NSString *lang_code;
//@property (strong, nonatomic) NSString *lang_mode;
//@property (strong, nonatomic) NSString *favorite_flag;



//@property (strong, nonatomic) NSMutableArray *interests;
//@property (strong, nonatomic) NSMutableArray *languages;

//@property (nonatomic) BOOL isSelected;


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
@property (strong, nonatomic) NSString *beacon_count;
@property (strong, nonatomic) NSString *bunnyzone_count;
@property (strong, nonatomic) NSString *friend_count;
@property (strong, nonatomic) NSString *create_datetime;

@end
