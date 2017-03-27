//
//  GALWebViewController.h
//  Langtudy
//
//  Created by SinSuMin on 2016. 8. 24..
//  Copyright © 2016년 galuster. All rights reserved.
//

#import "GALBaseController.h"

typedef NS_ENUM(NSInteger, GALWebViewType) {
    WebViewTypePrivacy= 0,
    WebViewTypeFAQ,
    WebViewTypePay,
    WebViewTypePayWithReservation,
};


@protocol GALWebViewControllerDelegate
@optional
- (void) onSuccess:(NSString *)total_cnt;
- (void) onBack;
- (void) onFail:(NSString *)error;
@end

@interface GALWebViewController : GALBaseController

@property (weak,nonatomic) id <GALWebViewControllerDelegate> delegate;


- (id)initWithType:(GALWebViewType)type withURL:(NSString *)url withTitle:(NSString *)title;
- (id)initWithUrl:(NSString *)url withTitle:(NSString *)title;
- (id)initWithPay:(NSString *)url;
- (id)initWithUrl:(NSString *)url withLangCoinId:(NSString *)langcoinId;
@end
