//
//  WezoneDetailViewController.m
//  wezone
//
//  Created by Kim Sunmi on 2017. 3. 17..
//  Copyright © 2017년 Kim Sunmi. All rights reserved.
//

#import "WezoneDetailViewController.h"
#import "UIFont+Layout.h"

#import "WezoneBoardViewController.h"
#import "WezoneCommentViewController.h"
#import "WezoneBoardDetailViewController.h"
#import "WezoneManagerViewController.h"
#import "WezoneMemberViewController.h"

#import "NMapViewResources.h"
#import <NMapViewerSDK/NMapView.h>

#define VIEW_COMMENT        100000
#define VIEW_BOARD          200000
#define VIEW_MEMBER         300000

@interface WezoneDetailViewController ()<UIScrollViewDelegate, UIPopoverPresentationControllerDelegate, NMapViewDelegate, NMapPOIdataOverlayDelegate>
{
    WezoneModel *_wezone;
    
    UIView *_instroduceView;
    UIButton *_tabInfo;
    UIButton *_tabBoard;
    UIButton *_tabMember;
    UIView *_tabIndicator;
    UIView *_tabBarView;
    UIScrollView *_tabView;
    UIView *_infoView;
    UIView *_commentHeaderView;
    
    UIView *_commentView;
    UIView *_boardView;
    UIView *_memberView;
    
    float _tabBarPos;
    
    NSMutableArray *_commentList;
    NSMutableArray *_boardList;
    NSMutableArray *_memberList;
    
    NMapView *_mapView;
    
    int _selectedTab;
}
@end

@implementation WezoneDetailViewController

- (instancetype)initWithWezone:(WezoneModel *)wezone {
    
    self = [self init];
    if ( self ) {
        _wezone = wezone;
        
        _commentList = [NSMutableArray array];
        _boardList = [NSMutableArray array];
        _memberList = [NSMutableArray array];
        
        _selectedTab = 0;
        
    }
    
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self makeWezone];
}

- (void)viewWillAppear:(BOOL)animated {
 
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.tintColor = [UIColor clearColor];
    
    [self getWezoneCommentList:0 limit:10];
    [self getWezoneBoardList:0 limit:10];
    [self getWezoneMemberList:0 limit:10];
    
    //[self addMarkers];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.tintColor = [ThemeUtil naviColor];
}


#pragma mark -
#pragma mark Layout

- (void)makeLayout {
    
    [self makeRoot:YES title:nil bgColor:UIColorFromRGB(0xeeeeee)];
    [self makeLeftBackButton];
    
    self.scrollView.delegate = self;
}

- (void)makeWezone {
    
    [CommonUtil removeAllChildView:self.bodyView];
    
    float y = 0;
    float w = [Layout revert:self.bodyView.frame.size.width];
    
    self.titleView = [[UIView alloc] init:[Layout aspecRect:CGRectMake(0, 0, w, 150)] parent:self.bodyView tag:0 color:[ThemeUtil naviColor]];
    
    UIImageView *img = [[UIImageView alloc] init:[Layout aspecRect:CGRectMake(0, 0, w, 150)] parent:self.titleView tag:0 imageName:nil];
    if ( _wezone.bg_img_url ) {
        [[GALLangtudyEngine sharedEngine] getImageWithUrl:_wezone.bg_img_url completionHandler:^(UIImage *image, BOOL isInCache) {
            if ( image ) {
                img.image = image;
                float rate = image.size.height / image.size.width;
                [img setHeight:img.frame.size.width * rate];
                [img setContentMode:UIViewContentModeScaleAspectFit];
                
                [self.titleView setHeight:img.frame.size.height];
                [self.subTitleView setY:self.titleView.frame.origin.y + self.titleView.frame.size.height - 67 / 2];
                
                [_instroduceView posBelow:self.titleView margin:0];
                [_tabBarView posBelow:_instroduceView margin:3];
                [_tabView posBelow:_tabBarView margin:3];
                [self setTabViewSize];
                
                _tabBarPos = _tabBarView.frame.origin.y;
                
            }
        } errorHandler:^(NSDictionary *data, NSError *error) {
            
        }];
    }
    y += [Layout revert:self.titleView.frame.size.height];
    
    self.subTitleView = [[UIView alloc] init:[Layout aspecRect:CGRectMake((w - 67) / 2, y - 67 / 2, 67, 67)] parent:self.bodyView tag:0 color:nil];
    UIImageView *profileImg = [[UIImageView alloc] init:[Layout aspecRect:CGRectMake(0, 0, 67, 67)] parent:self.subTitleView tag:0 imageName:@"ic_bunny_image"];
    if ( _wezone.img_url ) {
        [[GALLangtudyEngine sharedEngine] getImageWithUrl:_wezone.img_url completionHandler:^(UIImage *image, BOOL isInCache) {
            if ( image ) {
                profileImg.image = image;
                //float rate = image.size.height / image.size.width;
                //[img setHeight:img.frame.size.width * rate];
                //[img setContentMode:UIViewContentModeScaleAspectFit];
            }
        } errorHandler:^(NSDictionary *data, NSError *error) {
            
        }];
    }
    
    y += [self makeIntroduce:y w:w] + 3;
    y += [self makeTab:y w:w] + 3;
    y += [self makeTabView:y w:w];
    
    [self setBodyHiehgt:[Layout aspecValue:y]];
    
    [self selectTab:_selectedTab];
    
    [self.bodyView bringSubviewToFront:_tabBarView];
    
    [self.bodyView bringSubviewToFront:self.titleView];
    [self.bodyView bringSubviewToFront:self.subTitleView];
}

#pragma mark -
#pragma mark Introduce

