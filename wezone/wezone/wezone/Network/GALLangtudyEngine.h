//
//  GALangtudyEngine.h
//  Langtudy
//
//  Created by SinSuMin on 2015. 9. 1..
//  Copyright (c) 2015년 galuster. All rights reserved.
//

#import "GALBaseEngineAF.h"

#import "GALServerInfo.h"
#import "GALUserInfo.h"

//#import "GALCallOption.h"

////cm
//#import "GALLocateInfo.h"
//#import "GALGeonames.h"
//
//#import "GALAdvert.h"
//
////--login
#import "GALLogin.h"
#import "GALRegiUserParam.h"

// main
#import "WezoneModel.h"
#import "WezoneComment.h"
#import "WezoneBoard.h"
#import "UserModel.h"

//
//#import "GALPayInfo.h"
//
////main
//#import "GALMainParam.h"
//
//
////favorite
//#import "GALFavoriteParam.h"
//#import "GALFavoriteEditParam.h"
//
//#import "GALFavoriteDeleteParam.h"
//
////message
//#import "GALMessageParam.h"
//#import "GALMessageUser.h"
//
//#import "GALMessageListParam.h"
//#import "GALMessage.h"
//
//#import "GALOtherUser.h"
//
//
////pay
//#import "GALPayParam.h"
//#import "GALLangCoin.h"
//
//#import "GALExchangeParam.h"
//
////review
//#import "GALReviewParam.h"
//#import "GALReview.h"
//
//#import "GALReviewPostParam.h"
//
//#import "GALTimeTable.h"
//
//#import "GALScheduleParam.h"
//
//#import "GALSchedulePostParam.h"
//#import "GALSchedulePostTempParam.h"
//
//
//#import "GALScheduleItem.h"
//#import "GALBookInputItem.h"

#ifndef Langtudy_GALangtudyEngine_h
#define Langtudy_GALangtudyEngine_h

@interface GALMultiPartData : NSObject

@property (nonatomic, strong, readonly) NSData *data;
@property (nonatomic, strong, readonly) NSString *fileName;
@property (nonatomic, strong, readonly) NSString *mimeType;
- (id)initWithFileData:(NSData *)fileData fileName:(NSString *)fileName mimeType:(NSString *)mimeType;

@end


@interface GALLangtudyEngine : GALBaseEngineAF
{
    int retryCount; //2014-10-10 by KimES 전문연동 실패시 재시도 카운트
}
+ (instancetype)sharedEngine;

+ (BOOL)convertFlag:(NSString *)flag;

+ (NSString *)convertBool:(BOOL)b;

typedef void (^idBlock)(NSString *_id);
typedef void (^resultBlock)();
typedef void (^listBlock)(int total_count, NSArray *list);

#pragma mark - 서버정보


