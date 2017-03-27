//
//  GALBaseModel_GALServerInfo.h
//  Langtudy
//
//  Created by SinSuMin on 2016. 2. 11..
//  Copyright © 2016년 galuster. All rights reserved.
//

#import "GALBaseModel.h"

@interface GALServerInfo : GALBaseModel

@property (strong, nonatomic) NSString *xmpp_server_ip;
@property (strong, nonatomic) NSString *xmpp_server_port;
@property (strong, nonatomic) NSString *xmpp_server_dns;
@property (strong, nonatomic) NSString *xmpp_user_id;
@property (strong, nonatomic) NSString *xmpp_user_passwd;
@property (strong, nonatomic) NSString *turn_server_ip;
@property (strong, nonatomic) NSString *turn_server_port;
@property (strong, nonatomic) NSString *turn_server_dns;
@property (strong, nonatomic) NSString *turn_user_id;
@property (strong, nonatomic) NSString *turn_user_passwd;
@property (strong, nonatomic) NSString *stun_server_ip;
@property (strong, nonatomic) NSString *stun_server_port;
@property (strong, nonatomic) NSString *stun_server_dns;
@end