- (float)makeIntroduce:(float)y w:(float)w {
    
    float x = 15;
    
    UIView *view = [[UIView alloc] init:[Layout aspecRect:CGRectMake(0, y, w, self.bodyView.frame.size.height)] parent:self.bodyView tag:0 color:UIColorFromRGB(0xffffff)];
    
    _instroduceView = view;
    
    y = 0;
    y += 67 / 2 + 10;
    
    if ( [_wezone.manage_type isEqualToString:@"M"] ) {
        [[[UIButton alloc] init:[Layout aspecRect:CGRectMake(w - 35, 10, 25, 25)] parent:view tag:0 target:self action:@selector(onClickManager)] addImageName:@"ic_menu_set"];
    }
    
    //  위존 타이틀
    NSString *title = _wezone.title;
    UILabel *label1 = [[UILabel alloc] init:[Layout aspecRect:CGRectMake(x, y, w - x * 2, 30)] parent:view tag:0 text:title color:UIColorFromRGB(0x212121) bgColor:nil align:NSTextAlignmentCenter font:@"bold" size:[Layout aspecValue:SIZE_TEXT_M]];
    [label1 sizeToFitHeight];
    y += [Layout revert:label1.frame.size.height] + 10;
    
    // 소개 문구
    NSString *introduction = _wezone.introduction;
    UILabel *label2 = [[UILabel alloc] init:[Layout aspecRect:CGRectMake(x, y, w - x * 2, 30)] parent:view tag:0 text:introduction color:UIColorFromRGB(0x757575) bgColor:nil align:NSTextAlignmentCenter font:nil size:[Layout aspecValue:SIZE_TEXT_S]];
    [label2 sizeToFitHeight];
    y += [Layout revert:label2.frame.size.height] + 10;
    
    // 거리
    NSString *distance = [NSString stringWithFormat:@"%@m", [CommonUtil moneyFormat:_wezone.distance maxFraction:1]];
    
    [[UIImageView alloc] init:[Layout aspecRect:CGRectMake(w / 2 - 20, y, 14, 14)] parent:view tag:0 imageName:@"ic_distance"];
    [[UILabel alloc] init:[Layout aspecRect:CGRectMake(w / 2, y, w / 2, 14)] parent:view tag:0 text:distance color:UIColorFromRGB(0x757575) bgColor:nil align:NSTextAlignmentLeft font:nil size:[Layout aspecValue:SIZE_TEXT_S]];
    y += 14 + 10;
    
    NSLog(@"wezone location_type = %@, zone_possible = %@", _wezone.location_type, _wezone.zone_possible);
    //  버튼
    if ( _wezone.isJoin ) {
        
        [[[[UIButton alloc] init:[Layout aspecRect:CGRectMake(0, y, w / 2, 40)] parent:view tag:0 target:self action:@selector(onClickGroupChat)]
          addTitle:[self getStringWithKey:@"wezone_group_chat"]] icontextStyle:@"btn_group_chat"];
        
        [[[[UIButton alloc] init:[Layout aspecRect:CGRectMake(w / 2 - 1, y, w / 2 + 1, 40)] parent:view tag:0 target:self action:@selector(onClickBoard)]
          addTitle:[self getStringWithKey:@"wezone_write"]] icontextStyle:@"btn_edit_contents_black"];
        
    } else if ( [_wezone.location_type isEqualToString:@"G"] && [_wezone.zone_possible isEqualToString:@"T"] ) {
        
        [[[[UIButton alloc] init:[Layout aspecRect:CGRectMake(0, y, w, 40)] parent:view tag:0 target:self action:@selector(onClickWezoneJoin)]
          addTitle:[self getStringWithKey:@"wezone_join"]] icontextStyle:@"btn_enter_blue"];
        
    } else if ( [_wezone.location_type isEqualToString:@"G"] && ![_wezone.zone_possible isEqualToString:@"T"] ) {
        
        NSString *desc = [NSString stringWithFormat:[self getStringWithKey:@"wezone_impossible_desc"], [CommonUtil moneyFormat:_wezone.distance / 2 maxFraction:1]];
        UILabel *label3 = [[UILabel alloc] init:[Layout aspecRect:CGRectMake(x, y, w - x * 2, 14)] parent:view tag:0 text:desc color:UIColorFromRGB(0x757575) bgColor:nil align:NSTextAlignmentLeft font:nil size:[Layout aspecValue:SIZE_TEXT_SS]];
        [label3 sizeToFitHeight];
        y += [Layout revert:label3.frame.size.height] + 10;
        
        [[[[UIButton alloc] init:[Layout aspecRect:CGRectMake(0, y, w, 40)] parent:view tag:0]
          addTitle:[self getStringWithKey:@"wezone_impossible"]] icontextStyle:@"btn_enter_blue"];
        
    } else if ( [_wezone.location_type isEqualToString:@"B"] ) {
        
        NSString *desc = [NSString stringWithFormat:[self getStringWithKey:@"wezone_wait_desc"], _wezone.title];
        UILabel *label3 = [[UILabel alloc] init:[Layout aspecRect:CGRectMake(x, y, w - x * 2, 14)] parent:view tag:0 text:desc color:UIColorFromRGB(0x757575) bgColor:nil align:NSTextAlignmentLeft font:nil size:[Layout aspecValue:SIZE_TEXT_SS]];
        [label3 sizeToFitHeight];
        y += [Layout revert:label3.frame.size.height] + 10;
        
        [[[[UIButton alloc] init:[Layout aspecRect:CGRectMake(0, y, w, 40)] parent:view tag:0 target:self action:@selector(onClickWezoneJoin)]
          addTitle:[self getStringWithKey:@"wezone_wait"]] icontextStyle:@"btn_enter_blue"];
        
    } else {
    
        [[[[UIButton alloc] init:[Layout aspecRect:CGRectMake(0, y, w / 2, 40)] parent:view tag:0 target:self action:@selector(onClickGroupChat)]
          addTitle:[self getStringWithKey:@"wezone_group_chat"]] icontextStyle:@"btn_group_chat"];

        [[[[UIButton alloc] init:[Layout aspecRect:CGRectMake(w / 2 - 1, y, w / 2 + 1, 40)] parent:view tag:0 target:self action:@selector(onClickBoard)]
          addTitle:[self getStringWithKey:@"wezone_write"]] icontextStyle:@"btn_edit_contents_black"];
        
    }
    y += 40;
    
    [view setHeight:[Layout aspecValue:y]];
    [view setShadow:[UIColor blackColor] opacity:0.2 radius:1];
    
    return y;
}

- (void)onClickGroupChat {
    
}

- (void)onClickBoard {
    
    WezoneBoardViewController *vc = [[WezoneBoardViewController alloc] init:_wezone board:nil];
    [ApplicationDelegate.mainNaviController pushViewController:vc animated:YES];
}

- (void)onClickWezoneJoin {
    
    [self sendWezoneJoin];
}

- (void)onClickManager {
    
    WezoneManagerViewController *vc = [[WezoneManagerViewController alloc] init:_wezone];
    [ApplicationDelegate.mainNaviController pushViewController:vc animated:YES];
}

#pragma mark -
#pragma mark Tab

- (float)makeTab:(float)y w:(float)w {
    
    float x = 15;
    
    UIView *view = [[UIView alloc] init:[Layout aspecRect:CGRectMake(0, y, w, 40)] parent:self.bodyView tag:0 color:UIColorFromRGB(0xffffff)];
    [view setShadow:[UIColor blackColor] opacity:0.2 radius:1];
    
    _tabBarView = view;
    _tabBarPos = [Layout aspecValue:y];
    
    y = 0;
    
    _tabInfo = [[[UIButton alloc] init:[Layout aspecRect:CGRectMake(0, y, w / 3, 40)] parent:view tag:0 target:self action:@selector(onClickTab:)]
      addTitle:[self getStringWithKey:@"wezone_detail_info"] normalColor:UIColorFromRGB(0x212121) highlightedColor:UIColorFromRGB(0x689df9) disabledColor:nil font:nil size:[Layout aspecValue:SIZE_TEXT_S]];
    
    _tabBoard = [[UIButton alloc] init:[Layout aspecRect:CGRectMake(w / 3, y, w / 3, 40)] parent:view tag:0 target:self action:@selector(onClickTab:)];
    [self setTabButtonText:_tabBoard title:[self getStringWithKey:@"wezone_board"] surfix:[NSString stringWithFormat:@" %d", 0]];
    
    _tabMember = [[UIButton alloc] init:[Layout aspecRect:CGRectMake(w / 3 * 2, y, w / 3, 40)] parent:view tag:0 target:self action:@selector(onClickTab:)];
    [self setTabButtonText:_tabMember title:[self getStringWithKey:@"wezone_member"] surfix:[NSString stringWithFormat:@" %d", 0]];
    
    y += 40;
    
    [UIView makeBottomLine:[Layout aspecRect:CGRectMake(0, y - 1, w, 1)] parent:view tag:0 color:UIColorFromRGB(0x9e9e9e)];
    _tabIndicator = [[UIView alloc] init:[Layout aspecRect:CGRectMake(0, y - 2, w / 3, 2)] parent:view tag:0 color:UIColorFromRGB(0x689df9)];
    
    return y;
}

