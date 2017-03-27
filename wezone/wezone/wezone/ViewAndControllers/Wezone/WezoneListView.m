//
//  WezoneListView.m
//  wezone
//
//  Created by Kim Sunmi on 2017. 3. 23..
//  Copyright © 2017년 Kim Sunmi. All rights reserved.
//

#import "WezoneListView.h"
#import "WezoneDetailViewController.h"
#import "CommonDataView.h"

@interface WezoneListView() {
    
    WezoneModel *_wezone;
    NSString *_title;
    
    UIView *_titleView;
    
    NSArray *_wezoneList;
    
    NSMutableDictionary *_viewPool;
    NSMutableDictionary *_oldPool;
    
    sizeChangedBlock _sizeChanged;
}
@end

@implementation WezoneListView

- (instancetype)init:(NSString *)title rect:(CGRect)rect parent:(UIView *)parent sizeChanged:(sizeChangedBlock)sizeChanged {
    
    self = [self initWithFrame:rect];
    
    if ( self ) {
        
        if ( parent ) [parent addSubview:self];
        [self setBackgroundColor:UIColor_main];
        
        _sizeChanged = sizeChanged;
        _viewPool = [NSMutableDictionary dictionary];
        
        _titleView = [self makeWezoneTitle:title parent:self y:0 w:[Layout revert:self.frame.size.width] h:44];
    }
    
    return self;
}

- (void)reloadData:(NSArray *)list {
    
    _wezoneList = list;
    [self makeWezoneList:list];
}

- (void)makeWezoneList:(NSArray *)list {
    
    _wezoneList = list;
    
    for( CommonDataView *view in [_viewPool allValues] ) {
        [view removeFromSuperview];
    }
    _oldPool = _viewPool;
    _viewPool = [NSMutableDictionary dictionary];
    
    [CommonUtil removeAllChildView:self];
    
    if ( list == nil || list.count == 0 ) {
        [self setHeight:0];
        return;
    }
    
    float g = 15;
    float w = ([Layout revert:self.frame.size.width] - g * 3) / 2;
    float h = 200;
    
    float lx = g;
    float rx = g + w + g;
    
    float ly = 44;
    float ry = 44;
    
    [self addSubview:_titleView];
    
    for( int i=0; i<list.count; i++ ) {
        if ( ly <= ry + 20 ) {
            ly += [self makeWezone:list[i] parent:self x:lx y:ly w:w h:h] + g;
        } else {
            ry += [self makeWezone:list[i] parent:self x:rx y:ry w:w h:h] + g;
        }
    }
    [self setHeight:[Layout aspecValue:MAX(ly, ry)]];
    
    if ( _sizeChanged ) {
        _sizeChanged(self.frame);
    }
}

- (void)repositionWezoneList {
    
    float g = 15;
    float w = ([Layout revert:self.frame.size.width] - g * 3) / 2;
    float h = 200;
    
    float lx = g;
    float rx = g + w + g;
    
    float ly = 44;
    float ry = 44;
    
    [self addSubview:_titleView];
    
    for( int i=0; i<_wezoneList.count; i++ ) {
        
        WezoneModel *wezone = [_wezoneList objectAtIndex:i];
        CommonDataView *view = [_viewPool valueForKey:wezone.wezone_id];
        
        if ( ly <= ry + 20 ) {
            ly += [self resizeWezone:view x:lx y:ly] + g;
        } else {
            ry += [self resizeWezone:view x:rx y:ry] + g;
        }
    }
    [self setHeight:[Layout aspecValue:MAX(ly, ry)]];
    
    if ( _sizeChanged ) {
        _sizeChanged(self.frame);
    }
}

- (UIView *)makeWezoneTitle:(NSString *)title parent:(UIView *)parent y:(float)y w:(float)w h:(float)h {
    
    UIView *view = [[UIView alloc] init:[Layout aspecRect:CGRectMake(0, 0, w, h)] parent:parent tag:parent.tag + 1];
    
    [[UIImageView alloc] init:[Layout aspecRect:CGRectMake(15, (h - 25) / 2, 25, 25)] parent:view tag:parent.tag + 2 imageName:@"ic_rabbit_foot"];
    
    [[UILabel alloc] init:[Layout aspecRect:CGRectMake(40, 0, w - 40, h)] parent:view tag:parent.tag + 3 text:title color:UIColorFromRGB(0x212121) bgColor:nil align:NSTextAlignmentLeft font:nil size:[Layout aspecValue:SIZE_TEXT_M]];
    
    return view;
}

