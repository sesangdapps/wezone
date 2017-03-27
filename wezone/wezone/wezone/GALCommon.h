//
//  GALCommon.h
//  Langtudy
//
//  Created by SinSuMin on 2015. 9. 1..
//  Copyright (c) 2015년 galuster. All rights reserved.
//

#ifndef Langtudy_GALCommon_h
#define Langtudy_GALCommon_h

#import "GALBaseModel.h"
#import "GALLangtudyEngine.h"

#import "GALAlertView.h"
#import "GALActivityIndicator.h"
#import "GALangtudyUtils.h"
#import "GALDateUtils.h"
//
//#import "GALLangData.h"
//
#import "GALangtudyUtils.h"

#import "GALGoogle.h"
#import "GALFacebook.h"

#import "UIImageView+GALLangtudyEngine.h"

#import "NSString+BDBase64.h"

#import "UIBarButtonItem+Badge.h"

#import "Layout.h"
#import "Style.h"

#import "CommonUtil.h"

#import "LocationManager.h"

#define GOOGLE_API_SCOPE_PLUS_ME @"https://www.googleapis.com/auth/plus.me"
#define GOOGLE_API_SCOPE_YOUTUBE @"https://www.googleapis.com/auth/youtube"
#define GOOGLE_API_SCOPE_YOUTUBE_UPLOAD @"https://www.googleapis.com/auth/auth/youtube.upload"
//
#define kClientID @"338438030889-2hslbp3vo63csv7u9kdtahd4i4stspbs.apps.googleusercontent.com"
//
////------------------------- 시스템 환경 -------------------------
//#define IS_DEV 0
//#if IS_DEV
//// 테스트




//#define SERVICE_HOST_NAME                   @"https://lang-stage.langtudy.com"
#define SERVICE_HOST_NAME                   @"https://wezone1.langtudy.co.kr"
#define SERVICE_FILE_URL                    @"https://img-stage.langtudy.com"
//#define XMPP_HOST_NAME                      @"104.45.156.246"
//#define XMPP_PORT                           5222
//
//#else
//// 운영
//#define SERVICE_HOST_NAME                   @"https://lang.langtudy.com"
//#define SERVICE_FILE_URL                    @"https://img.langtudy.com"
//#define XMPP_HOST_NAME                      @"104.45.156.246"
//#define XMPP_PORT                           5222
//
//#endif
////------------------------------------------------------------
//
#define RETRY_COUNT 3   //2014-10-10 by KimES 전문연동 실패시 재시도 카운트
#define ERROR_CODE 8500
#define SERVICE_SUCCESS_RESULT_NO           @"0000"
//
//#define LOCATE_URL @"http://api.geonames.org/findNearbyJSON?"
//
#define NETURL_TERMS_OF_SERVICE @"https://www.langtudy.com/privacy_kor.html"
//
//#define NETURL_PAY @"https://www-stage.langtudy.com/pay/pay_flat.php"
//
//#define NETURL_PAY_WITH_RESERVATION @"https://www-stage.langtudy.com/pay/pay.php"
//
//#define NETURL_FAQ @"https://www-stage.langtudy.com/support_%@.html"
//
//
#define NETURL_FACEBOOK @"https://www.facebook.com/langtudy/"
#define NETURL_INSTART @"https://www.instagram.com/lets_langtudy/"
#define NETURL_NAVER @"http://blog.naver.com/langtudy"
#define NETURL_BLOG_SPOT @"https://langtudy.blogspot.com/"

#define NAVER_CLIENT_ID     @"ErSpklJXivadgvI7urOb"