- (void)setTabButtonText:(UIButton *)button title:(NSString *)title surfix:(NSString *)surfix {
    
    NSString *text = [NSString stringWithFormat:@"%@%@", title, surfix];
    
    [button.titleLabel setFont:[UIFont defalutFont:nil size:[Layout aspecValue:SIZE_TEXT_S]]];
    
    NSMutableAttributedString *normal = [[NSMutableAttributedString alloc] initWithString:text];
    [normal addAttributes:@{NSForegroundColorAttributeName:UIColorFromRGB(0x212121)} range:NSMakeRange(0, title.length)];
    [normal addAttributes:@{NSForegroundColorAttributeName:UIColorFromRGB(0x757575)} range:NSMakeRange(title.length, surfix.length)];
    
    [button setAttributedTitle:normal forState:UIControlStateNormal];
    
    NSMutableAttributedString *selected = [[NSMutableAttributedString alloc] initWithString:text];
    [selected addAttributes:@{NSForegroundColorAttributeName:UIColorFromRGB(0x689df9)} range:NSMakeRange(0, title.length)];
    [selected addAttributes:@{NSForegroundColorAttributeName:UIColorFromRGBA(0x689df9aa)} range:NSMakeRange(title.length, surfix.length)];
    
    [button setAttributedTitle:selected forState:UIControlStateSelected];
}

- (float)makeTabView:(float)y w:(float)w {
    
    float x = 15;
    
    _tabView = [[UIScrollView alloc] init:[Layout aspecRect:CGRectMake(0, y, w, self.bodyView.frame.size.height)] parent:self.bodyView tag:0 color:UIColorFromRGB(0xeeeeee)];
    _tabView.delegate = self;
    _tabView.pagingEnabled = YES;
    _tabView.bounces = NO;
    _tabView.showsHorizontalScrollIndicator = NO;
    
    [_tabView setContentSize:CGSizeMake(_tabView.frame.size.width * 3, _tabView.frame.size.height)];
    
    y = 0;
    
    float y1 = [self makeInfoView:_tabView x:1 y:y w:w - 2] + 3;
    _commentView = [[UIView alloc] init:[Layout aspecRect:CGRectMake(1, y1, w - 2, 0)] parent:_tabView tag:0 color:UIColorFromRGB(0xeeeeee)];
    
    _boardView = [[UIView alloc] init:[Layout aspecRect:CGRectMake(w + 1, y, w - 2, 0)] parent:_tabView tag:0 color:UIColorFromRGB(0xeeeeee)];
    _memberView = [[UIView alloc] init:[Layout aspecRect:CGRectMake(w * 2 + 1, y, w - 2, 0)] parent:_tabView tag:0 color:UIColorFromRGB(0xeeeeee)];
    
    return 500;
}

- (void)onClickTab:(UIButton *)button {
    
    if ( button == _tabInfo ) [self moveTab:0];
    if ( button == _tabBoard ) [self moveTab:1];
    if ( button == _tabMember ) [self moveTab:2];
}

- (void)moveTab:(int)index {
    
    _selectedTab = index;
    
    _tabInfo.selected = index == 0;
    _tabBoard.selected = index == 1;
    _tabMember.selected = index == 2;
    
    [_tabView setContentOffset:CGPointMake(_tabView.frame.size.width * index, 0) animated:YES];
    
    [self setTabViewSize];
}

- (void)selectTab:(int)index {
    
    _selectedTab = index;
    
    _tabInfo.selected = index == 0;
    _tabBoard.selected = index == 1;
    _tabMember.selected = index == 2;
    
    [_tabIndicator setX:_tabView.frame.size.width / 3 * index];
    [self setTabViewSize];
}


- (void)setTabViewSize {
    
    float h = _commentView.frame.origin.y + _commentView.frame.size.height;
    if ( _selectedTab == 1 ) h = _boardView.frame.origin.y + _boardView.frame.size.height;
    if ( _selectedTab == 2 ) h = _memberView.frame.origin.y + _memberView.frame.size.height;
    
    [_tabView setHeight:MAX(h, self.scrollView.frame.size.height - _tabView.frame.origin.y)];
    [_tabView setContentSize:CGSizeMake(_tabView.frame.size.width * 3, _tabView.frame.size.height)];
    
    [self setBodyHiehgt:_tabView.frame.origin.y + _tabView.frame.size.height];
    
    NSLog(@"setTabViewSize : %d %f", _selectedTab, h);
}


#pragma mark -
#pragma mark Detail Info

- (float) makeInfoView:(UIView *)parent x:(float)x y:(float)y w:(float)w {
    
    _infoView = [[UIView alloc] init:[Layout aspecRect:CGRectMake(x, y, w, 200)] parent:parent tag:0 color:UIColorFromRGB(0xffffff)];
    [_infoView setShadow:[UIColor blackColor] opacity:0.2 radius:1];
    
    x = 15;
    y = 0;
    
    if ( [_wezone.manage_type isEqualToString:@"M"] ) {
        UIView *indicatorView = [[UIView alloc] init:[Layout aspecRect:CGRectMake(0, y, w, 40)] parent:_infoView tag:0 color:UIColorFromRGB(0x669cf8)];
        [indicatorView addTarget:self action:@selector(onClickLocation)];
        [[UIImageView alloc] init:[Layout aspecRect:CGRectMake(w / 2 - 40, (40 - 14) / 2, 14, 14)] parent:indicatorView tag:0 imageName:@"ic_cached_white"];
        [[UILabel alloc] init:[Layout aspecRect:CGRectMake(w / 2 - 20, 0, w / 2, 40)] parent:indicatorView tag:0 text:[self getStringWithKey:@"wezone_update_location"] color:UIColorFromRGB(0xffffff) bgColor:nil align:NSTextAlignmentLeft font:nil size:[Layout aspecValue:SIZE_TEXT_S]];
        y += 40;
    }
    
    // 지도
    UIView *view = [[UIView alloc] init:[Layout aspecRect:CGRectMake(0, y, w, 200)] parent:_infoView tag:0 color:UIColorFromRGB(0xeeeeee)];
    
    _mapView = [[NMapView alloc] initWithFrame:[Layout aspecRect:CGRectMake(0, 0, w, 200)]];
    [_mapView setDelegate:self];
    [_mapView setClientId:NAVER_CLIENT_ID];
    [view addSubview:_mapView];
    
    y += 200 + 10;
    
    // 주소
    UILabel *label2 = [[UILabel alloc] init:[Layout aspecRect:CGRectMake(x, y, w - x * 2, 30)] parent:_infoView tag:0 text:_wezone.address color:UIColorFromRGB(0x212121) bgColor:nil align:NSTextAlignmentCenter font:nil size:[Layout aspecValue:SIZE_TEXT_S]];
    if ( _wezone.address ) {
        [label2 sizeToFitHeight:30];
    }
    y += [Layout revert:label2.frame.size.height] + 10;

    [_infoView setHeight:[Layout aspecValue:y]];
    
    return y;
}