//typedef void (^serverInfoBlock)(GALServerInfo *serverInfo);
//- (GALRequestOperation *)requestServerInfo:(serverInfoBlock)resultBlock errorHandler:(GALErrorBlock)errorBlock;
//
//#pragma mark - 유저 정보
//
//typedef void (^userListBlock)(NSArray *userList);
//- (GALRequestOperation *)requestUserList:(userListBlock)resultBlock errorHandler:(GALErrorBlock)errorBlock;
//
//
//typedef void (^userBlock)(GALUserInfo *userInfo);
//- (GALRequestOperation *)requestUserInfo:(NSString *)user_uuid OtherUuid:(NSString *)other_uuid SystemLang:(NSString *) sys_lang LangCode:(NSString *)lang_code LangMode:(NSString *)lang_mode resultHandler:(userBlock)resultBlock errorHandler:(GALErrorBlock)errorBlock;
//
//
//typedef void (^userDeleteBlock)();
//- (GALRequestOperation *)deleteUser:(NSString*) user_uuid resultHandler:(userDeleteBlock)resultBlock errorHandler:(GALErrorBlock)errorBlock;
//
//typedef void (^userPartBlock)();
//- (GALRequestOperation *)updateUserPart:(NSString*) user_uuid Type:(NSString *)type Data:(NSObject *)data resultHandler:(userPartBlock)resultBlock errorHandler:(GALErrorBlock)errorBlock;
//
//typedef void (^userFileBlock)();
//- (GALRequestOperation *)updateUserFile:(NSString*) user_uuid Flag:(NSString *)flag Url:(NSObject *)url resultHandler:(userFileBlock)resultBlock errorHandler:(GALErrorBlock)errorBlock;
//
//#pragma mark - 공통
//
//#pragma mark 위치정보
//typedef void (^locateBlock)(NSArray *geoList);
//- (GALRequestOperation *)requestLocate:(NSString *)sys_lang resultHandler:(locateBlock)resultBlock errorHandler:(GALErrorBlock)errorBlock;
//
//
//typedef void (^userStatusBlock)(NSString *user_uuid, NSString *remains);
//- (GALRequestOperation *)updateUserStatusithUserUuid:(NSString *)user_uuid UserState:(NSString *)user_status OtherUuid:(NSString *)other_user_uuid CallOption:(GALCallOption *)call_option resultHandler:(userStatusBlock)resultBlock errorHandler:(GALErrorBlock)errorBlock;
//
//typedef void (^interestBlock)(NSArray *interestList);
//- (GALRequestOperation *)requestInterestList:(NSString *)user_uuid UseLang:(NSString *)use_lang resultHandler:(interestBlock)resultBlock errorHandler:(GALErrorBlock)errorBlock;
//
//
//typedef void (^sendMailBlock)();
//- (GALRequestOperation *)updateHelpMail:(NSString *)user_uuid Title:(NSString *)title Contents:(NSString *)contents resultHandler:(sendMailBlock)resultBlock errorHandler:(GALErrorBlock)errorBlock;
//
//
//typedef void (^advertBlock)(NSArray *advertList);
//- (GALRequestOperation *)requestAdvert:(NSString *)user_uuid Language:(NSString *)lang resultHandler:(advertBlock)resultBlock errorHandler:(GALErrorBlock)errorBlock;

#pragma mark - 인증

typedef void (^loginBlock)(GALServerInfo *serverInfo, GALUserInfo *userInfo, NSMutableArray *payInfoList, NSString* email_auth);
- (GALRequestOperation *)requestLogin:(GALLoginParam *)loginData resultHandler:(loginBlock)resultBlock errorHandler:(GALErrorBlock)errorBlock;

- (GALRequestOperation *)requestLogout:(resultBlock)resultBlock errorHandler:(GALErrorBlock)errorBlock;

typedef void (^checkMailBlock)();
- (GALRequestOperation *)requestCheckMail:(NSString *)mail resultHandler:(checkMailBlock)resultBlock errorHandler:(GALErrorBlock)errorBlock;


typedef void (^regiUserBlock)(NSString *user_uuid);
- (GALRequestOperation *)requestRegiUser:(GALRegiUserParam *)regiParam resultHandler:(regiUserBlock)resultBlock errorHandler:(GALErrorBlock)errorBlock;


typedef void (^sendFindpasswdrBlock)();
- (GALRequestOperation *)sendFindPasswd:(NSString *)email resultHandler:(sendFindpasswdrBlock)resultBlock errorHandler:(GALErrorBlock)errorBlock;


typedef void (^sendCodeBlock)();
- (GALRequestOperation *)sendCheckCode:(NSString *)email withCode:(NSString *)code withPass:(NSString *)pw resultHandler:(sendFindpasswdrBlock)resultBlock errorHandler:(GALErrorBlock)errorBlock;

#pragma mark - 유저

typedef void (^userBlock)(UserModel *user);
- (GALRequestOperation *)getUserInfo:(NSString *)other_uuid longitude:(NSString *)longitude latitude:(NSString *)latitude resultHandler:(userBlock)resultBlock errorHandler:(GALErrorBlock)errorBlock;

- (GALRequestOperation *)sendModifyUserInfo:(NSString *)uuid flag:(NSString *)flag val:(NSString *)val resultHandler:(resultBlock)resultBlock errorHandler:(GALErrorBlock)errorBlock;

- (GALRequestOperation *)getWezoneMemberList:(NSString *)zone_id zone_type:(NSString *)zone_type longitude:(NSString *)longitude latitude:(NSString *)latitude offset:(int)offset limit:(int)limit resultHandler:(listBlock)resultBlock errorHandler:(GALErrorBlock)errorBlock;