//
////cm
//#define NETWORK_INTEREST @"cm/interests/"
//#define NETWORK_STATUS @"cm/status/"
//#define NETWORK_GEO @"cm/geo/"
//
//
////ur
//#define NETWORK_REGI_OAUTHUSER @"ur/oauthuser/"
//#define NETWORK_USER_GET @"ur/user/"
//#define NETWORK_USER_PUT @"ur/userp/"
//#define NETWORK_USER_DELETE @"ur/userd/"
//#define NETWORK_NEW_PASSWD @"ur/pw/"
//#define NETWORK_USER_PART @"ur/userppart/"
//#define NETWORK_USER_RGFILE @"ur/rgfile/"
//
////py
//#define NETWORK_PAY_LANGCOINHISTORY @"py/langcoinhistory/"
//#define NETWORK_PAY_EXCHANGE @"py/exchange/"
//
//login
#define NETWORK_REGI_USER @"/login/register/"
#define NETWORK_CHECK_MAIL @"/login/usermail/"
#define NETWORK_LOGIN @"/login/login/"
#define NETWORK_LOGOUT @"/login/logout/"

#define NETWORK_CHECK_CODE @"login/checkcode/"

#define NETWORK_FIND_PASSWD @"/email/send/"

#define NETWORK_USER @"/user/user/"

#define NETWORK_USERS @"/user/users/"

#define NETWORK_USERS_FRIEND @"/user/friend/"

// Wezone
#define NETWORK_WEZONE @"/wezone/wezone/"

#define NETWORK_MY_WEZONE @"/wezone/mywezone/"

#define NETWORK_WEZONE_LIST @"/wezone/wezones/"

#define NETWORK_MY_WEZONE_LIST @"/wezone/mywezones/"

#define NETWORK_WEZONE_COMMENT @"/wezone/comment/"

#define NETWORK_WEZONE_COMMENTS @"/wezone/comments/"

#define NETWORK_WEZONE_BOARD @"/wezone/board/"

#define NETWORK_WEZONE_BOARDS @"/wezone/boards/"

#define NETWORK_WEZONE_HASHTAGS @"/wezone/hashtags/"

//
//#define NETWORK_MAIL_HELP @"/email/help/"
//
////st
//#define NETWORK_UPDATE_NATIONALITY @"/st/nationality/"
//#define NETWORK_UPDATE_GENDER @"/st/gender/"
//#define NETWORK_UPDATE_LOCATION @"/st/location/"
//#define NETWORK_UPDATE_SEARCH @"/st/search/"
//#define NETWORK_UPDATE_NOTIFICATION @"st/notification/"
//
////sc
//#define NETWORK_GET_SCHEDULE @"/sc/schedule/"
//#define NETWORK_GET_SCHEDULES @"/sc/schedules/"
//#define NETWORK_POST_SCHEDUlES_TEMP @"/sc/schedulestemp/"
//#define NETWORK_POST_SCHEDULE @"/sc/schedules/"
//#define NETWORK_PUT_SCHEDULE @"/sc/schedule/"
//#define NETWORK_DELETE_SCHEDULE @"/sc/scheduled/"
//
////timetable
//
//#define NETWORK_GET_TIMETABLE @"/sc/timetable/"
//#define NETWORK_GET_TIMETABLES @"/sc/timetables/"
//#define NETWORK_POST_TIMETABLE @"/sc/timetable/"
//#define NETWORK_PUT_TIMETABLE @"/sc/timetablep/"
//#define NETWORK_DELETE_TIMETABLE @"/sc/timetabled/"
//
////ma
//#define NETWORK_MAIN_LIST @"/ma/mainlist/"
//#define NETWORK_MAIN_ADVERT @"/ma/advert/"
//
////ms
//#define NETWORK_GET_MESSAGE_USERLIST @"/ms/userlist/"
//#define NETWORK_DELETE_MESSAGE_USER @"ms/userd/"
//#define NETWORK_GET_MESSAGES @"/ms/messages/"
//
//
////rv
//#define NETWORK_GET_REVIEW @"/rv/reviews/"
//#define NETWORK_POST_REVIEW @"/rv/review/"
//#define NETWORK_PUT_REVIEW @"/rv/reviewp/"
//
////fv
//#define NETWORK_GET_FAVORITES @"/fv/favorites/"
//#define NETWORK_POST_FAVORITE @"/fv/favorite/"
//#define NETWORK_DELETE_FAVORITE @"/fv/favorited/"
//#define NETWORK_DELETE_FAVORITES @"/fv/favorited/"
//
#define NETWORK_IMAGEURL @"/file/upload?"
//#define NETWORK_FILEURL @"/file/do_upload?"
//
//#define CHAT_ADMIN_KEY @"langtudy"
//
//// UI
//#define SIDE_BTN_MENU_ANIMATION_DURATION    0.3f
//#define SIDE_BTN_MENU_PAN_GEST_WIDTH        60.f
//
// 주요 매크로

