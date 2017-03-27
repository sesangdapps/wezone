//
//  GALPushData.h
//  Langtudy
//
//  Created by SinSuMin on 2016. 10. 18..
//  Copyright © 2016년 galuster. All rights reserved.
//

#ifndef GALPushData_h
#define GALPushData_h

@interface GALPushData : GALBaseModel

@property (strong, nonatomic) NSString *message;

@property (strong, nonatomic) NSString *item_id;
@property (strong, nonatomic) NSString *receiver_id;
@property (strong, nonatomic) NSString *send_type;
@property (strong, nonatomic) NSString *sender_id;
@property (strong, nonatomic) NSString *sender_name;
@property (strong, nonatomic) NSString *sender_url;
@property (strong, nonatomic) NSString *type;


@property (strong, nonatomic) NSString *lang_code;
@property (strong, nonatomic) NSString *langcoin_id;
@property (strong, nonatomic) NSString *schedule_date;
@property (strong, nonatomic) NSString *schedule_id;
@property (strong, nonatomic) NSString *schedule_item_cnt;
@property (strong, nonatomic) NSString *send_time;
@property (strong, nonatomic) NSString *time;
@property (strong, nonatomic) NSString *used_cost;

@end

#endif /* GALPushData_h */
