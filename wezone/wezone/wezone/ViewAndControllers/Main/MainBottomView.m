//
//  MainBottomView.m
//  wezone
//
//  Created by Kim Sunmi on 2017. 3. 15..
//  Copyright © 2017년 Kim Sunmi. All rights reserved.
//

#import "MainBottomView.h"
#import "Layout.h"
#import "Style.h"
#import "ThemeUtil.h"
#import "MainWezoneView.h"

#define kMenuAnimationDuration 0.2

@interface MainBottomView()
{
    UIView *_themeView;
    MainWezoneView *_wezoneView;
    UIView *_titleView;
    UIView *_notiView;
    UIScrollView *_zoneView;
    BOOL _isShow;
}
@end

@implementation MainBottomView

-(instancetype) init:(UIView *)parent {
    
    self = [self init];
    if ( self ) {
        
        
        [self setFrame:CGRectMake(0, 0, parent.frame.size.width, parent.frame.size.height)];
        if ( parent ) {
            [parent addSubview:self];
        }
        
        float w = [Layout revert:self.frame.size.width];
        float h = [Layout revert:self.frame.size.height];
        float y = 0;
        [self makeTop:y w:w];
        y += 44;
        
        [self makeNotification:y w:w];
        y += 44;
        
        [self makeZone:y w:w h:h - y];
        
        [self setY:self.superview.frame.size.height - _titleView.frame.size.height];
    }
    return self;
}

-(void)reload {
    
    if ( _wezoneView ) {
        [_wezoneView reload];
    }
}

- (void)makeTop:(float)y w:(float)w {
    
    _titleView = [[UIView alloc] init:[Layout aspecRect:CGRectMake(0, y, w, 44)] parent:self tag:0 color:[UIColor clearColor]];
    
    [[UIImageView alloc] init:[Layout aspecRect:CGRectMake(0, 0, w, 44)] parent:_titleView tag:0 imageName:[ThemeUtil imageName:@"bottom_menu_blue"]];
    
    UIImageView *img = [[UIImageView alloc] init:[Layout aspecRect:CGRectMake((w - 30)/ 2, 7, 30, 30)] parent:_titleView tag:0 imageName:@"ic_view_headline_white"];
    
    [[UILabel alloc] init:[Layout aspecRect:CGRectMake(20, 12, (w - 40)/ 2, 17)] parent:_titleView tag:100 text:STR(@"main_themezone") color:UIColorFromRGB(0xffffff) bgColor:nil align:NSTextAlignmentCenter font:nil size:[Layout aspecValue:15.0f]];
    
    [[UILabel alloc] init:[Layout aspecRect:CGRectMake((w - 40)/ 2 + 20, 12, (w - 40)/ 2, 17)] parent:_titleView tag:200 text:STR(@"main_wezone") color:UIColorFromRGB(0xffffff) bgColor:nil align:NSTextAlignmentCenter font:nil size:[Layout aspecValue:15.0f]];
    
    [[UIImageView alloc] init:[Layout aspecRect:CGRectMake(20 + ((w - 40) / 2 - 5) / 2, 30, 5, 5)] parent:_titleView tag:101 imageName:@"btn_circle_white"];
    [[UIImageView alloc] init:[Layout aspecRect:CGRectMake((w - 40)/ 2 + 20 + ((w - 40) / 2 - 5) / 2, 30, 5, 5)] parent:_titleView tag:201 imageName:@"btn_circle_white"];
    
    
    UISwipeGestureRecognizer *upGest = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showBottomMenu)];
    upGest.direction = UISwipeGestureRecognizerDirectionUp;
    [_titleView addGestureRecognizer:upGest];
    
    UISwipeGestureRecognizer *downGest = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(hideBottomMenu)];
    downGest.direction = UISwipeGestureRecognizerDirectionDown;
    [_titleView addGestureRecognizer:downGest];
    
    [_titleView addTarget:self action:@selector(toggleBottomMenu)];

    [self selectZone:0];
}