- (float)makeWezone:(WezoneModel *)wezone parent:(UIView *)parent x:(float)x y:(float)y w:(float)w h:(float)h {
    
    CommonDataView *view = [_oldPool valueForKey:wezone.wezone_id];
    if ( view == nil ) {
        view = [self makeWezone:parent x:x y:y w:w h:h];
    } else {
        [view setPosition:CGPointMake([Layout aspecValue:x], [Layout aspecValue:y])];
        [self addSubview:view];
    }
    return [self setWezone:view wezone:wezone];
}

- (CommonDataView *)makeWezone:(UIView *)parent x:(float)x y:(float)y w:(float)w h:(float)h {
    
    CommonDataView *view = [[CommonDataView alloc] init:[Layout aspecRect:CGRectMake(x, y, w, h)] parent:parent tag:0 color:UIColorFromRGB(0xeeeeee)];
    
    float y2 = 0;
    UIImageView *img = [[UIImageView alloc] init:[Layout aspecRect:CGRectMake(0, 0, w, w)] parent:view tag:1 imageName:@"ic_bunny_image"];
    y2 += w + 5;
    
    [[UIImageView alloc] init:[Layout aspecRect:CGRectMake(-10, -10, 38, 38)] parent:view tag:2 imageName:@"ic_manager"];
    
    UIView *sub = [[UIView alloc] init:[Layout aspecRect:CGRectMake(0, y2, w, h)] parent:view tag:3 color:nil];
    
    float y3 = 0;
    [[UILabel alloc] init:[Layout aspecRect:CGRectMake(0, y3, w / 3 + 10, 10)] parent:sub tag:4 text:@"" color:UIColorFromRGB(0x757575) bgColor:nil align:NSTextAlignmentCenter font:nil size:[Layout aspecValue:8.0f]];
    
    [[UILabel alloc] init:[Layout aspecRect:CGRectMake(w / 3 + 5, y3, 10, 10)] parent:sub tag:5 text:@"|" color:UIColorFromRGB(0x757575) bgColor:nil align:NSTextAlignmentCenter font:nil size:[Layout aspecValue:8.0f]];
    
    [[UILabel alloc] init:[Layout aspecRect:CGRectMake(w / 3 + 10, y3, w / 3 - 5, 10)] parent:sub tag:6 text:@"" color:UIColorFromRGB(0x757575) bgColor:nil align:NSTextAlignmentCenter font:nil size:[Layout aspecValue:8.0f]];
    
    [[UILabel alloc] init:[Layout aspecRect:CGRectMake(w / 3 * 2, y3, 10, 10)] parent:sub tag:7 text:@"|" color:UIColorFromRGB(0x757575) bgColor:nil align:NSTextAlignmentCenter font:nil size:[Layout aspecValue:8.0f]];
    
    [[UILabel alloc] init:[Layout aspecRect:CGRectMake(w / 3 * 2 + 5, y3, w / 3 - 5, 10)] parent:sub tag:8 text:@"" color:UIColorFromRGB(0x757575) bgColor:nil align:NSTextAlignmentCenter font:nil size:[Layout aspecValue:8.0f]];
    y3 += 20;
    
    [[UILabel alloc] init:[Layout aspecRect:CGRectMake(10, y3, w - 20, 12)] parent:sub tag:9 text:@"title" color:UIColorFromRGB(0x212121) bgColor:nil align:NSTextAlignmentLeft font:nil size:[Layout aspecValue:12.0f]];
    y3 += 12 + 10;
    
     [[UILabel alloc] init:[Layout aspecRect:CGRectMake(10, y3, w - 20, 8)] parent:sub tag:10 text:@"tag" color:UIColorFromRGB(0x757575) bgColor:nil align:NSTextAlignmentLeft font:nil size:[Layout aspecValue:8.0f]];
    y3 += 8 + 10;
    y2 += y3;
    
    
    [sub setHeight:[Layout aspecValue:y3]];
    [view setHeight:[Layout aspecValue:y2]];
    [view addTarget:self action:@selector(onClickWezone:)];
    
    return view;
}

