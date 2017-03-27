//
//  GALLogin.h
//  Langtudy
//
//  Created by SinSuMin on 2016. 8. 10..
//  Copyright © 2016년 galuster. All rights reserved.
//

#import "GALUserInfo.h"
#import "GALLoginParam.h"
#import "GALServerInfo.h"
//#import "GALPayInfo.h"


@interface GALLogin : GALBaseModel

@property (strong, nonatomic) GALLoginParam *loginParam;

//input data
//@property (strong, nonatomic) NSString *provider_type;
//@property (strong, nonatomic) NSString *device_id;
//
//@property (strong, nonatomic) NSString *provider_id;
//
//@property (strong, nonatomic) NSString *provider_email;
//@property (strong, nonatomic) NSString *provider_img;
//@property (strong, nonatomic) NSString *login_id;
//@property (strong, nonatomic) NSString *login_passwd;
//@property (strong, nonatomic) NSString *user_name;
////@property (strong, nonatomic) NSString *user_sys_lang;
////@property (strong, nonatomic) NSString *user_gender;
//@property (strong, nonatomic) NSString *longitude;
//@property (strong, nonatomic) NSString *latitude;

@property (strong, nonatomic) NSString *user_sys_lang;
@property (strong, nonatomic) NSString *user_gender;
@property (strong, nonatomic) NSString *user_name;
@property (strong, nonatomic) NSString *user_longitude;
@property (strong, nonatomic) NSString *user_latitude;
@property (strong, nonatomic) NSString *user_localtime_gmt;
@property (strong, nonatomic) NSString *countryId;
@property (strong, nonatomic) NSString *countryName;
@property (strong, nonatomic) NSString *stateId;
@property (strong, nonatomic) NSString *stateName;
@property (strong, nonatomic) NSString *continentCode;

//output data
@property (strong, nonatomic) GALUserInfo *user_info;
@property (strong, nonatomic) GALServerInfo *server_info;

//@property (strong, nonatomic) GALPayInfo *pay_info;

@property (strong, nonatomic) NSString *email_auth;


@end