- (void)makeCommentList:(NSArray *)list total:(int)total{
    
    [_commentList addObjectsFromArray:list];
    
    [CommonUtil removeAllChildView:_commentView];
    
    float x = 0;
    float w = [Layout revert:_commentView.frame.size.width];
    float y = 0;
    int index = 0;
    
    UIView *titleView = [[UIView alloc] init:[Layout aspecRect:CGRectMake(x, y, w, 40)] parent:_commentView tag:0 color:UIColorFromRGB(0xffffff)];
    [titleView setShadow:[UIColor blackColor] opacity:0.2 radius:1];
    
    UILabel *label = [[UILabel alloc] init:[Layout aspecRect:CGRectMake(15, 0, w / 2, 40)] parent:titleView tag:0 text:[self getStringWithKey:@"wezone_review"] color:UIColorFromRGB(0x212121) bgColor:nil align:NSTextAlignmentLeft font:nil size:[Layout aspecValue:SIZE_TEXT_S]];
    [label sizeToFitWidth];
    
    [[UILabel alloc] init:[Layout aspecRect:CGRectMake([Layout revert:label.frame.origin.x + label.frame.size.width] + 5, 0, w / 2, 40)] parent:titleView tag:0 text:[NSString stringWithFormat:@"%d", total] color:UIColorFromRGB(0x689df9) bgColor:nil align:NSTextAlignmentLeft font:nil size:[Layout aspecValue:SIZE_TEXT_S]];
    
    [[[UIButton alloc] init:[Layout aspecRect:CGRectMake(w - 60, 0, 50, 40)] parent:titleView tag:0 target:self action:@selector(onClickComment)]
     addTitle:[self getStringWithKey:@"wezone_write"] normalColor:UIColorFromRGB(0x689df9) highlightedColor:nil disabledColor:nil font:nil size:[Layout aspecValue:SIZE_TEXT_S]];
    y += 43;
    
    for( WezoneComment *comment in _commentList) {
        index++;
        y += [self makeComment:comment parent:_commentView tag:index x:x y:y w:w];
    }
    if ( _commentList.count < total ) {
        index++;
        y += [self makeFooter:(int)(total -_commentList.count) parent:_commentView tag:index x:x y:y w:w selector:@selector(onClickMoreComment)];
    }
    [_commentView setHeight:[Layout aspecValue:y]];
}

- (float)makeComment:(WezoneComment *)comment parent:(UIView *)parent tag:(int)tag x:(float)x y:(float)y w:(float)w {
    
    UIView *view = [[UIView alloc] init:[Layout aspecRect:CGRectMake(x, y, w, 80)] parent:parent tag:tag color:UIColorFromRGB(0xffffff)];
    
    UIImageView *profile = [[UIImageView alloc] init:[Layout aspecRect:CGRectMake(10, 10, 30, 30)] parent:view tag:0 imageName:nil];
    [profile setBackgroundColor:UIColorFromRGB(0xeeeeee)];
    profile.layer.cornerRadius = profile.frame.size.width / 2;
    profile.clipsToBounds = YES;
    
    if ( comment.img_url ) {
        [[GALLangtudyEngine sharedEngine] getImageWithUrl:comment.img_url completionHandler:^(UIImage *image, BOOL isInCache) {
            if ( image ) {
                profile.image = image;
            }
        } errorHandler:^(NSDictionary *data, NSError *error) {
            
        }];
    }
    
    y = 10;
    UILabel *nameLabel = [[UILabel alloc] init:[Layout aspecRect:CGRectMake(50, y, w - 60, SIZE_TEXT_S)] parent:view tag:0 text:comment.user_name color:UIColor_text bgColor:nil align:NSTextAlignmentLeft font:nil size:[Layout aspecValue:SIZE_TEXT_SS]];
    [nameLabel sizeToFit];
    y += [Layout revert:nameLabel.frame.size.height] + 5;
    
    UILabel *commentLabel = [[UILabel alloc] init:[Layout aspecRect:CGRectMake(50, y, w - 60, SIZE_TEXT_S)] parent:view tag:0 text:comment.content color:UIColor_text bgColor:nil align:NSTextAlignmentLeft font:nil size:[Layout aspecValue:SIZE_TEXT_SS]];
    [commentLabel sizeToFit];
    y += [Layout revert:commentLabel.frame.size.height] + 5;
    
    NSString *date = [GALDateUtils getChageDateType:STR(@"server_date_format") withOutputType:STR(@"display_date_format") withStrDate:comment.create_datetime];
    UILabel *dateLebel = [[UILabel alloc] init:[Layout aspecRect:CGRectMake(50, y, w - 60, SIZE_TEXT_S)] parent:view tag:0 text:date color:UIColor_sub_text bgColor:nil align:NSTextAlignmentLeft font:nil size:[Layout aspecValue:SIZE_TEXT_SS]];
    y += SIZE_TEXT_S + 10;
   
    [UIView makeBottomLine:[Layout aspecRect:CGRectMake(x, y, w, 1)] parent:view tag:0 color:UIColor_line];
    y += 1;
    
    [view setHeight:[Layout aspecValue:MAX(50, y)]];
        
    return [Layout revert:view.frame.size.height];
}

- (float)makeFooter:(int)count parent:(UIView *)parent tag:(int)tag x:(float)x y:(float)y w:(float)w selector:(SEL)selector {
    
    UIView *footerView = [[UIView alloc] init:[Layout aspecRect:CGRectMake(x, y, w, 40)] parent:parent tag:tag color:UIColorFromRGB(0xffffff)];
    [footerView addTarget:self action:selector];
    
    //[titleView setShadow:[UIColor blackColor] opacity:0.2 radius:1];
    
    [[UIImageView alloc] init:[Layout aspecRect:CGRectMake(w / 2 - 40, (40 - 13) / 2, 13, 13)] parent:footerView tag:0 imageName:@"ic_scan"];
    
    NSString *text = [NSString stringWithFormat:[self getStringWithKey:@"list_more_load"], count];
    [[UILabel alloc] init:[Layout aspecRect:CGRectMake(w / 2 - 20, 0, w / 2, 40)] parent:footerView tag:0 text:text color:UIColor_sub_text bgColor:nil align:NSTextAlignmentLeft font:nil size:[Layout aspecValue:SIZE_TEXT_S]];
    
    return 40;
}

- (void)onClickComment {
    
    WezoneCommentViewController *vc = [[WezoneCommentViewController alloc] init:_wezone comment:nil];
    [ApplicationDelegate.mainNaviController pushViewController:vc animated:YES];
}

- (void)onClickMoreComment {
    
    [self getWezoneCommentList:(int)_commentList.count limit:10];
}

- (void)onClickLocation {

    NSString *latitude = [NSString stringWithFormat:@"%f", [LocationManager sharedLocationManager].latitude];
    NSString *longitude = [NSString stringWithFormat:@"%f", [LocationManager sharedLocationManager].longitude];

    NSArray *wezone_info = @[@{@"flag":@"latitude", @"val":latitude}, @{@"flag":@"longitude", @"val":longitude}];
    
    [[GALLangtudyEngine sharedEngine] sendModifyWezone:_wezone.wezone_id wezone_info:wezone_info resultHandler:^() {
        
        _wezone.latitude = latitude;
        _wezone.longitude = longitude;
        [self makeWezone];
        
    } errorHandler:^(NSDictionary *data, NSError *error) {
        [self showErrorToast:data error:error];
    }];
}

