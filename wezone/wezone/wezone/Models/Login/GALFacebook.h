//
//  GALFacebook.h
//  Langtudy
//
//  Created by SinSuMin on 2016. 8. 16..
//  Copyright © 2016년 galuster. All rights reserved.
//


@interface GALFacebook : GALBaseModel
@property (strong, nonatomic) NSString *userId;
@property (strong, nonatomic) NSString *first_name;
@property (strong, nonatomic) NSString *last_name;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *link;
@property (strong, nonatomic) NSString *photo_url;
@property (strong, nonatomic) NSString *email;
@end