// iOS8 이상 여부
#define IS_IOS8_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8)

// iOS7 이상 여부
#define IS_IOS7_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)

// 3.5인치 여부
#define IS_3_5_INCH           CGSizeEqualToSize([UIScreen mainScreen].bounds.size, CGSizeMake(320, 480)) || CGSizeEqualToSize([UIScreen mainScreen].bounds.size, CGSizeMake(480, 320))

// 4인치 여부
#define IS_4_INCH           CGSizeEqualToSize([UIScreen mainScreen].bounds.size, CGSizeMake(320, 568)) || CGSizeEqualToSize([UIScreen mainScreen].bounds.size, CGSizeMake(568, 320))


// RGB
#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

// RGBA
#define UIColorFromRGBA(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF000000) >> 24))/255.0 \
green:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
blue:((float)((rgbValue & 0xFF00) >> 8)) /255.0 alpha:((float)(rgbValue & 0xFF))/255.0]
//
//// Color define
#define UIColor_main        UIColorFromRGB(0xffffff)

#define UIColor_navi        UIColorFromRGB(0x162133)

#define UIColor_text        UIColorFromRGB(0x212121)
#define UIColor_sub_text        UIColorFromRGB(0x757575)
#define UIColor_hint        UIColorFromRGB(0x9e9e9e)

#define UIColor_line        UIColorFromRGBA(0x9e9e9eaa)