- (GALRequestOperation *)sendAddFriend:(NSString *)other_uuid resultHandler:(resultBlock)resultBlock errorHandler:(GALErrorBlock)errorBlock;

#pragma mark - 위존

typedef void (^wezoneBlock)(WezoneModel *wezone);

- (GALRequestOperation *)getWezone:(NSString *)wezone_id withLongitude:(NSString *)longitude withLatitude:(NSString *)latitude resultHandler:(wezoneBlock)resultBlock errorHandler:(GALErrorBlock)errorBlock;

- (GALRequestOperation *)sendRegistWezone:(WezoneModel *)wezone resultHandler:(idBlock)resultBlock errorHandler:(GALErrorBlock)errorBlock;

- (GALRequestOperation *)sendModifyWezone:(NSString *)wezone_id wezone_info:(NSArray *)wezone_info resultHandler:(resultBlock)resultBlock errorHandler:(GALErrorBlock)errorBlock;


- (GALRequestOperation *)getMyWezoneList:(NSString *)other_uuid longitude:(NSString *)longitude withLatitude:(NSString *)latitude resultHandler:(listBlock)resultBlock errorHandler:(GALErrorBlock)errorBlock;

- (GALRequestOperation *)getWezoneList:(NSString *)longitude latitude:(NSString *)latitude resultHandler:(listBlock)resultBlock errorHandler:(GALErrorBlock)errorBlock;

- (GALRequestOperation *)getWezoneList:(NSString *)search_type keyword:(NSString *)keyword longitude:(NSString *)longitude latitude:(NSString *)latitude offset:(int)offset limit:(int)limit resultHandler:(listBlock)resultBlock errorHandler:(GALErrorBlock)errorBlock;

- (GALRequestOperation *)getWezoneHashtag:(listBlock)resultBlock errorHandler:(GALErrorBlock)errorBlock;

- (GALRequestOperation *)sendWezoneJoin:(NSString *)wezone_id flag:(NSString *)flag resultHandler:(resultBlock)resultBlock errorHandler:(GALErrorBlock)errorBlock;


- (GALRequestOperation *)getWezoneCommentList:(NSString *)wezone_id type:(NSString *)type board_id:(NSString *)board_id offset:(int)offset limit:(int)limit resultHandler:(listBlock)resultBlock errorHandler:(GALErrorBlock)errorBlock;


- (GALRequestOperation *)getWezoneBoardList:(NSString *)wezone_id offset:(int)offset limit:(int)limit resultHandler:(listBlock)resultBlock errorHandler:(GALErrorBlock)errorBlock;

typedef void (^boardBlock)(WezoneBoard *board);
- (GALRequestOperation *)getWezoneBoard:(NSString *)board_id resultHandler:(boardBlock)resultBlock errorHandler:(GALErrorBlock)errorBlock;

- (GALRequestOperation *)sendRegistComment:(NSString *)wezone_id type:(NSString *)type board_id:(NSString *)board_id content:(NSString *)content resultHandler:(resultBlock)resultBlock errorHandler:(GALErrorBlock)errorBlock;

- (GALRequestOperation *)sendModifyComment:(NSString *)comment_id content:(NSString *)content resultHandler:(resultBlock)resultBlock errorHandler:(GALErrorBlock)errorBlock;

- (GALRequestOperation *)sendDeleteComment:(NSString *)comment_id resultHandler:(resultBlock)resultBlock errorHandler:(GALErrorBlock)errorBlock;


typedef void (^boardIdBlock)(NSInteger board_id);
- (GALRequestOperation *)sendRegistBoard:(NSString *)wezone_id notice_flag:(NSString *)notice_flag content:(NSString *)content url:(NSString *)url resultHandler:(boardIdBlock)resultBlock errorHandler:(GALErrorBlock)errorBlock;

- (GALRequestOperation *)sendModifyBoard:(NSString *)board_id put_flag:(NSString *)put_flag notice_flag:(NSString *)notice_flag content:(NSString *)content url:(NSString *)url resultHandler:(resultBlock)resultBlock errorHandler:(GALErrorBlock)errorBlock;

