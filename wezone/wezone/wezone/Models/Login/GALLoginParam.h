//
//  GALLoginParam.h
//  Langtudy
//
//  Created by SinSuMin on 2016. 8. 10..
//  Copyright © 2016년 galuster. All rights reserved.
//


@interface GALLoginParam : GALBaseModel

@property (strong, nonatomic) NSString *provider_type;
@property (strong, nonatomic) NSString *device_id;
@property (strong, nonatomic) NSString *push_token;
@property (strong, nonatomic) NSString *device_model;
@property (strong, nonatomic) NSString *device_os_type;
@property (strong, nonatomic) NSString *device_os_ver;
@property (strong, nonatomic) NSString *device_app_ver;
//@property (strong, nonatomic) NSString *langtudy_id;
//@property (strong, nonatomic) NSString *langtudy_password;
@property (strong, nonatomic) NSString *provider_id;
@property (strong, nonatomic) NSString *provider_email;
@property (strong, nonatomic) NSString *login_id;
@property (strong, nonatomic) NSString *login_passwd;

@property (strong, nonatomic) NSString *latitude;
@property (strong, nonatomic) NSString *longitude;
@property (strong, nonatomic) NSString *user_uuid;
@property (strong, nonatomic) NSString *sys_lang;
@end
