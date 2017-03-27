//
//  WezoneMemberViewController.m
//  wezone
//
//  Created by Kim Sunmi on 2017. 3. 20..
//  Copyright © 2017년 Kim Sunmi. All rights reserved.
//

#import "WezoneMemberViewController.h"
#import "WezoneDetailViewController.h"
#import "ProfileViewController.h"
#import "WezoneListView.h"

@interface WezoneMemberViewController ()
{
    UserModel *_user;
    UIView *_instroduceView;
    WezoneListView *_wezoneListView;
    UIButton *_chatBtn;
    UILabel *_zoneCountLabel;
    BOOL _isOwn;
}
@end

@implementation WezoneMemberViewController

- (instancetype)init:(UserModel *)user {
    
    self = [self init];
    if ( self ) {
        _user = user;
        _isOwn = [_user.uuid isEqualToString:ApplicationDelegate.loginData.user_info.uuid];
    }    
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.tintColor = [UIColor clearColor];
   
    [self getUser:_user.uuid];
    
    if ( _isOwn == NO ) {
        [self getWezoneList:_user.uuid];
    }
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
    if ( _isOwn ) {
        [self makeRightButton:@"btn_more_white" target:self selector:@selector(onClickModifyProfile)];
    }
}

- (void)makeUser {
    
    [CommonUtil removeAllChildView:self.bodyView];
    
    float y = 0;
    float w = [Layout revert:self.bodyView.frame.size.width];
    
    self.titleView = [[UIView alloc] init:[Layout aspecRect:CGRectMake(0, 0, w, 150)] parent:self.bodyView tag:0 color:[ThemeUtil naviColor]];
    UIImageView *img = [[UIImageView alloc] init:[Layout aspecRect:CGRectMake(0, 0, w, 150)] parent:self.titleView tag:0 imageName:nil];
    if ( _user.bg_img_url ) {
        
        [[GALLangtudyEngine sharedEngine] getImageWithUrl:_user.bg_img_url completionHandler:^(UIImage *image, BOOL isInCache) {
            if ( image ) {
                img.image = image;
                float rate = image.size.height / image.size.width;
                [img setHeight:img.frame.size.width * rate];
                [img setContentMode:UIViewContentModeScaleAspectFit];
                
                [self.titleView setHeight:img.frame.size.height];
                [self.subTitleView setY:self.titleView.frame.origin.y + self.titleView.frame.size.height - 67 / 2];
                
                [_instroduceView posBelow:self.titleView margin:0];
                [self setBodyHiehgt:_wezoneListView.frame.origin.y + _wezoneListView.frame.size.height];
            }
        } errorHandler:^(NSDictionary *data, NSError *error) {
            
        }];
    }
    
    [self.titleView setHeight:img.frame.size.height];
    y += [Layout revert:self.titleView.frame.size.height];
    
    self.subTitleView = [[UIView alloc] init:[Layout aspecRect:CGRectMake((w - 67) / 2, y - 67 / 2, 67, 67)] parent:self.bodyView tag:0 color:nil];
    UIImageView *profileImg = [[UIImageView alloc] init:[Layout aspecRect:CGRectMake(0, 0, 67, 67)] parent:self.subTitleView tag:0 imageName:@"im_bunny_photo"];
    [profileImg setBackgroundColor:UIColorFromRGB(0xeeeeee)];
    profileImg.layer.cornerRadius = profileImg.frame.size.width / 2;
    profileImg.clipsToBounds = YES;
    
    if ( _user.img_url ) {
        
        [[GALLangtudyEngine sharedEngine] getImageWithUrl:_user.img_url completionHandler:^(UIImage *image, BOOL isInCache) {
            if ( image ) {
                profileImg.image = image;
            }
        } errorHandler:^(NSDictionary *data, NSError *error) {
            
        }];
    }
    
    y += [self makeIntroduce:y w:w] + 5;
    
    if ( _isOwn == NO ) {
        y += [self makeZoneList:y w:w];
    }
    
    [self setBodyHiehgt:[Layout aspecValue:y]];
    
    [self.bodyView bringSubviewToFront:self.titleView];
    [self.bodyView bringSubviewToFront:self.subTitleView];
}