- (GALRequestOperation *)sendDeleteBoard:(NSString *)board_id resultHandler:(resultBlock)resultBlock errorHandler:(GALErrorBlock)errorBlock;

#pragma mark - image
typedef void (^GALImageBlock)(UIImage *image, BOOL isInCache);
- (GALRequestOperation *)getImageWithUrl:(NSString *)url completionHandler:(GALImageBlock)imageBlock errorHandler:(GALErrorBlock)errorBlock;

typedef void (^uploadImageBlock)(NSString *imageUrl);
- (GALRequestOperation *)uploadImage:(UIImage *)image withUuid:(NSString *)user_uuid type:(NSString *)type id:(NSString *)id status:(NSString *)status resultHandler:(uploadImageBlock)resultBlock errorHandler:(GALErrorBlock)errorBlock;

//typedef void (^GALAudioBlock)(NSData *audio);
//- (GALRequestOperation *)getFileWithUrl:(NSString *)url completionHandler:(GALAudioBlock)imageBlock errorHandler:(GALErrorBlock)errorBlock;
//
//typedef void (^uploadFileBlock)(NSString *fileUrl);
//- (GALRequestOperation *)uploadFile:(NSData *)fileData withUuid:(NSString *)user_uuid resultHandler:(uploadFileBlock)resultBlock errorHandler:(GALErrorBlock)errorBlock;
//
//#pragma mark - Main
//typedef void (^mainBlock)(NSString *total_count, NSArray *userList);
//- (GALRequestOperation *)requestMainList:(GALMainParam *)mainParam resultHandler:(mainBlock)resultBlock errorHandler:(GALErrorBlock)errorBlock;
//
//
//#pragma mark - Favorite
//typedef void (^favoriteBlock)(NSString *total_count, NSArray *userList);
//- (GALRequestOperation *)requestFavoriteList:(GALFavoriteParam *)favoriteParam resultHandler:(favoriteBlock)resultBlock errorHandler:(GALErrorBlock)errorBlock;
//
//
//typedef void (^favoriteEditBlock)();
//- (GALRequestOperation *)registFavorite:(GALFavoriteEditParam *)favoriteEditParam resultHandler:(favoriteEditBlock)resultBlock errorHandler:(GALErrorBlock)errorBlock;
//
//- (GALRequestOperation *)deleteFavorite:(GALFavoriteEditParam *)favoriteEditParam resultHandler:(favoriteEditBlock)resultBlock errorHandler:(GALErrorBlock)errorBlock;
//
//- (GALRequestOperation *)deleteFavoriteList:(NSString *)user_uuid Ids:(NSArray *)ids resultHandler:(favoriteEditBlock)resultBlock errorHandler:(GALErrorBlock)errorBlock;
//
//
//#pragma mark - Message
//typedef void (^messageBlock)(NSString *total_count, NSArray *messageUserList);
//- (GALRequestOperation *)requestMessageUserList:(GALMessageParam *)messageParam resultHandler:(messageBlock)resultBlock errorHandler:(GALErrorBlock)errorBlock;
//
//
//typedef void (^messageListBlock)(NSString *total_count, GALOtherUser *obj_other_user, NSArray *messageList);
//- (GALRequestOperation *)requestMessageList:(GALMessageListParam *)messageListParam resultHandler:(messageListBlock)resultBlock errorHandler:(GALErrorBlock)errorBlock;
//
//
//typedef void (^messageDeleteBlock)();
//- (GALRequestOperation *)deleteMessageList:(NSString *)user_uuid Ids:(NSArray *)other_user_ids resultHandler:(messageDeleteBlock)resultBlock errorHandler:(GALErrorBlock)errorBlock;
//
//
//#pragma mark - Pay
//typedef void (^payBlock)(NSString *langcoind_count, NSString *cashout_flag, NSString *total_count, NSArray *langCoinList);
//- (GALRequestOperation *)requestPayList:(GALPayParam *)payParam resultHandler:(payBlock)resultBlock errorHandler:(GALErrorBlock)errorBlock;
//
//
//typedef void (^exchangeBlock)();
//- (GALRequestOperation *)exchangeWithParam:(GALExchangeParam *)exchangeParam resultHandler:(exchangeBlock)resultBlock errorHandler:(GALErrorBlock)errorBlock;
//
//
//#pragma mark - Review
//typedef void (^reviewBlock)(NSString *total_count, NSArray *reviewList);
//- (GALRequestOperation *)requestReviewList:(GALReviewParam *)reviewParam resultHandler:(reviewBlock)resultBlock errorHandler:(GALErrorBlock)errorBlock;
//
//typedef void (^reviewPostBlock)();
//- (GALRequestOperation *)updateReview:(GALReviewPostParam *)reviewPostParam resultHandler:(reviewPostBlock)resultBlock errorHandler:(GALErrorBlock)errorBlock;
//
//
//
//#pragma mark - Schedule
//typedef void (^scheduleBlock)(NSString *total_count, NSString *remain_count, NSArray *scheduleList);
//- (GALRequestOperation *)requestScheduleList:(GALScheduleParam *)scheduleParam resultHandler:(scheduleBlock)resultBlock errorHandler:(GALErrorBlock)errorBlock;
//
//typedef void (^schedulePostBlock)(NSString *langcoin_id);
//- (GALRequestOperation *)registSchedule:(GALSchedulePostParam *)scheduleParam resultHandler:(schedulePostBlock)resultBlock errorHandler:(GALErrorBlock)errorBlock;
//
//- (GALRequestOperation *)registScheduleTemp:(GALSchedulePostTempParam *)scheduleParam resultHandler:(schedulePostBlock)resultBlock errorHandler:(GALErrorBlock)errorBlock;
//
//typedef void (^scheduleDeleteBlock)(NSString *schedule_id);
//- (GALRequestOperation *)deleteSchedule:(NSString *)user_uuid ScheduleId:(NSString *)scheduleId ScheduleState:(NSString *)schedule_state LangcoinSessionId:(NSString *)langcoin_sessionId ReasonId:(NSString *)sc_del_reason_id resultHandler:(scheduleDeleteBlock)resultBlock errorHandler:(GALErrorBlock)errorBlock;
//
//#pragma mark - TimeTable
//typedef void (^timeTableBlock)(NSString *total_count, NSArray *timetableList);
//- (GALRequestOperation *)requestTimeTableList:(NSString *)user_uuid SearchUuid:(NSString *)search_uuid resultHandler:(timeTableBlock)resultBlock errorHandler:(GALErrorBlock)errorBlock;
//
//
//typedef void (^timeTableDeleteBlock)();
//- (GALRequestOperation *)deleteTimeTableList:(NSString *)user_uuid Flag:(NSString *)flag TimeTableId:(NSString *)timetable_id resultHandler:(timeTableDeleteBlock)resultBlock errorHandler:(GALErrorBlock)errorBlock;
//
//typedef void (^timeTableRegistBlock)();
//- (GALRequestOperation *)registTimeTableList:(NSString *)user_uuid TimeTable:(NSArray *)timetable resultHandler:(timeTableRegistBlock)resultBlock errorHandler:(GALErrorBlock)errorBlock;
//
//#pragma mark - setting
//typedef void (^settingBlock)();
//
//- (GALRequestOperation *)updateNationality:(NSString *)user_uuid Country:(NSString *)country resultHandler:(settingBlock)resultBlock errorHandler:(GALErrorBlock)errorBlock;
//
//- (GALRequestOperation *)updateGender:(NSString *)user_uuid Gender:(NSString *)gender resultHandler:(settingBlock)resultBlock errorHandler:(GALErrorBlock)errorBlock;
//
//- (GALRequestOperation *)updateSearch:(NSString *)user_uuid IsTeachSearch:(NSString *)is_teach_search IsLearnSearch:(NSString *)is_learn_search resultHandler:(settingBlock)resultBlock errorHandler:(GALErrorBlock)errorBlock;
//
//- (GALRequestOperation *)updateNotification:(NSString *)user_uuid IsNoticeMessage:(NSString *)is_notice_message IsNoticeEmail:(NSString *)is_notice_email resultHandler:(settingBlock)resultBlock errorHandler:(GALErrorBlock)errorBlock;
@end

#endif