- (void)makeNotification:(float)y w:(float)w {
    
    _notiView = [[UIView alloc] init:[Layout aspecRect:CGRectMake(0, y, w, 44)] parent:self tag:0 color:UIColorFromRGB(0xffffff)];
    
    [[UIImageView alloc] init:[Layout aspecRect:CGRectMake(10, 7, 30, 30)] parent:_notiView tag:0 imageName:@"im_bunny_photo"];
    [[UILabel alloc] init:[Layout aspecRect:CGRectMake(50, 0, w - 80, 44)] parent:_notiView tag:0 text:STR(@"bottom_notification") color:UIColorFromRGB(0x212121) bgColor:nil align:NSTextAlignmentLeft font:nil size:[Layout aspecValue:15.0f]];
    
    [[[UIButton alloc] init:[Layout aspecRect:CGRectMake(w - 40, 7, 30, 30)] parent:_notiView tag:0 target:self action:@selector(onClickDelegeNoti)] addBackgroundImageName:@"btn_close_black"];
    
    [UIView makeBottomLine:[Layout aspecRect:CGRectMake(0, 43, w, 1)] parent:_notiView tag:0 color:UIColorFromRGB(0xe0e0e0)];
    
    UISwipeGestureRecognizer *upGest = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showZone)];
    upGest.direction = UISwipeGestureRecognizerDirectionUp;
    [_notiView addGestureRecognizer:upGest];
}

- (void)makeZone:(float)y w:(float)w h:(float)h{

    _zoneView = [[UIScrollView alloc] init:[Layout aspecRect:CGRectMake(0, y, w, h)] parent:self tag:0];
    _zoneView.pagingEnabled = YES;
    _zoneView.delegate = self;
    [_zoneView setBackgroundColor:UIColorFromRGB(0xff0000)];
    
    [self makeThemeZone:0 w:w h:h];
    _wezoneView = [[MainWezoneView alloc] init:[Layout aspecRect:CGRectMake(w, 0, w, h)] parent:_zoneView];
    //[self makeWezone:w w:w h:h];
    
    [_zoneView setContentSize:[Layout aspecSize:CGSizeMake(w * 2, h)]];
    
    UISwipeGestureRecognizer *upGest = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showZone)];
    upGest.direction = UISwipeGestureRecognizerDirectionUp;
    [_zoneView addGestureRecognizer:upGest];
}

- (void)makeThemeZone:(float)x w:(float)w h:(float)h {
    
    _themeView = [[UIView alloc] init:[Layout aspecRect:CGRectMake(x, 0, w, h)] parent:_zoneView tag:0];
    
    UIScrollView *scrollView = [[UIScrollView alloc] init:[Layout aspecRect:CGRectMake(0, 0, w, h)] parent:_themeView tag:0 color:UIColorFromRGB(0xeeeeee)];

}

- (void)selectZone:(int)index {
    
    [_titleView viewWithTag:100].alpha = index == 0 ? 1 : 0.38;
    [_titleView viewWithTag:101].hidden = index != 0;
    
    [_titleView viewWithTag:200].alpha = index == 1 ? 1 : 0.38;
    [_titleView viewWithTag:201].hidden = index != 1;
}

- (void)onClickDelegeNoti {

    
}

- (void)toggleBottomMenu {
    
    [self.layer removeAllAnimations];
    
    if ( _isShow ) {
        [self hideBottomMenu];
    } else {
        [self showBottomMenu];
    }
}

- (void)showBottomMenu {
    
    float y = self.superview.frame.size.height - [Layout aspecValue:300];
    
    [UIView animateWithDuration:kMenuAnimationDuration animations:^{
        
        [self setY:y];
        
    }completion:^(BOOL finished){
        
        _isShow = YES;
    }];
}

- (void)hideBottomMenu {
    
    float y = self.superview.frame.size.height - _titleView.frame.size.height;
    
    [UIView animateWithDuration:kMenuAnimationDuration animations:^{
        
        [self setY:y];
        
    }completion:^(BOOL finished){
        
        _isShow = NO;
    }];
}

- (void)showZone {
    
    float y = 0;
    
    [UIView animateWithDuration:kMenuAnimationDuration animations:^{
        
        [self setY:y];
        
    }completion:^(BOOL finished){
        
        _isShow = YES;
    }];
}

#pragma mark -
#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if ( scrollView == _zoneView ) {
        float w = scrollView.frame.size.width;
        int page = (scrollView.contentOffset.x / w);
        [self selectZone:page];
    }
}



@end
