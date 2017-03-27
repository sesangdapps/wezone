//
//  CommonViewController.m
//  wezone
//
//  Created by Kim Sunmi on 2017. 3. 13..
//  Copyright © 2017년 Kim Sunmi. All rights reserved.
//

#import "CommonViewController.h"
#import "GALToastView.h"


@interface CommonViewController ()




@end

@implementation CommonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self makeLayout];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)makeLeftBackButton {

    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -6;
    
    UIButton *button  = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 22, 22)];
    [button setImage:[UIImage imageNamed:@"btn_back_white"] forState:UIControlStateNormal];
    //[button setImage:[UIImage imageNamed:@"btn_back_touch"] forState:UIControlStateHighlighted];
    
    [button addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
//    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:negativeSpacer,leftBarButtonItem, nil]];
    self.navigationController.navigationItem.hidesBackButton = YES;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [[UINavigationBar appearance] setBackIndicatorImage:nil];
}

- (void)makeLeftBackButton:(NSString *)normalImageName selector:(SEL)selector {
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -16;
    
    UIButton *button  = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [button setImage:[UIImage imageNamed:normalImageName] forState:UIControlStateNormal];
    
    [button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:negativeSpacer,leftBarButtonItem, nil]];
    self.navigationController.navigationItem.hidesBackButton = YES;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [[UINavigationBar appearance] setBackIndicatorImage:nil];
}

- (void)makeRightButton:(NSString *)image target:(id)target selector:(SEL)selector {
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -6;
    
    UIButton *button  = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 22, 22)];
    [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    //[button setImage:[UIImage imageNamed:@"btn_back_touch"] forState:UIControlStateHighlighted];
    
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    //    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:negativeSpacer,rightBarButtonItem, nil]];
    self.navigationController.navigationItem.hidesBackButton = YES;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [[UINavigationBar appearance] setBackIndicatorImage:nil];
}

- (void)goBack {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)makeLayout {
    
}

- (void)makeRoot:(BOOL)scroll title:(NSString *)title bgColor:(UIColor *)bgColor {
    
    self.statusHeight = [Layout statusHeight];
    
    CGRect rect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    if ( title ) {
        rect = CGRectMake(0, 0, [Layout aspecValue:LAYOUT_WIDTH], [Layout convertHeight:LAYOUT_HEIGHT] - [Layout statusHeight]);
    }
    
    
    [self makeRoot:scroll rect:rect title:title bgColor:bgColor];
}

- (void)makeRoot:(BOOL)scroll rect:(CGRect) rect title:(NSString *)title bgColor:(UIColor *)bgColor {
    
    CGRect viewRect = rect;
    CGRect rootRect = viewRect;
    
    if ( title ) {
        self.title = title;
        self.titleHeight = NAVI_HEIGHT;
    }
    
    self.rootView = [[UIView alloc] init:rootRect parent:self.view tag:0 color:bgColor];
    
//    NSLog(@"makeRoot : %f, %f, %f, %f", self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
//    NSLog(@"makeRoot : %f, %f, %f, %f", self.rootView.frame.origin.x, self.rootView.frame.origin.y, self.rootView.frame.size.width, self.rootView.frame.size.height);
    
    if ( rootRect.size.height < viewRect.size.height ) {
        scroll = YES;
    }
    
    viewRect.origin.y = 0;
    
    if ( scroll ) {
        
        CGRect bodyRect = CGRectMake(0, 0, viewRect.size.width, viewRect.size.height);
        CGRect scrollRect = CGRectMake(0, viewRect.origin.y, viewRect.size.width, rootRect.size.height - viewRect.origin.y);
        self.scrollView = [[UIScrollView alloc] init:scrollRect parent:self.rootView tag:0];
        self.scrollView.contentSize = bodyRect.size;
        self.automaticallyAdjustsScrollViewInsets = NO;
        
        self.bodyView = [[UIView alloc] init:bodyRect parent:self.scrollView tag:0 color:bgColor];
        self.scrollView.delegate = self;
        
        //NSLog(@"makeRoot : %f, %f, %f, %f", scrollRect.origin.x, scrollRect.origin.y, scrollRect.size.width, scrollRect.size.height);
        
    } else {
        
        CGRect bodyRect = CGRectMake(0, viewRect.origin.y, viewRect.size.width, rootRect.size.height - viewRect.origin.y);
        self.bodyView = [[UIView alloc] init:bodyRect parent:self.rootView tag:0 color:bgColor];
        
        //NSLog(@"makeRoot : %f, %f, %f, %f", bodyRect.origin.x, bodyRect.origin.y, bodyRect.size.width, bodyRect.size.height);
        
    }
}

- (void)setBodyHiehgt:(float)h {
    
    if ( h < self.scrollView.frame.size.height ) h = self.scrollView.frame.size.height;
    
    [self.bodyView setHeight:h];
    
    if ( self.scrollView ) {
        self.scrollView.contentSize = self.bodyView.frame.size;
    }
}

- (void)showErrorToast:(NSDictionary *)data error:(NSError *)error {
    
    NSString *errorCode = data[@"code"];
    NSLog(@"%@",errorCode);
    
    NSString *msg = [NSString stringWithFormat:@"%@", error];
    [GALToastView showWithText:errorCode];
}

#pragma mark -
#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if ( scrollView == self.scrollView ) {
        
        if ( _titleView ) {
            
            float top = self.statusHeight + NAVI_HEIGHT;
            
            if ( scrollView.contentOffset.y > _titleView.frame.size.height - top ) {
                
                [_titleView setY:scrollView.contentOffset.y - (_titleView.frame.size.height - top)];
                
                if ( _subTitleView ) {
                    if ( _titleView.frame.origin.y <= _titleView.frame.size.height - _subTitleView.frame.origin.y ) {
                        NSLog(@"%f, %f", _titleView.frame.origin.y, (_titleView.frame.size.height - _subTitleView.frame.origin.y));
                        float rate = _titleView.frame.origin.y / (_titleView.frame.size.height - _subTitleView.frame.origin.y);
                        _subTitleView.alpha = 1 - rate;
                    }
                }
            } else {
                [_titleView setY:0];
                if ( _subTitleView ) {
                    if ( _subTitleView.alpha < 1 ) {
                        _subTitleView.alpha = 1;
                    }
                }
            }
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if ( scrollView == self.scrollView ) {
        
        if ( _titleView ) {
            
            float top = self.statusHeight + NAVI_HEIGHT;
            
            if ( scrollView.contentOffset.y > _titleView.frame.size.height - top ) {
                
                [_titleView setY:scrollView.contentOffset.y - (_titleView.frame.size.height - top)];
                
                if ( _subTitleView ) {
                    if ( _titleView.frame.origin.y <= _subTitleView.frame.size.height / 2 ) {
                        float rate = _titleView.frame.origin.y / (_subTitleView.frame.size.height / 2);
                        _subTitleView.alpha = 1 - rate;
                    }
                }
            } else {
                [_titleView setY:0];
                if ( _subTitleView ) {
                    if ( _subTitleView.alpha < 1 ) {
                        _subTitleView.alpha = 1;
                    }
                }
            }
        }
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