#pragma mark -
#pragma mark Introduce

- (float)makeIntroduce:(float)y w:(float)w {
    
    float x = 15;
    
    UIView *view = [[UIView alloc] init:[Layout aspecRect:CGRectMake(0, y, w, self.bodyView.frame.size.height)] parent:self.bodyView tag:0 color:nil];
    _instroduceView = view;
    
    y = 0;
    
    if ( _isOwn == NO ) {
    
        [view setBackgroundColor:UIColorFromRGB(0xffffff)];
        
        // 나와의 거리
        NSString *distance = (_user.distance < 1000) ? [NSString stringWithFormat:@"%fm", _user.distance] : [NSString stringWithFormat:@"%@km", [CommonUtil moneyFormat:_user.distance / 1000 maxFraction:1]];
        [[UILabel alloc] init:[Layout aspecRect:CGRectMake(0, y + 10, w / 2, 15)] parent:view tag:0 text:distance color:UIColor_text bgColor:nil align:NSTextAlignmentCenter font:nil size:[Layout aspecValue:SIZE_TEXT_SS]];
        [[UILabel alloc] init:[Layout aspecRect:CGRectMake(0, y + 25, w / 2, 15)] parent:view tag:0 text:[self getStringWithKey:@"member_distance_by_me"] color:UIColor_hint bgColor:nil align:NSTextAlignmentCenter font:nil size:[Layout aspecValue:SIZE_TEXT_SS]];
        
        // 입장한 존
        NSString *count = [NSString stringWithFormat:@"%d", 0];
        _zoneCountLabel = [[UILabel alloc] init:[Layout aspecRect:CGRectMake(w / 2, y + 10, w / 2, 15)] parent:view tag:0 text:count color:UIColor_text bgColor:nil align:NSTextAlignmentCenter font:nil size:[Layout aspecValue:SIZE_TEXT_SS]];
        [[UILabel alloc] init:[Layout aspecRect:CGRectMake(w / 2, y + 25, w / 2, 15)] parent:view tag:0 text:[self getStringWithKey:@"member_join_zone_count"] color:UIColor_hint bgColor:nil align:NSTextAlignmentCenter font:nil size:[Layout aspecValue:SIZE_TEXT_SS]];
    }
    
    y += 67 / 2 + 30;
    
    //  이름
    NSString *title = _user.user_name;
    UILabel *label1 = [[UILabel alloc] init:[Layout aspecRect:CGRectMake(x, y, w - x * 2, 30)] parent:view tag:0 text:title color:UIColor_text bgColor:nil align:NSTextAlignmentCenter font:@"bold" size:[Layout aspecValue:SIZE_TEXT_M]];
    [label1 sizeToFitHeight];
    y += [Layout revert:label1.frame.size.height] + 5;
    
    NSString *address = _user.address;
    UILabel *label2 = [[UILabel alloc] init:[Layout aspecRect:CGRectMake(x, y, w - x * 2, 30)] parent:view tag:0 text:address color:UIColor_hint bgColor:nil align:NSTextAlignmentCenter font:nil  size:[Layout aspecValue:SIZE_TEXT_SS]];
    [label2 sizeToFitHeight];
    y += [Layout revert:label2.frame.size.height] + 20;
    
    // 소개 문구
    NSString *status_message = ([CommonUtil isEmpty:_user.status_message] && _isOwn) ? [self getStringWithKey:@"member_staus_message_desc"] : _user.status_message;
    UILabel *label3 = [[UILabel alloc] init:[Layout aspecRect:CGRectMake(x, y, w - x * 2, 30)] parent:view tag:0 text:status_message color:UIColor_sub_text bgColor:nil align:NSTextAlignmentCenter font:nil size:[Layout aspecValue:SIZE_TEXT_S]];
    [label3 sizeToFitHeight];
    y += [Layout revert:label3.frame.size.height] + 10;
    
    if ( _isOwn == NO ) {
        
        y += 30;
        
        if ( [_user.is_friend isEqualToString:@"T"] ) {
            
            [[[[UIButton alloc] init:[Layout aspecRect:CGRectMake(0, y, w, 40)] parent:view tag:0 target:self action:@selector(onClickGroupChat)]
              addTitle:[self getStringWithKey:@"wezone_group_chat"]] icontextStyle:@"btn_group_chat"];
            
        } else {
            
            _chatBtn = [[[[UIButton alloc] init:[Layout aspecRect:CGRectMake(0, y, w / 2, 40)] parent:view tag:0 target:self action:@selector(onClickGroupChat)]
                         addTitle:[self getStringWithKey:@"wezone_group_chat"]] icontextStyle:@"btn_group_chat"];
            
            [[[[UIButton alloc] init:[Layout aspecRect:CGRectMake(w / 2 - 1, y, w / 2 + 1, 40)] parent:view tag:0 target:self action:@selector(onClickAddFriend:)]
              addTitle:[self getStringWithKey:@"member_add_friend"]] icontextStyle:@"btn_addition"];
        }
        
        y += 40;
        
        [view setHeight:[Layout aspecValue:y]];
        [view setShadow:[UIColor blackColor] opacity:0.2 radius:1];
        
    } else {
        
        [view setHeight:[Layout aspecValue:y]];
    }
    
    return y;
}