#define STR(key)            NSLocalizedString(key, key)
//
//#define UIColor_blue01      UIColorFromRGB(0x0067ae)
//#define UIColor_blue02      UIColorFromRGB(0x2685b5)
//#define UIColor_blue03      UIColorFromRGB(0xa1d0f0)
//#define UIColor_blue04      UIColorFromRGB(0xe1f0f7)
//#define UIColor_gray_01     UIColorFromRGB(0xf0f0f0)
//#define UIColor_gray_02     UIColorFromRGB(0xededed)
//#define UIColor_gray_03     UIColorFromRGB(0xe6e6e6)
//#define UIColor_gray_04     UIColorFromRGB(0xe5e5e5)
//#define UIColor_gray_05     UIColorFromRGB(0xd9d9d9)
//#define UIColor_gray_06     UIColorFromRGB(0xc2c2c2)
//#define UIColor_gray_08     UIColorFromRGB(0xb2b2b2)
//#define UIColor_gray_09     UIColorFromRGB(0x999999)
//#define UIColor_gray_10     UIColorFromRGB(0x84888c)
//#define UIColor_gray_11     UIColorFromRGB(0x545e6e)
//#define UIColor_gray_12     UIColorFromRGB(0x7c8896)
//#define UIColor_gray_13     UIColorFromRGB(0xa2b5c0)
//#define UIColor_gray_14     UIColorFromRGB(0x283747)
//#define UIColor_white_01    UIColorFromRGB(0xffffff)
//#define UIColor_white_02    UIColorFromRGB(0xf9f9f9)
//#define UIColor_black_01    UIColorFromRGB(0x333333)
//#define UIColor_black_02    UIColorFromRGB(0x1a1a1a)
//#define UIColor_black       UIColorFromRGB(0x000000)
//#define UIColor_red_01      UIColorFromRGB(0xff0000)
//
//// 테이블 셀 선택한 색상
//#define UIColor_SelectedCell    UIColor_blue04
//
#define LSSTRING(str) NSLocalizedString(str, str)
//
//// 3.5인치 여부
//#define IS_3_5_INCH           CGSizeEqualToSize([UIScreen mainScreen].bounds.size, CGSizeMake(320, 480)) || CGSizeEqualToSize([UIScreen mainScreen].bounds.size, CGSizeMake(480, 320))
//
//
////랜덤 매크로
//#define RAND_FROM_TO(min, max) (min + arc4random_uniform(max - min + 1))
//
//
//설정 디파인
#define FONT_SIZE      @"FONT_SIZE"
//
//#define TABLE_CONTENT_OFFSETTOP  8.f
//
////네트웍 에러 디파인
#define LOGIN_ERROR_ID @"401001"                //ID/PW가 없음(값이 없을때)
#define LOGIN_ERROR_PW @"401002"                //PW가 틀림
#define LOGIN_ERROR_LANGTUDY @"401003"          //langtudy id를 통해 가입하는 유저. 가입유도
#define LOGIN_ERROR_TYPE @"401004"              //loginType 이 틀림 L/G/F 외의 값이 들어올때
#define LOGIN_ERROR_UUID @"401005"              //자동로그인용 uuid 틀림 or 없음
#define LOGIN_ERROR_PROVIDER @"401006"          //provider id 가 없음 OAuth 가입 유도
#define LOGIN_ERROR_EMAIL @"401007"             //존재하지 않는 이메일 (비밀번호 찾기 시도 시 )
#define LOGIN_ERROR_CODE @"401008"              //인증코드 틀림 (비밀번호 찾고 난 후 인증 시 )
#define LOGIN_ERROR_PW_FAIL @"401009"           //비밀번호 변경 실패 (새비밀번호 입력 시 )
#define LOGIN_ERROR_ALREADY_EMAIL @"401010"     //이미 가입된 메일
#define LOGIN_ERROR_ALREADY_REGI @"401011"      //다른 서비스로 가입 되어있음
//
//#define ERROR_NO_CHANGE @"300001"
//#define ERROR_ALREADY_REVIEW @"300002"
//#define ERROR_ALREADY_REFUND @"300003"
//
//
//#define MESSAGE_TYPE_CHAT @"0"
//#define MESSAGE_TYPE_SCHEDULE @"1"
//#define MESSAGE_TYPE_CALL @"2"
//#define MESSAGE_TYPE_REVIEW @"3"
//#define MESSAGE_TYPE_COMMAND @"4"
//#define MESSAGE_TYPE_PAY @"5"
//
//
//#define SHARE_KEY_UUID @"SHARE_KEY_UUID"
//#define SHARE_KEY_NAME @"SHARE_KEY_NAME"
//#define SHARE_KEY_IMAGE_URL @"SHARE_KEY_IMAGE_URL"
//
#define SHARE_KEY_PROVIDER_TYPE @"SHARE_KEY_PROVIDER_TYPE"
#define SHARE_KEY_PROVIDER_ID @"SHARE_KEY_PROVIDER_ID"
#define SHARE_KEY_PROVIDER_MAIL @"SHARE_KEY_PROVIDER_MAIL"
#define SHARE_KEY_PROVIDER_NAME @"SHARE_KEY_PROVIDER_NAME"

#define SHARE_KEY_LANGTUDY_ID @"SHARE_KEY_LANGTUDY_ID"
#define SHARE_KEY_LANGTUDY_PW @"SHARE_KEY_LANGTUDY_PW"


#define SHARE_IS_EMAIL_CONFIRM @"SHARE_IS_EMAIL_CONFIRM"
#define SHARE_SEND_MAIL @"SHARE_SEND_MAIL"
//
#define PUSH_TOKEN @"PUSH_TOKEN"
//
//#define SHARE_KEY_IS_GUIDE @"SHARE_KEY_IS_GUIDE"
//
//#define kCancelResonValue @"21", @"22", @"23", @"24", nil
//
//
//#define USER_STATUS_ON @"O"
//#define USER_STATUS_OFF @"F"
//#define USER_STATUS_CALL @"C"
//#define USER_STATUS_CALL_RECEIVE @"R"
//#define USER_STATUS_CALL_BREAK @"B"
//#define USER_STATUS_CALL_CALLING @"T"

#define SIZE_TEXT_SS        10.0
#define SIZE_TEXT_S         12.0
#define SIZE_TEXT_M         15.0
#endif
