//
//  GALangtudyUtils.h
//  Langtudy
//
//  Created by SinSuMin on 2015. 9. 1..
//  Copyright (c) 2015년 galuster. All rights reserved.
//

#ifndef Langtudy_GALangtudyUtils_h
#define Langtudy_GALangtudyUtils_h

#import "GALNativeAlertView.h"

//#import "GALCall.h"
#import "GALCommon.h"
//#import "GALLangData.h"

typedef NS_ENUM(NSInteger, GALAlertType) {
    GALAlertTypeOk = 0,
    GALAlertTypeOkCancel,
    GALAlertTypeYesNo
};

typedef NS_ENUM(NSInteger, GALAlertButton) {
    GALAlertButtonOk = 0,
    GALAlertButtonCancel,
    GALAlertButtonYes,
    GALAlertButtonNo
};

typedef NS_ENUM(NSInteger, GALVersionCheck) {
    GALVersionCheckNone= 0,
    GALVersionCheckChoice,
    GALVersionCheckUpdate,
    GALVersionCheckError
};

typedef NS_ENUM(NSInteger, GALSaveDirectoryType) {
    GALSaveDirectoryTypeCache = 0,
    GALSaveDirectoryTypeChatting
};

@interface GALangtudyUtils : NSObject

+ (BOOL) isLogin;
+ (void) saveValue:(NSString *)value Key:(NSString *)key;
+ (NSString *)getValue:(NSString *)key;
+ (void)removeValue:(NSString *)key;

+ (void)checkContent:(NSString *)content withLength:(NSUInteger)length withSubject:(NSString *)subject
              withOk:(void (^)(BOOL isOver, NSString *limitContent))okBlock withCancel:(void (^)())cancelBlock;

+ (void)showAlert:(NSError *)error close:(void (^)())closeBlock;
+ (void)showAlertWithButtons:(NSArray *)buttonTitles error:(NSError *)error title:(NSString *)title close:(void (^)(int buttonIndex))closeBlock;
+ (void)showAlert:(GALAlertType)type message:(NSString *)message close:(void (^)(GALAlertButton buttonType))closeBlock;
+ (void)showAlert:(GALAlertType)type message:(NSString *)message title:(NSString *)title close:(void (^)(GALAlertButton buttonType))closeBlock;
+ (void)showAlertWithButtons:(NSArray *)buttonTitles message:(NSString *)message close:(void (^)(int buttonIndex))closeBlock;
+ (void)showAlertWithButtons:(NSArray *)buttonTitles message:(NSString *)message title:(NSString *)title close:(void (^)(int buttonIndex))closeBlock;

+ (void)showActivityIndicator;
+ (void)hideActivityIndicator;

//font size
+ (float)getFontSize;

+ (NSString *)sha512:(NSString *)input;
+ (NSString *)rsaEnc:(NSString *)input;

+ (NSDictionary *)parseQueryString:(NSString *)query;

+ (BOOL) validateEmail:(NSString*) emailString;

+ (UIImage *) getLevelImage:(NSString *) level;
+ (NSString *) getLevelString:(NSString *) level;

+ (UIImage *) getMaskImage:(NSString *)status;
+ (UIImage *) getProfileMaskImage:(NSString *)status;

+ (NSString *) getCallMessage:(NSString *)type;
+ (UIImage *) getCallIcon:(NSString *) type;

//+ (GALLangData *) getMainLangData:(NSMutableArray *) langList;
//+ (NSMutableArray *) getLangListWithOutMain:(NSMutableArray *) langList withLangMain:(GALLangData *)main;
//+ (GALLangData *) getSearchLangData:(NSMutableArray *) langList withLangMode:(NSString *)mode withLangCode:(NSString *)code;

+ (CGSize) getLabelHeightwithContents:(NSString *)contents withFontSize:(CGFloat)fontSize;
+ (CGSize) getLabelHeightwithWidth:(CGFloat) width withContents:(NSString *)contents withFontSize:(CGFloat)fontSize;

+ (BOOL) isNull:(NSString *)str;

+ (NSString *) getCancelReasonName:(NSString *)value;

+ (NSString *) getLocationString:(NSInteger) pos;
+ (NSString *) getLocationCode:(NSInteger) pos;

+ (NSString *) getLevelName:(NSInteger) pos;

+ (UIImage *)scaleAndRotateImage:(UIImage *)image orientation:(UIImageOrientation)orientation;
+ (UIImage *)scaleAndRotateImage:(UIImage *)image orientation:(UIImageOrientation) orientation withMaxResolution:(int)kMaxResolution;

+ (BOOL) isWiFiConnect;
+ (BOOL) isLTEConnect;

+ (NSString *) getRoundString:(NSString *)str;

+ (NSString *) percentEscapeString:(NSString *)string;
+ (NSString *) percentDecodingString:(NSString *)string;

+(UIImage*)imageWithImage: (UIImage*) sourceImage scaledToHeight: (float) i_height;
@end

#endif