- (float)makeZoneList:(float)y w:(float)w {
    
    _wezoneListView = [[WezoneListView alloc] init:STR(@"wezone_my_wezone") rect:[Layout aspecRect:CGRectMake(0, y, w, 44)] parent:self.bodyView sizeChanged:^(CGRect rect) {
        
        [self setBodyHiehgt:rect.origin.y + rect.size.height];
    }];
    
    return [Layout revert:_wezoneListView.frame.size.height];
}

- (void)onClickGroupChat {
    
}

- (void)onClickAddFriend:(UIButton *)button {
    
    GALLangtudyEngine *engine = [GALLangtudyEngine sharedEngine];
    [engine sendAddFriend:_user.uuid resultHandler:^(){
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            _user.is_friend = @"T";
            [button removeFromSuperview];
            [_chatBtn setWidth:_chatBtn.superview.frame.size.width];
            //[self makeUser];
        });
        
    } errorHandler:^(NSDictionary *data, NSError *error) {
        
        NSString *errorCode = data[@"code"];
        NSLog(@"%@",errorCode);
    }];
}

- (void)onClickModifyProfile {
    
    ProfileViewController *vc = [[ProfileViewController alloc] init:_user];
    [ApplicationDelegate.mainNaviController pushViewController:vc animated:YES];
}

- (void)getUser:(NSString *)uuid {
    
    LocationManager *locationManager = [LocationManager sharedLocationManager];
    if ( locationManager.enableLocation == NO || locationManager.hasLocationInfo == NO ) {
        
        [GALangtudyUtils showAlertWithButtons:@[@"확인"] message:@"위치정보를 사용 할 수 없습니다.\nGPS 설정 후 다시 시도하십시오." close:^(int buttonIndex) {
            
        }];
        return;
    }
    NSString *latitude = [NSString stringWithFormat:@"%f", [LocationManager sharedLocationManager].latitude];
    NSString *longitude = [NSString stringWithFormat:@"%f", [LocationManager sharedLocationManager].longitude];
    
    [[GALLangtudyEngine sharedEngine] getUserInfo:uuid longitude:longitude latitude:latitude resultHandler:^(UserModel *user){
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            _user = user;
            
            [self makeUser];
        });
        
    } errorHandler:^(NSDictionary *data, NSError *error) {
        
        NSString *errorCode = data[@"code"];
        NSLog(@"%@",errorCode);
    }];
}

- (void)getWezoneList:(NSString *)uuid {
    
    GALLangtudyEngine *engine = [GALLangtudyEngine sharedEngine];
    
    [engine getMyWezoneList:uuid longitude:nil withLatitude:nil resultHandler:^(int total_count, NSArray *list){
        
        for(WezoneModel *wezone in list) {
            
            wezone.isJoin = YES;
        }
        _zoneCountLabel.text = [NSString stringWithFormat:@"%d", list.count];
        [_wezoneListView reloadData:list];
        
    } errorHandler:^(NSDictionary *data, NSError *error) {
        
        NSString *errorCode = data[@"code"];
        NSLog(@"%@",errorCode);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