- (float)setWezone:(CommonDataView *)view wezone:(WezoneModel *)wezone {
       
    NSDictionary *oldData = view.data;
    
    float y2 = 0;
    float y3 = 0;
    
    UIImageView *img = [view viewWithTag:1];
    if ( [[oldData valueForKey:@"img_url"] isEqualToString:wezone.img_url] == NO ) {
        
        [[GALLangtudyEngine sharedEngine] getImageWithUrl:wezone.img_url completionHandler:^(UIImage *image, BOOL isInCache) {
            if ( image ) {
                [view.data setValue:wezone.img_url forKey:@"img_url"];
                
                img.image = image;
                float rate = image.size.height / image.size.width;
                [img setHeight:img.frame.size.width * rate];
                [img setContentMode:UIViewContentModeScaleAspectFit];
                
                [self repositionWezoneList];
            }
        } errorHandler:^(NSDictionary *data, NSError *error) {
            
        }];
    }
    y2 += [Layout revert:img.frame.size.height] + 5;
    
    // 매니저 마크
    [view viewWithTag:2].hidden = ![@"M" isEqualToString:wezone.manage_type];
    
    // 정보 뷰
    UIView *sub = [view viewWithTag:3];
    [sub setY:[Layout aspecValue:y2]];
    
    // 날짜
    ((UILabel *)[view viewWithTag:4]).text = [GALDateUtils getChageDateType:@"yyyy-MM-dd HH:mm:ss" withOutputType:@"yyyy-MM-dd" withStrDate:wezone.update_datetime];
    
    // 게시글
    ((UILabel *)[view viewWithTag:6]).text = [NSString stringWithFormat:@"게시글"];
   
    // 멤버
    ((UILabel *)[view viewWithTag:8]).text = [NSString stringWithFormat:@"멤버"];
    y3 += 20;
    
    // 타이틀
    UILabel *label1 = [view viewWithTag:9];
    label1.text = wezone.title;
    [label1 sizeToFit];
    y3 += [Layout revert:label1.frame.size.height] + 10;
    
    // 해시태그
    UILabel *label2 = [view viewWithTag:10];
    label2.text = wezone.hashtag;
    [label2 sizeToFit];
    [label2 posBelow:label1 margin:[Layout aspecValue:10]];
    y3 += [Layout revert:label2.frame.size.height] + 10;
    y2 += y3;
    
    [sub setHeight:[Layout aspecValue:y3]];
    [view setHeight:[Layout aspecValue:y2]];
    
    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
    [data setValue:wezone forKey:@"wezone"];
    
    view.data = data;
    [_viewPool setObject:view forKey:wezone.wezone_id];
    
    return [Layout revert:view.frame.size.height];
}

- (float)resizeWezone:(CommonDataView *)view x:(float)x y:(float)y {
    
    if ( view == nil ) return 0;
    
    [view setPosition:CGPointMake([Layout aspecValue:x], [Layout aspecValue:y])];
    
    UIImageView *img = [view viewWithTag:1];
    UIView *sub = [view viewWithTag:3];
    
    [sub posBelow:img margin:[Layout aspecValue:5]];
    
    [view sizeToFitHeight:sub padding:0];
  
    return [Layout revert:view.frame.size.height];
}

- (void)onClickWezone:(UIGestureRecognizer *)gesture {
    
    CommonDataView *view = (CommonDataView *)gesture.view;
    
    WezoneModel *wezone = [view.data objectForKey:@"wezone"];
    
    WezoneDetailViewController *vc = [[WezoneDetailViewController alloc] initWithWezone:wezone];
    [ApplicationDelegate.mainNaviController pushViewController:vc animated:YES];
}

@end