#pragma mark -
#pragma mark Board

- (void)makeBoardList:(NSArray *)list total:(int)total{
    
    [self setTabButtonText:_tabBoard title:[self getStringWithKey:@"wezone_board"] surfix:[NSString stringWithFormat:@" %d", total]];
    
    [_boardList addObjectsFromArray:list];
    
    [CommonUtil removeAllChildView:_boardView];
    
    float x = 0;
    float w = [Layout revert:_boardView.frame.size.width];
    float y = 0;
    
    int noticeCount = 0;
    for( WezoneBoard *board in _boardList) {
        if ( [board.notice_flag isEqualToString:@"T"] ) {
            noticeCount++;
        }
    }
    
    UIView *titleView = [[UIView alloc] init:[Layout aspecRect:CGRectMake(x, y, w, 40)] parent:_boardView tag:0 color:UIColorFromRGB(0xffffff)];
    [titleView setShadow:[UIColor blackColor] opacity:0.2 radius:1];
    
    UILabel *label = [[UILabel alloc] init:[Layout aspecRect:CGRectMake(15, 0, w / 2, 40)] parent:titleView tag:0 text:[self getStringWithKey:@"wezone_board_notice"] color:UIColorFromRGB(0x212121) bgColor:nil align:NSTextAlignmentLeft font:nil size:[Layout aspecValue:SIZE_TEXT_S]];
    [label sizeToFitWidth];
    
    [[UILabel alloc] init:[Layout aspecRect:CGRectMake([Layout revert:label.frame.origin.x + label.frame.size.width] + 5, 0, w / 2, 40)] parent:titleView tag:0 text:[NSString stringWithFormat:@"%d", noticeCount] color:UIColorFromRGB(0x689df9) bgColor:nil align:NSTextAlignmentLeft font:nil size:[Layout aspecValue:SIZE_TEXT_S]];
    y += 41;
    
    for( int i=0; i<_boardList.count; i++ ) {
        
        WezoneBoard *board = [_boardList objectAtIndex:i];
        if ( [board.notice_flag isEqualToString:@"T"] ) {
            y += [self makeNotice:board parent:_boardView tag:i + 1 x:x y:y w:w];
        }
    }
    y += 3;
    
    for( int i=0; i<_boardList.count; i++ ) {
        
        WezoneBoard *board = [_boardList objectAtIndex:i];
        
        if ( [board.notice_flag isEqualToString:@"F"] ) {
            y += [self makeBoard:board parent:_boardView tag:i + 1 x:x y:y w:w];
            y += [Layout aspecValue:3];
        }
    }
    if ( _boardList.count < total ) {
        y += [self makeFooter:(int)(total -_boardList.count) parent:_boardView tag:(int)_boardList.count + 1 x:x y:y w:w selector:@selector(onClickMoreBoard)];
    }
    [_boardView setHeight:[Layout aspecValue:y]];
    
    [self resizeBoardList];
}

- (float)makeNotice:(WezoneBoard *)board parent:(UIView *)parent tag:(int)tag x:(float)x y:(float)y w:(float)w {
    
    UIView *view = [[UIView alloc] init:[Layout aspecRect:CGRectMake(x, y, w, 40)] parent:parent tag:tag color:UIColorFromRGB(0xffffff)];
    [view addTarget:self action:@selector(onClickBoardDetail:)];
    [view setClipsToBounds:YES];
    
    UILabel *commentLabel = [[UILabel alloc] init:[Layout aspecRect:CGRectMake(15, 0, w - 60, 40)] parent:view tag:0 text:board.content color:UIColor_text bgColor:nil align:NSTextAlignmentLeft font:nil size:[Layout aspecValue:SIZE_TEXT_SS]];
    
    [[[UIButton alloc] init:[Layout aspecRect:CGRectMake(w - 30, 10, 25, 25)] parent:view tag:0 target:self action:@selector(onClickAddFriend:)]
      addImageName:@"btn_chevron_right_black"];
    
    [UIView makeBottomLine:[Layout aspecRect:CGRectMake(x, 39, w, 1)] parent:view tag:0 color:UIColor_line];
    
    return [Layout revert:view.frame.size.height];
}

- (float)makeBoard:(WezoneBoard *)board parent:(UIView *)parent tag:(int)tag x:(float)x y:(float)y w:(float)w {
    
    UIView *view = [[UIView alloc] init:[Layout aspecRect:CGRectMake(x, y, w, 80)] parent:parent tag:tag color:UIColorFromRGB(0xffffff)];
    [view addTarget:self action:@selector(onClickBoardDetail:)];
    [view setClipsToBounds:YES];
    
    UIImageView *profile = [[UIImageView alloc] init:[Layout aspecRect:CGRectMake(10, 10, 40, 40)] parent:view tag:0 imageName:nil];
    [profile setBackgroundColor:UIColorFromRGB(0xeeeeee)];
    profile.layer.cornerRadius = profile.frame.size.width / 2;
    profile.clipsToBounds = YES;
    
    if ( board.img_url ) {
        [[GALLangtudyEngine sharedEngine] getImageWithUrl:board.img_url completionHandler:^(UIImage *image, BOOL isInCache) {
            if ( image ) {
                profile.image = image;
            }
        } errorHandler:^(NSDictionary *data, NSError *error) {
            
        }];
    }
    
    y = 12;
    UILabel *nameLabel = [[UILabel alloc] init:[Layout aspecRect:CGRectMake(60, y, w - 70, SIZE_TEXT_S + 2)] parent:view tag:0 text:board.user_name color:UIColor_text bgColor:nil align:NSTextAlignmentLeft font:nil size:[Layout aspecValue:SIZE_TEXT_S]];
    y += SIZE_TEXT_S + 5;

    NSString *date = [GALDateUtils getChageDateType:STR(@"server_date_format") withOutputType:STR(@"display_date_format") withStrDate:board.create_datetime];
    UILabel *dateLebel = [[UILabel alloc] init:[Layout aspecRect:CGRectMake(60, y, w - 70, SIZE_TEXT_S + 2)] parent:view tag:0 text:date color:UIColor_sub_text bgColor:nil align:NSTextAlignmentLeft font:nil size:[Layout aspecValue:SIZE_TEXT_S]];
    y += SIZE_TEXT_S + 12;
    
    if ( [board.uuid isEqualToString:ApplicationDelegate.loginData.user_info.uuid] ) {
        
        UIButton *button = [[[UIButton alloc] init:[Layout aspecRect:CGRectMake(w - 35, 10, 25, 25)] parent:view tag:0 target:self action:@selector(onClickBoardMenu:)]
                            addImageName:@"btn_more_black"];
    }
    
    y = 60;
    UIImageView *img = [[UIImageView alloc] init:[Layout aspecRect:CGRectMake(0, y, w, 0)] parent:view tag:0 imageName:nil];
    
    UILabel *contentLabel = [[UILabel alloc] init:[Layout aspecRect:CGRectMake(15, y, w - 30, 100)] parent:view tag:0 text:board.content color:UIColor_text bgColor:nil align:NSTextAlignmentLeft font:nil size:[Layout aspecValue:SIZE_TEXT_SS]];
    [contentLabel sizeToFit];
    y += [Layout revert:contentLabel.frame.size.height] + 10;
    
    UIView *commentView = [[UIView alloc] init:[Layout aspecRect:CGRectMake(x, y, w, 0)] parent:view tag:0 color:UIColorFromRGB(0xffffff)];
    if ( board.comments ) {
        y += [self makeBoradCommentList:board.comments total:board.comment_count parent:commentView];
    }
    
    UIView *line = [UIView makeBottomLine:[Layout aspecRect:CGRectMake(x, y, w, 1)] parent:view tag:0 color:UIColor_line];
    //y += 1;
    
    if ( [board.board_file count] > 0 ) {
        
        NSDictionary *file = [board.board_file objectAtIndex:0];
        
        [img setBackgroundColor:UIColorFromRGB(0xeeeeee)];
        
        if ( [file valueForKey:@"url"] ) {
            [[GALLangtudyEngine sharedEngine] getImageWithUrl:[file valueForKey:@"url"] completionHandler:^(UIImage *image, BOOL isInCache) {
                if ( image ) {
                    img.image = image;
                    float rate = image.size.height / image.size.width;
                    [img setHeight:img.frame.size.width * rate];
                    [img setContentMode:UIViewContentModeScaleAspectFit];
                    
                    [contentLabel posBelow:img margin:10];
                    [commentView posBelow:contentLabel margin:10];
                    
                    [view sizeToFitHeight:commentView padding:0];
                    [line alignBottom:view margin:0];
                    
                    [self resizeBoardList];
                }
            } errorHandler:^(NSDictionary *data, NSError *error) {
                
            }];
        }
    }
    if ( board.comments == nil ) {
        
        GALLangtudyEngine *engine = [GALLangtudyEngine sharedEngine];
        [engine getWezoneCommentList:_wezone.wezone_id type:@"B" board_id:board.board_id offset:0 limit:10 resultHandler:^(int total_count, NSArray *list){
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                board.comments = list;
                board.comment_count = total_count;
                
                [self makeBoradCommentList:list total:total_count parent:commentView];
                [view sizeToFitHeight:commentView padding:0];
                [line alignBottom:view margin:0];
                
                [self resizeBoardList];
            });
            
        } errorHandler:^(NSDictionary *data, NSError *error) {
            
            NSString *errorCode = data[@"code"];
            NSLog(@"%@",errorCode);
        }];
    }
    
    [view sizeToFitHeight:commentView padding:0];
    [line alignBottom:view margin:0];
    
    return [Layout revert:view.frame.size.height];
}

