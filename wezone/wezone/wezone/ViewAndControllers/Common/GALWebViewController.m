//
//  GALWebViewController.m
//  Langtudy
//
//  Created by SinSuMin on 2016. 8. 24..
//  Copyright © 2016년 galuster. All rights reserved.
//

#import "GALWebViewController.h"

@interface GALWebViewController ()

@end

@implementation GALWebViewController
{

    __weak IBOutlet UIWebView *webView;
    
    GALWebViewType webviewType;
    NSString *initUrl;
    NSString *mTitle;
}

- (id)initWithType:(GALWebViewType)type withURL:(NSString *)url withTitle:(NSString *)title
{
    self = [self initWithNibName:@"GALWebViewController" bundle:nil];
    if (self) {
        webviewType = type;
        initUrl = url;
        mTitle= title;
    }
    return self;
}

- (id)initWithUrl:(NSString *)url withTitle:(NSString *)title
{
    self = [self initWithNibName:@"GALWebViewController" bundle:nil];
    if (self) {
        webviewType = WebViewTypePrivacy;
        initUrl = url;
        mTitle = title;
    }
    return self;
}

- (id)initWithPay:(NSString *)url
{
    self = [self initWithNibName:@"GALWebViewController" bundle:nil];
    if (self) {
        webviewType = WebViewTypePay;
        
        
        initUrl = [NSString stringWithFormat:@"%@?user_uuid=%@&lang=%@&type=2",url,ApplicationDelegate.loginData.user_info.uuid,ApplicationDelegate.loginData.user_sys_lang];
    }
    return self;
}

- (id)initWithUrl:(NSString *)url withLangCoinId:(NSString *)langcoinId
{
    self = [self initWithNibName:@"GALWebViewController" bundle:nil];
    if (self) {
        webviewType = WebViewTypePayWithReservation;
        
        initUrl = [NSString stringWithFormat:@"%@?lang=%@&langcoin_id=%@&type=2",url,ApplicationDelegate.loginData.user_sys_lang,langcoinId];
    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    UIButton *button  = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
//    [button setImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
//    [button setImage:[UIImage imageNamed:@"btn_back_touch"] forState:UIControlStateHighlighted];
//
//    
//    [[NSURLCache sharedURLCache] removeAllCachedResponses];
//    [[NSURLCache sharedURLCache] setDiskCapacity:0];
//    [[NSURLCache sharedURLCache] setMemoryCapacity:0];
//    
//    
//    if(webviewType == WebViewTypePrivacy){
//    [button addTarget:self action:@selector(goBackinLogin) forControlEvents:UIControlEventTouchUpInside];
//        self.navigationItem.title = mTitle;
//        
//    }else if(webviewType == WebViewTypeFAQ){
//        [button addTarget:self action:@selector(goBackinMain) forControlEvents:UIControlEventTouchUpInside];
//        self.navigationItem.title = mTitle;
//    }else{
//        [button addTarget:self action:@selector(goBackinMain) forControlEvents:UIControlEventTouchUpInside];
//        self.navigationItem.title = [self getStringWithKey:@"payment"];
//    }
//    
//    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
//    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
//
    self.title = mTitle;
    
    [self makeLeftBackButton];
    
    if (initUrl){
        [self->webView loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:initUrl]]];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType
{
    if ([[[request URL] absoluteString] hasPrefix:@"galuster:"]) {
        
        NSString *requestString = [[request URL] absoluteString];
        NSArray *components = [requestString componentsSeparatedByString:@"://"];
        NSArray *funcAndParam = [[components objectAtIndex:1] componentsSeparatedByString:@"("];
        
        NSString *functionName = [funcAndParam objectAtIndex:0];
        NSString *parameter = [funcAndParam objectAtIndex:1];
        parameter = [parameter stringByReplacingOccurrencesOfString:@")" withString:@""];
        
        if([@"onSuccess" isEqualToString:functionName]){
            [self.delegate onSuccess:parameter];
            [self goBackinMain];
        }else if([@"onClickBack" isEqualToString:functionName]){
            [self.delegate onBack];
            [self goBackinMain];
        }else if([@"onFail" isEqualToString:functionName]){
            [self.delegate onFail:parameter];
        }
        return NO;
    }
    
    return YES;
}


-(void)webViewDidStartLoad:(UIWebView*)webView
{
    [GALangtudyUtils showActivityIndicator];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [GALangtudyUtils hideActivityIndicator];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [GALangtudyUtils hideActivityIndicator];
}

@end
