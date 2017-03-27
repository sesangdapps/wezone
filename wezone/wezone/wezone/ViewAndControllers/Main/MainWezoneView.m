//
//  MainWezoneView.m
//  wezone
//
//  Created by Kim Sunmi on 2017. 3. 16..
//  Copyright © 2017년 Kim Sunmi. All rights reserved.
//

#import "MainWezoneView.h"
#import "Layout.h"
#import "Style.h"
#import "WezoneDetailViewController.h"
#import "WezoneManagerViewController.h"
#import "LocationDistanceViewController.h"
#import "WezoneSearchViewController.h"
#import "WezoneListView.h"

#define VIEW_NEAR_WEZONE_LIST_MASK       100000

#define VIEW_MY_WEZONE_LIST          VIEW_NEAR_WEZONE_LIST_MASK * 1
#define VIEW_NEAR_WEZONE_LIST            VIEW_NEAR_WEZONE_LIST_MASK * 2

@interface MainWezoneView()
{
    UIView *_searchView;
    UIView *_hashtagView;
    UIView *_maskView;
    UIView *_menuView;
    UITextField *_searchInput;
    UIScrollView *_listView;
    
    WezoneListView *_myWezoneView;
    UIView *_nearWezoneView;
    
    
    UIButton *_menuBtn;
    BOOL _isShowMenu;
    
    NSArray *_nearWezoneList;
    
}
@end

@implementation MainWezoneView

-(instancetype) init:(CGRect)rect parent:(UIView *)parent {
    
    self = [self init];
    if ( self ) {
        [self setFrame:rect];
        if ( parent ) {
            [parent addSubview:self];
        }
        [self makeWezone];
        
        //[self getWezone];
    }
    return self;
}

-(void)reload {
    
    [self getMyWezone];
}

- (void)makeWezone {
    
    float w = [Layout revert:self.frame.size.width];
    float h = [Layout revert:self.frame.size.height];
    float y = 0;
    
    [self makeList:y w:w h:h];
    
    [self makeMenu:w h:h];
}

- (void)makeList:(float)y w:(float)w h:(float)h {

    _listView = [[UIScrollView alloc] init:[Layout aspecRect:CGRectMake(0, y, w, h)] parent:self tag:0 color:UIColorFromRGB(0xffffff)];
    
    _myWezoneView = [[WezoneListView alloc] init:STR(@"wezone_my_wezone") rect:[Layout aspecRect:CGRectMake(0, 0, w, 44)] parent:_listView sizeChanged:^(CGRect rect) {
        
        [_nearWezoneView setY:rect.origin.y + rect.size.height];
        [_listView setContentSize:CGSizeMake(_listView.frame.size.width, _nearWezoneView.frame.origin.y + _nearWezoneView.frame.size.height)];
    }];
                                                //:[Layout aspecRect:CGRectMake(0, y, w, 44)] parent:_listView  tag:VIEW_MY_WEZONE_LIST];
    _nearWezoneView = [[UIView alloc] init:[Layout aspecRect:CGRectMake(0, 0, w, 44)] parent:_listView tag:VIEW_NEAR_WEZONE_LIST];
}

#pragma mark -
#pragma mark Menu