- (float)makeBoradCommentList:(NSArray *)list total:(int)total parent:(UIView *)parent {
    
    if ( [list count] == 0 ) return 0;
    
    float x = 0;
    float w = [Layout revert:parent.frame.size.width];
    float y = 0;
    int index = 0;
    
    UIView *titleView = [[UIView alloc] init:[Layout aspecRect:CGRectMake(x, y, w, 20)] parent:parent tag:0 color:UIColorFromRGB(0xffffff)];
    
    NSString *text = [NSString stringWithFormat:[self getStringWithKey:@"wezone_comment_all"], total];
    UILabel *label = [[UILabel alloc] init:[Layout aspecRect:CGRectMake(15, 0, w / 2, 20)] parent:titleView tag:0 text:text color:UIColor_sub_text bgColor:nil align:NSTextAlignmentLeft font:nil size:[Layout aspecValue:SIZE_TEXT_SS]];
    y += 20;
    
    for( WezoneComment *comment in list) {
        index++;
        y += [self makeComment:comment parent:parent tag:0 x:x y:y w:w];
        if ( index == 2 ) break;
    }
    
    [parent setHeight:[Layout aspecValue:y]];
    return y;
}

- (void)resizeBoardList {

    float x = 0;
    float y = [Layout aspecValue:41];
    
    for( int i=0; i<_boardList.count; i++ ) {
        
        WezoneBoard *board = [_boardList objectAtIndex:i];
        
        if ( [board.notice_flag isEqualToString:@"T"] ) {
            UIView *view = [_boardView viewWithTag:i + 1];
            y += view.frame.size.height;
        }
    }
    y += [Layout aspecValue:3];
    
    //UIView *view1 = nil;
    for( int i=0; i<_boardList.count; i++ ) {
        
        WezoneBoard *board = [_boardList objectAtIndex:i];
        
        if ( [board.notice_flag isEqualToString:@"F"] ) {
            UIView *view = [_boardView viewWithTag:i + 1];
            if ( view ) {
                [view setY:y];
                y += view.frame.size.height;
                y += [Layout aspecValue:3];
            }
        }
    }
    
    UIView *view = [_boardView viewWithTag:_boardList.count + 1];
    if ( view) {
        [view setY:y];
        y += view.frame.size.height;
    }
    
    //NSLog(@"resizeBoardList: %f", view2)
    [_boardView setHeight:y];
}

- (void)onClickBoardDetail:(UIGestureRecognizer *)gesture {
    
    int index = (int)gesture.view.tag - 1;
    WezoneBoard *board = [_boardList objectAtIndex:index];
    
    WezoneBoardDetailViewController *vc = [[WezoneBoardDetailViewController alloc] init:_wezone board:board];
    [ApplicationDelegate.mainNaviController pushViewController:vc animated:YES];
}

- (void)onClickMoreBoard{
    
    [self getWezoneBoardList:(int)_boardList.count limit:10];
}

- (void)onClickBoardMenu:(UIButton *)button {

    UIViewController *controller = [[UIViewController alloc] init];
    UIView *popoverView = [[UIView alloc]initWithFrame:[Layout aspecRect:CGRectMake(0, 0, 100, 80)]];
    
    [[[UIButton alloc] init:[Layout aspecRect:CGRectMake(10, 0, 60, 40)] parent:popoverView tag:button.superview.tag target:self action:@selector(onClickModifyBoard:)]
       addTitle:[self getStringWithKey:@"wezone_board_modify"] normalColor:UIColorFromRGB(0x212121) highlightedColor:nil disabledColor:nil font:nil size:[Layout aspecValue:SIZE_TEXT_S] align:UIControlContentHorizontalAlignmentLeft];
    
    [[[UIButton alloc] init:[Layout aspecRect:CGRectMake(10, 40, 60, 40)] parent:popoverView tag:button.superview.tag target:self action:@selector(onClickDeleteBoard:)]
     addTitle:[self getStringWithKey:@"delete"] normalColor:UIColorFromRGB(0x212121) highlightedColor:nil disabledColor:nil font:nil size:[Layout aspecValue:SIZE_TEXT_S] align:UIControlContentHorizontalAlignmentLeft];
    
    [UIView makeHorizontalLine:[Layout aspecRect:CGRectMake(0, 40, 100, 1)] parent:popoverView tag:0 color:UIColor_line];
    
    controller.view = popoverView;

    controller.modalPresentationStyle = UIModalPresentationPopover;
    controller.preferredContentSize = popoverView.frame.size;
    
    UIPopoverPresentationController *popover =  controller.popoverPresentationController;
    popover.delegate = self;
    popover.sourceView = button;
    popover.sourceRect = [button bounds];
    
    popover.backgroundColor = [UIColor whiteColor];
   
    CGRect frame = [button.superview convertRect:button.frame toView:self.view];
    if ( frame.origin.y + popoverView.frame.size.height + button.frame.size.height < self.view.frame.size.height ) {
        popover.permittedArrowDirections = UIPopoverArrowDirectionUp;
    } else {
        popover.permittedArrowDirections = UIPopoverArrowDirectionDown;
    }
    
    [self presentViewController:controller animated:YES completion:nil];
}

