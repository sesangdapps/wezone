//
//  GALGoogle.h
//  Langtudy
//
//  Created by SinSuMin on 2016. 8. 16..
//  Copyright © 2016년 galuster. All rights reserved.
//

@interface GALGoogle : GALBaseModel
@property (strong, nonatomic) NSString *userId;
@property (strong, nonatomic) NSString *idToken;
@property (strong, nonatomic) NSString *fullName;
@property (strong, nonatomic) NSString *givenName;
@property (strong, nonatomic) NSString *familyName;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *imgUrl;
@end
