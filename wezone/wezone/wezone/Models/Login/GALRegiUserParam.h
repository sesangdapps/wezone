//
//  GALRegiUserParam.h
//  Langtudy
//
//  Created by SinSuMin on 2016. 8. 16..
//  Copyright © 2016년 galuster. All rights reserved.
//


@interface GALRegiUserParam : GALBaseModel
@property (strong, nonatomic) NSString *provider_type;
@property (strong, nonatomic) NSString *provider_id;
@property (strong, nonatomic) NSString *provider_email;
@property (strong, nonatomic) NSString *provider_img;
@property (strong, nonatomic) NSString *login_id;
@property (strong, nonatomic) NSString *login_passwd;
@property (strong, nonatomic) NSString *user_name;
//@property (strong, nonatomic) NSString *user_sys_lang;
//@property (strong, nonatomic) NSString *user_gender;
@property (strong, nonatomic) NSString *longitude;
@property (strong, nonatomic) NSString *latitude;
//@property (strong, nonatomic) NSString *continentCode;
//@property (strong, nonatomic) NSString *user_localtime_gmt;
//@property (strong, nonatomic) NSString *country_id;
//@property (strong, nonatomic) NSString *country_name;
//@property (strong, nonatomic) NSString *state_id;
//@property (strong, nonatomic) NSString *state_name;
//@property (strong, nonatomic) NSString *is_search_teach;
//@property (strong, nonatomic) NSMutableArray *languages;
@end