// 위존 메뉴
- (void)makeMenu:(float)w h:(float)h {
    
    _maskView = [[UIView alloc] init:[Layout aspecRect:CGRectMake(0, 0, w, h)] parent:self tag:101 color:UIColorFromRGBA(0x00000060)];
    _menuView = [[UIView alloc] init:[Layout aspecRect:CGRectMake(0, 0, w, h)] parent:self tag:102];
    
    [[[[UIButton alloc] init:[Layout aspecRect:CGRectMake((w - 75) / 2, (h - 60 * 3 - 20), 75, 75)] parent:_menuView tag:0 target:self action:@selector(onClickSearch)]
      addBackgroundImageName:@"btn_circle_blue"]
     addImageName:@"btn_search_white"];
    
    [[UILabel alloc] init:[Layout aspecRect:CGRectMake(w / 2 + 30, (h - 60 * 3), 80, 35)] parent:_menuView tag:0 text:STR(@"wezone_search") color:UIColorFromRGB(0xffffff) bgColor:nil align:NSTextAlignmentLeft font:nil size:[Layout aspecValue:SIZE_TEXT_S]];
    
    [[[[UIButton alloc] init:[Layout aspecRect:CGRectMake((w - 75) / 2, (h - 60 * 2 - 20), 75, 75)] parent:_menuView tag:0 target:self action:@selector(onClickCreate)]
      addBackgroundImageName:@"btn_circle_blue"]
     addImageName:@"btn_add_zone"];
    
    [[UILabel alloc] init:[Layout aspecRect:CGRectMake(w / 2 + 30, (h - 60 * 2), 80, 35)] parent:_menuView tag:0 text:STR(@"wezone_create") color:UIColorFromRGB(0xffffff) bgColor:nil align:NSTextAlignmentLeft font:nil size:[Layout aspecValue:SIZE_TEXT_S]];
    
    [[UILabel alloc] init:[Layout aspecRect:CGRectMake(w / 2 + 30, (h - 60), 80, 35)] parent:_maskView tag:0 text:STR(@"close") color:UIColorFromRGB(0xffffff) bgColor:nil align:NSTextAlignmentLeft font:nil size:[Layout aspecValue:SIZE_TEXT_S]];
    
    // 위존 메뉴 버튼
    _menuBtn = [[[[UIButton alloc] init:[Layout aspecRect:CGRectMake((w - 75) / 2, (h - 60 - 20), 75, 75)] parent:self tag:100 target:self action:@selector(onClickShowWezoneMenu:)]
                 addBackgroundImageName:@"btn_circle_white"]
                addImageName:@"btn_more_black" highlightedImageName:nil selectedImageName:nil disabledImageName:nil];
    _menuBtn.transform = CGAffineTransformMakeRotation(M_PI / 2);
    
    
    
    [_menuView setY:_menuBtn.frame.origin.y + _menuBtn.frame.size.height / 2];
    [_menuView setHeight:0];
    _menuView.clipsToBounds = YES;
    
    _menuView.hidden = YES;
    _maskView.hidden = YES;
    _maskView.alpha = 0.0;
}

- (IBAction)onClickShowWezoneMenu:(UIButton *)button {
    
    button.selected = !button.selected;
    
    float h = _menuBtn.frame.origin.y + _menuBtn.frame.size.height / 2;
    
    [_menuView.layer removeAllAnimations];
    
    if ( button.selected ) {
        
        _menuView.hidden = NO;
        _maskView.hidden = NO;
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        [UIView animateWithDuration:0.2 animations:^{
            
            [_menuView setHeight:h];
            [_menuView setY:0];
            _maskView.alpha = 1.0;
            _menuBtn.transform = CGAffineTransformMakeRotation(M_PI);
            
        }completion:^(BOOL finished){
            
            [_menuBtn addImageName:@"btn_close_black"];
        }];
        
    } else {
        
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [UIView animateWithDuration:0.2 animations:^{
            
            [_menuView setHeight:0];
            [_menuView setY:h];
            _maskView.alpha = 0.0;
            _menuBtn.transform = CGAffineTransformMakeRotation(M_PI / 2);
            
        }completion:^(BOOL finished){
            
            [_menuBtn addImageName:@"btn_more_black"];
            _menuView.hidden = YES;
            _maskView.hidden = YES;
        }];
    }
}

- (void)onClickSearch {
    
    WezoneSearchViewController *vc = [[WezoneSearchViewController alloc] init];
    [ApplicationDelegate.mainNaviController pushViewController:vc animated:YES];
}

- (void)onClickCreate {
    
    WezoneManagerViewController *vc = [[WezoneManagerViewController alloc] init:nil];
    [ApplicationDelegate.mainNaviController pushViewController:vc animated:YES];
}

- (void)getMyWezone {
    
    GALLangtudyEngine *engine = [GALLangtudyEngine sharedEngine];
    
    [engine getMyWezoneList:nil longitude:ApplicationDelegate.loginData.user_longitude withLatitude:ApplicationDelegate.loginData.user_latitude resultHandler:^(int total_count, NSArray *list){
        
        for(WezoneModel *wezone in list) {
            
            wezone.isJoin = YES;
        }
        [_myWezoneView reloadData:list];
        
    } errorHandler:^(NSDictionary *data, NSError *error) {
        
        NSString *errorCode = data[@"code"];
        NSLog(@"%@",errorCode);
    }];
}



@end