- (void) onClickModifyBoard:(UIButton *)button {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    int index = (int)button.tag - 1;
    WezoneBoard *board = [_boardList objectAtIndex:index];
    
    WezoneBoardViewController *vc = [[WezoneBoardViewController alloc] init:_wezone board:board];
    [ApplicationDelegate.mainNaviController pushViewController:vc animated:YES];
}

- (void) onClickDeleteBoard:(UIButton *)button {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    int index = (int)button.tag - 1;
    WezoneBoard *board = [_boardList objectAtIndex:index];
    
    GALLangtudyEngine *engine = [GALLangtudyEngine sharedEngine];
    [engine sendDeleteBoard:board.board_id resultHandler:^(){
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self getWezoneBoardList:0 limit:10];
        });
        
    } errorHandler:^(NSDictionary *data, NSError *error) {
        
        NSString *errorCode = data[@"code"];
        NSLog(@"%@",errorCode);
    }];
}

#pragma mark -
#pragma mark UIPopoverPresentationControllerDelegate

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return UIModalPresentationNone;
}

#pragma mark -
#pragma mark Member

- (void)makeMemberList:(NSArray *)list total:(int)total {
   
    [self setTabButtonText:_tabMember title:[self getStringWithKey:@"wezone_member"] surfix:[NSString stringWithFormat:@" %d", total]];
    
    [_memberList addObjectsFromArray:list];
    
    [CommonUtil removeAllChildView:_memberView];
    
    float x = 0;
    float w = [Layout revert:_memberView.frame.size.width];
    float y = 0;
    int index =0;
    for( UserModel *user in _memberList) {
        index++;
        y += [self makeMember:user parent:_memberView tag:index x:x y:y w:w];
    }
    if ( _memberList.count < total ) {
        index++;
        y += [self makeFooter:(int)(total -_memberList.count) parent:_memberView tag:index x:x y:y w:w selector:@selector(onClickMoreMember)];
    }
    [_memberView setHeight:[Layout aspecValue:y]];
}

- (float)makeMember:(UserModel *)user parent:(UIView *)parent tag:(int)tag x:(float)x y:(float)y w:(float)w {
    
    UIView *view = [[UIView alloc] init:[Layout aspecRect:CGRectMake(x, y, w, 50)] parent:parent tag:tag color:UIColorFromRGB(0xffffff)];
    [view addTarget:self action:@selector(onClickMember:)];
    
    UIImageView *profile = [[UIImageView alloc] init:[Layout aspecRect:CGRectMake(10, 10, 30, 30)] parent:view tag:tag + 1 imageName:@"im_bunny_photo"];
    [profile setBackgroundColor:UIColorFromRGB(0xeeeeee)];
    profile.layer.cornerRadius = profile.frame.size.width / 2;
    profile.clipsToBounds = YES;
    
    if ( user.img_url ) {
        [[GALLangtudyEngine sharedEngine] getImageWithUrl:user.img_url completionHandler:^(UIImage *image, BOOL isInCache) {
            if ( image ) {
                profile.image = image;
            }
        } errorHandler:^(NSDictionary *data, NSError *error) {
            
        }];
    }
    
    y = 12;
    UILabel *nameLabel = [[UILabel alloc] init:[Layout aspecRect:CGRectMake(50, y, w - 60, SIZE_TEXT_S)] parent:view tag:tag + 2 text:user.user_name color:UIColor_text bgColor:nil align:NSTextAlignmentLeft font:nil size:[Layout aspecValue:SIZE_TEXT_SS]];
    [nameLabel sizeToFit];
    y += [Layout revert:nameLabel.frame.size.height] + 5;
    
    if ( user.friend_uuid ) {
        if ( [user.manage_type isEqualToString:@"M"] ) {
            
            [[UILabel alloc] init:[Layout aspecRect:CGRectMake(50, 26, w - 50, 14)] parent:view tag:tag + 4 text:[self getStringWithKey:@"manager"] color:UIColorFromRGB(0x757575) bgColor:nil align:NSTextAlignmentLeft font:nil size:[Layout aspecValue:SIZE_TEXT_SS]];
        } else {
            
            [[UIImageView alloc] init:[Layout aspecRect:CGRectMake(48, 26, 14, 14)] parent:view tag:tag + 3 imageName:@"ic_distance"];
            
            NSString *distance = (user.distance < 1000) ? [NSString stringWithFormat:@"%fm", user.distance] : [NSString stringWithFormat:@"%@km", [CommonUtil moneyFormat:user.distance / 1000 maxFraction:1]];
            [[UILabel alloc] init:[Layout aspecRect:CGRectMake(62, 26, w / 2, 14)] parent:view tag:tag + 4 text:distance color:UIColorFromRGB(0x757575) bgColor:nil align:NSTextAlignmentLeft font:nil size:[Layout aspecValue:SIZE_TEXT_SS]];
        }
        
    } else {
        
        [[[[[UIButton alloc] init:[Layout aspecRect:CGRectMake(w - 70, 10, 60, 30)] parent:view tag:VIEW_TABLE_CELL + 5 target:self action:@selector(onClickAddFriend:)]
                           addTitle:[self getStringWithKey:@"wezone_add_friend"] normalColor:UIColorFromRGB(0x689df9) highlightedColor:nil disabledColor:nil font:nil size:[Layout aspecValue:SIZE_TEXT_SS]]
                          addBackgroundColor:UIColorFromRGB(0xeeeeee) highlightedColor:nil disabledColor:nil]
                         addImageName:@"btn_addition"];
    }
    
    [UIView makeBottomLine:[Layout aspecRect:CGRectMake(x, 49, w, 1)] parent:view tag:0 color:UIColor_line];
    y += 1;
    
    return [Layout revert:view.frame.size.height];
}

- (void)onClickMember:(UIGestureRecognizer *)gesture {
    
    NSInteger index = gesture.view.tag - 1;
    
    UserModel *user = [_memberList objectAtIndex:index];
    
    WezoneMemberViewController *vc = [[WezoneMemberViewController alloc] init:user];
    [ApplicationDelegate.mainNaviController pushViewController:vc animated:YES];
}

- (void)onClickMoreMember {
    
    [self getWezoneMemberList:(int)_memberList.count limit:10];
}


- (void)onClickAddFriend:(UIButton *)button {
    
    NSInteger index = button.superview.tag - 1;
    
    UserModel *user = [_memberList objectAtIndex:index];
    
    GALLangtudyEngine *engine = [GALLangtudyEngine sharedEngine];
    [engine sendAddFriend:user.uuid resultHandler:^(){
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            user.friend_uuid = user.uuid;
            button.hidden = YES;
        });
        
    } errorHandler:^(NSDictionary *data, NSError *error) {
        
        NSString *errorCode = data[@"code"];
        NSLog(@"%@",errorCode);
    }];
}



#pragma mark -
#pragma mark Network

