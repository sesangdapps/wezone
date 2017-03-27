//
//  GALHomeNaviController.h
//  Langtudy
//
//  Created by SinSuMin on 2016. 8. 9..
//  Copyright © 2016년 galuster. All rights reserved.
//

@interface GALLoginNaviController : UINavigationController <UINavigationControllerDelegate>

@property (strong, nonatomic) NSString *provideType;

@property (strong, nonatomic) NSString *provideImgUrl;

@property (strong, nonatomic) GALGoogle *googleData;
@property (strong, nonatomic) GALFacebook *facebookData;

@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *pass;

//@property (strong, nonatomic) GALLangData *learnLang;
//@property (strong, nonatomic) GALLangData *teachLang;

@property (strong, nonatomic) NSString *isSearch;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *gender;


- (void) setProgressLayout:(UIView *)progressView withBg:(UIImageView *)progressBg withTotalCount:(NSInteger)totalCnt withCount:(NSInteger)cnt;
@end