- (void)sendWezoneJoin {
    
    NSString *wezoneId = _wezone.wezone_id;
    NSString *flag = [_wezone.zone_possible isEqualToString:@"T"] ? @"N" : @"W";
    
    GALLangtudyEngine *engine = [GALLangtudyEngine sharedEngine];
    [engine sendWezoneJoin:wezoneId flag:flag resultHandler:^(){
        
        _wezone.isJoin = YES;
        [self makeWezone];
        
    } errorHandler:^(NSDictionary *data, NSError *error) {
        
        NSString *errorCode = data[@"code"];
        NSLog(@"%@",errorCode);
        
        [GALToastView showWithText:[self getStringWithKey:@"wezone_join_error"]];
    }];
}

- (void)getWezoneCommentList:(int)offset limit:(int)limit {
    
    NSString *wezoneId = _wezone.wezone_id;
    
    if ( offset == 0 ) {
        [_commentList removeAllObjects];
    }
    GALLangtudyEngine *engine = [GALLangtudyEngine sharedEngine];
    [engine getWezoneCommentList:wezoneId type:@"W" board_id:nil offset:offset limit:limit resultHandler:^(int total_count, NSArray *list){
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self makeCommentList:list total:total_count];
            [self setTabViewSize];
        });
        
    } errorHandler:^(NSDictionary *data, NSError *error) {
        
        NSString *errorCode = data[@"code"];
        NSLog(@"%@",errorCode);
    }];
}

- (void)getWezoneBoardList:(int)offset limit:(int)limit {
    
    NSString *wezoneId = _wezone.wezone_id;
    NSString *flag = [_wezone.zone_possible isEqualToString:@"T"] ? @"N" : @"W";
    
    if ( offset == 0 ) {
        [_boardList removeAllObjects];
    }
    
    GALLangtudyEngine *engine = [GALLangtudyEngine sharedEngine];
    [engine getWezoneBoardList:wezoneId offset:offset limit:limit resultHandler:^(int total_count, NSArray *list){
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self makeBoardList:list total:total_count];
            [self setTabViewSize];
        });
        
    } errorHandler:^(NSDictionary *data, NSError *error) {
        
        NSString *errorCode = data[@"code"];
        NSLog(@"%@",errorCode);
    }];
}

- (void)getWezoneMemberList:(int)offset limit:(int)limit {
    
    NSString *wezoneId = _wezone.wezone_id;
    
    if ( offset == 0 ) {
        [_memberList removeAllObjects];
    }
    
    GALLangtudyEngine *engine = [GALLangtudyEngine sharedEngine];
    [engine getWezoneMemberList:wezoneId zone_type:@"W" longitude:ApplicationDelegate.loginData.user_longitude latitude:ApplicationDelegate.loginData.user_latitude offset:offset limit:limit resultHandler:^(int total_count, NSArray *list){
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self makeMemberList:list total:total_count];
            [self setTabViewSize];
        });
        
    } errorHandler:^(NSDictionary *data, NSError *error) {
        
        NSString *errorCode = data[@"code"];
        NSLog(@"%@",errorCode);
    }];
}

#pragma mark -
#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    [super scrollViewDidScroll:scrollView];
    
    if ( scrollView == _tabView ) {
        
        float rate = scrollView.contentOffset.x / scrollView.contentSize.width;
        [_tabIndicator setX:_tabView.frame.size.width * rate];
        
    } else if ( scrollView == self.scrollView ) {
        
        float top = self.statusHeight + NAVI_HEIGHT;
        
        if ( scrollView.contentOffset.y > _tabBarPos - top ) {
            [_tabBarView setY:scrollView.contentOffset.y + top];
        } else {
            [_tabBarView setY:_tabBarPos];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    [super scrollViewDidEndDecelerating:scrollView];
    
    if ( scrollView == _tabView ) {
        
        float w = scrollView.frame.size.width;
        int page = (scrollView.contentOffset.x / w);
        [self selectTab:page];
        
    } else if ( scrollView == self.scrollView ) {
        
        float top = self.statusHeight + NAVI_HEIGHT;
        
        if ( scrollView.contentOffset.y > _tabBarPos - top ) {
            [_tabBarView setY:scrollView.contentOffset.y + top];
        } else {
            [_tabBarView setY:_tabBarPos];
        }
    }
}

#pragma mark -
#pragma mark NMapViewDelegate

- (void) onMapView:(NMapView *)mapView initHandler:(NMapError *)error {
    
    if (error == nil) { // success
        
        NGeoPoint ngp = NGeoPointZero;
        if ( _wezone.latitude && _wezone.longitude ) {
            ngp = NGeoPointMake([_wezone.longitude doubleValue], [_wezone.latitude doubleValue]);
        }
        [_mapView setMapCenter:ngp atLevel:14];
        [self addMarkers];
        
    } else {
        NSLog(@"onMapView:initHandler: %@", [error description]);
    }
}

- (void) addMarkers {
    
    NGeoPoint ngp = NGeoPointZero;
    if ( _wezone.latitude && _wezone.longitude ) {
        ngp = NGeoPointMake([_wezone.longitude doubleValue], [_wezone.latitude doubleValue]);
    }
    
    NMapOverlayManager *mapOverlayManager = [_mapView mapOverlayManager];
    NMapPOIdataOverlay *poiDataOverlay = [mapOverlayManager newPOIdataOverlay];
    
    [poiDataOverlay initPOIdata:1];
    [poiDataOverlay addPOIitemAtLocation:ngp title:_wezone.title type:UserPOIflagTypeDefault iconIndex:0 withObject:nil];
    [poiDataOverlay endPOIdata];
    
    [poiDataOverlay showAllPOIdata];
    //[poiDataOverlay selectPOIitemAtIndex:2 moveToCenter:NO focusedBySelectItem:YES];
}

#pragma mark NMapPOIdataOverlayDelegate

- (UIImage *) onMapOverlay:(NMapPOIdataOverlay *)poiDataOverlay imageForOverlayItem:(NMapPOIitem *)poiItem selected:(BOOL)selected {
    return [NMapViewResources imageWithType:poiItem.poiFlagType selected:selected];
}

- (CGPoint) onMapOverlay:(NMapPOIdataOverlay *)poiDataOverlay anchorPointWithType:(NMapPOIflagType)poiFlagTyp{
    return [NMapViewResources anchorPoint:poiFlagTyp];
}

- (UIView *)onMapOverlay:(NMapPOIdataOverlay *)poiDataOverlay viewForCalloutOverlayItem:(NMapPOIitem *)poiItem
         calloutPosition:(CGPoint *)calloutPosition
{
//    calloutPosition->x = roundf((self.calloutView.bounds.size.width)/2) + 1;
//    self.calloutLabel.text = poiItem.title;
//    return self.calloutView;
    return nil;
}

- (UIImage*) onMapOverlay:(NMapPOIdataOverlay *)poiDataOverlay imageForCalloutOverlayItem:(NMapPOIitem *)poiItem constraintSize:(CGSize)constraintSize selected:(BOOL)selected imageForCalloutRightAccessory:(UIImage *)imageForCalloutRightAccessory calloutPosition:(CGPoint *)calloutPosition calloutHitRect:(CGRect *)calloutHitRect {
    return nil;
}

- (CGPoint) onMapOverlay:(NMapPOIdataOverlay *)poiDataOverlay calloutOffsetWithType:(NMapPOIflagType)poiFlagType {
    return CGPointMake(0.5, 1.0);
}


@end
