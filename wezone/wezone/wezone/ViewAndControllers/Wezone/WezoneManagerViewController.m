//
//  WezoneManagerViewController.m
//  wezone
//
//  Created by Kim Sunmi on 2017. 3. 20..
//  Copyright © 2017년 Kim Sunmi. All rights reserved.
//

#import "WezoneManagerViewController.h"
#import "EditViewController.h"
#import "LocationManager.h"
#import "LocationTypeViewController.h"


#define VIEW_WEZONE_MANAGER_PHOTO               10000
#define VIEW_WEZONE_MANAGER_PROFILE             20000
#define VIEW_WEZONE_MANAGER_TITLE               30000
#define VIEW_WEZONE_MANAGER_INTRODUCE           40000
#define VIEW_WEZONE_MANAGER_LOCATION_TYPE       50000
#define VIEW_WEZONE_MANAGER_ZONE_TYPE           60000
#define VIEW_WEZONE_MANAGER_MEMBER_LIMIT        70000
#define VIEW_WEZONE_MANAGER_PUSH                80000
#define VIEW_WEZONE_MANAGER_ZONE_IN             90000
#define VIEW_WEZONE_MANAGER_ZONE_OUT            100000

@interface WezoneManagerViewController ()<UIPopoverPresentationControllerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    WezoneModel *_wezone;
    
    UIView *_instroduceView;
    UIImageView *_photoImg;
    UIImageView *_profileImg;
    UIButton *_photoBtn;
    
    UIView *_settingView;
    
    UIImagePickerController *_imagePickerController;
    //UIImage *_pickerImage;
    
    UIImageView *_pickerImageView;
    
    UIImage *_uploadBgImg;
    UIImage *_uploadImg;
}
@end

@implementation WezoneManagerViewController

- (instancetype)init:(WezoneModel *)wezone {
    
    self = [self init];
    if ( self ) {
        
        _wezone = wezone;
        NSLog(@"WezoneManagerViewController %@", _wezone.wezone_id);
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

    
    if ( _wezone.wezone_id == nil ) {
        LocationManager *locationManager = [LocationManager sharedLocationManager];
        if ( locationManager.enableLocation == NO || locationManager.hasLocationInfo == NO ) {
            [locationManager requestLocation];
        }
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
    
    if ( _wezone == nil ) {
        _wezone = [[WezoneModel alloc] initWithDefault];
    }
    
    [self makeRoot:YES title:nil bgColor:UIColorFromRGB(0xffffff)];
    [self makeLeftBackButton];
    if ( _wezone.wezone_id == nil ) {
        [self makeRightButton:@"btn_check" target:self selector:@selector(onClickRegist)];
    }
    
    self.scrollView.delegate = self;
}

- (void)makeWezone {
    
    [CommonUtil removeAllChildView:self.bodyView];
    
    float y = 0;
    float w = [Layout revert:self.bodyView.frame.size.width];
    float line = 50;
    
    self.titleView = [[UIView alloc] init:[Layout aspecRect:CGRectMake(0, 0, w, 150)] parent:self.bodyView tag:0 color:[ThemeUtil naviColor]];
    
    // 배경 이미지
    _photoImg = [[UIImageView alloc] init:[Layout aspecRect:CGRectMake(0, 0, w, 150)] parent:self.titleView tag:VIEW_WEZONE_MANAGER_PHOTO imageName:nil];
    [_photoImg setBackgroundColor:[ThemeUtil naviColor]];
    
    if ( _uploadBgImg ) {
        
        _photoImg.image = _uploadBgImg;
        float rate = _uploadBgImg.size.height / _uploadBgImg.size.width;
        [_photoImg setHeight:_photoImg.frame.size.width * rate];
        [_photoImg setContentMode:UIViewContentModeScaleAspectFit];
        
        [self.titleView setHeight:_photoImg.frame.size.height];
        
    } else if ( _wezone.bg_img_url ) {
        
        [[GALLangtudyEngine sharedEngine] getImageWithUrl:_wezone.bg_img_url completionHandler:^(UIImage *image, BOOL isInCache) {
            if ( image ) {
                _photoImg.image = image;
                float rate = image.size.height / image.size.width;
                [_photoImg setHeight:_photoImg.frame.size.width * rate];
                [_photoImg setContentMode:UIViewContentModeScaleAspectFit];
                
                [self.titleView setHeight:_photoImg.frame.size.height];
                
                [self resizeSettingView];
            }
        } errorHandler:^(NSDictionary *data, NSError *error) {
            
        }];
    }
    y += [Layout revert:self.titleView.frame.size.height];
    
    
    self.subTitleView = [[UIView alloc] init:[Layout aspecRect:CGRectMake(0, y - 67 / 2, w, 67 + 20)] parent:self.bodyView tag:0 color:nil];
    
    // 배경 이미지 추가 버튼
    _photoBtn = [[[UIButton alloc] init:[Layout aspecRect:CGRectMake(w - 35, 0, 25, 25)] parent:self.subTitleView tag:0 target:self action:@selector(onClickAddPhoto)] addImageName:@"btn_add_photo_white"];
    
    // 프로필 이미지
    _profileImg = [[UIImageView alloc] init:[Layout aspecRect:CGRectMake((w - 67) / 2, 0, 67, 67)] parent:self.subTitleView tag:10 imageName:@"ic_bunny_image"];
    
    if ( _uploadImg ) {
        
        _profileImg.image = _uploadImg;
        
    } else if ( _wezone.img_url ) {
        
        [[GALLangtudyEngine sharedEngine] getImageWithUrl:_wezone.img_url completionHandler:^(UIImage *image, BOOL isInCache) {
            if ( image ) {
                _profileImg.image = image;
            }
        } errorHandler:^(NSDictionary *data, NSError *error) {
            
        }];
    }
    
    // 프로필 이미지 추가 버튼
    UIButton *profileBtn = [[[UIButton alloc] init:[Layout aspecRect:CGRectMake(w / 2 + 67 / 2 - 25, 67 - 25, 40, 40)] parent:self.subTitleView tag:20 target:self action:@selector(onClickAddProfile)]
                            addBackgroundImageName:@"btn_circle_white"];
    [[UIImageView alloc] init:[Layout aspecRect:CGRectMake((40 - 14) / 2, (40 - 14) / 2, 14, 14)] parent:profileBtn tag:0 imageName:@"ic_add_a_photo_black"];
    
    
    y += 67 / 2 + 20;
    _settingView = [[UIView alloc] init:[Layout aspecRect:CGRectMake(0, y, w, self.bodyView.frame.size.height)] parent:self.bodyView tag:0 color:UIColorFromRGB(0xeeeeee)];
    
    y = 0;
    [UIView makeTopLine:[Layout aspecRect:CGRectMake(0, 0, w, 1)] parent:_settingView tag:30 color:UIColor_line];
    y += 1;
    
    UIView *view2 = [[UIView alloc] init:[Layout aspecRect:CGRectMake(0, y, w, 80)] parent:_settingView tag:0 color:UIColor_main];
    
    if ( _wezone.zone_id ) {
        
        NSString *title = [CommonUtil isEmpty:_wezone.title] ? [self getStringWithKey:@"wezone_manager_title_placeholder"] : _wezone.title;
        float y2 = [self makeMultiLine:[self getStringWithKey:@"title"] content:title parent:view2 tag:VIEW_WEZONE_MANAGER_TITLE x:0 y:0 w:w h:line selector:@selector(onClickTitle:)];
        // 소개
        NSString *introduce = [CommonUtil isEmpty:_wezone.introduction] ? [self getStringWithKey:@"wezone_manager_introduce_placeholder"] : _wezone.introduction;
        y2 += [self makeMultiLine:[self getStringWithKey:@"introduce"] content:introduce parent:view2 tag:VIEW_WEZONE_MANAGER_INTRODUCE x:0 y:y2 w:w h:line selector:@selector(onClickIntroduce:)];
        [view2 setHeight:[Layout aspecValue:y2]];
        y += y2 + 5;
        
    } else {
        
        // 타이틀
        float y2 = [self makeInputLine:[self getStringWithKey:@"title"] content:_wezone.title placeholder:[self getStringWithKey:@"wezone_manager_title_placeholder"] parent:view2 tag:VIEW_WEZONE_MANAGER_TITLE x:0 y:0 w:w h:line * 1.5 selector:@selector(onClickTitle:)];
        // 소개
        y2 += [self makeInputLine:[self getStringWithKey:@"introduce"] content:_wezone.introduction placeholder:[self getStringWithKey:@"wezone_manager_introduce_placeholder"] parent:view2 tag:VIEW_WEZONE_MANAGER_INTRODUCE x:0 y:y2 w:w h:line * 1.5 selector:@selector(onClickIntroduce:)];
        [view2 setHeight:[Layout aspecValue:y2]];
        y += y2 + 5;
    }
    
    UIView *view3 = [[UIView alloc] init:[Layout aspecRect:CGRectMake(0, y, w, 120)] parent:_settingView tag:0 color:UIColor_main];
    // 위치 인식
    NSString *location_type = [_wezone.location_type isEqualToString:@"G"] ? [self getStringWithKey:@"wezone_location_type_gps"] : [self getStringWithKey:@"wezone_location_type_beacon"];
    float y3 = [self makeArrowLine:[self getStringWithKey:@"wezone_manager_location_type"] content:location_type icon:@"ic_zoom_out_map_black" parent:view3 tag:VIEW_WEZONE_MANAGER_LOCATION_TYPE x:0 y:0 w:w h:line selector:@selector(onClickLocationType:)];
    // 인원 제한
    NSString *member = ([_wezone.member_limit intValue] >= 10000) ? [self getStringWithKey:@"member_unlimit"] : [NSString stringWithFormat:[self getStringWithKey:@"member_format"], [_wezone.member_limit intValue]];
    
    y3 += [self makeDropdownhLine:[self getStringWithKey:@"wezone_manager_member_limit"] content:member icon:@"ic_menu_people" parent:view3 tag:VIEW_WEZONE_MANAGER_MEMBER_LIMIT x:0 y:y3 w:w h:line selector:@selector(onClickMemberLimit:)];
    // 비공개 zone
    //NSString *zone_type = [_wezone.zone_type isEqualToString:@"T"] ? [self getStringWithKey:@"wezone_zone_type_open"] : [self getStringWithKey:@"wezone_zone_type_close"];
    y3 += [self makeSwitchLine:[self getStringWithKey:@"wezone_manager_open"] on:[_wezone.wezone_type isEqualToString:@"F"] icon:@"ic_https_black" parent:view3 tag:VIEW_WEZONE_MANAGER_ZONE_TYPE x:0 y:y3 w:w h:line selector:@selector(onClickZoneType:)];
    [view3 setHeight:[Layout aspecValue:y3]];
    y += y3 + 5;
    
    UIView *view4 = [[UIView alloc] init:[Layout aspecRect:CGRectMake(0, y, w, 120)] parent:_settingView tag:0 color:UIColor_main];
    // 알림
    float y4 = [self makeSwitchLine:[self getStringWithKey:@"wezone_manager_notification"] on:[_wezone.push_flag isEqualToString:@"T"] icon:@"ic_notifications_active_black" parent:view4 tag:VIEW_WEZONE_MANAGER_PUSH x:0 y:0 w:w h:line selector:@selector(onClickPush:)];
    // 존 in
    y4 += [self makeArrowLine:[self getStringWithKey:@"wezone_manager_zone_in"] content:@"" icon:nil parent:view4 tag:VIEW_WEZONE_MANAGER_ZONE_IN x:0 y:y4 w:w h:line selector:@selector(onClickZoneIn:)];
    // 존 out
    y4 += [self makeArrowLine:[self getStringWithKey:@"wezone_manager_zone_out"] content:@"" icon:nil parent:view4 tag:VIEW_WEZONE_MANAGER_ZONE_OUT x:0 y:y4 w:w h:line selector:@selector(onClickZoneOut:)];
    [view4 setHeight:[Layout aspecValue:y4]];
    y += y4;
    
    [_settingView setHeight:[Layout aspecValue:y]];
    //[view setShadow:[UIColor blackColor] opacity:0.2 radius:1];
    
    [self.bodyView bringSubviewToFront:self.titleView];
    [self.bodyView bringSubviewToFront:self.subTitleView];
    
    [self resizeSettingView];
}

- (float)makeInputLine:(NSString *)title content:(NSString *)content placeholder:(NSString *)placeholder parent:(UIView *)parent tag:(int)tag x:(float)x y:(float)y w:(float)w h:(float)h selector:(SEL)selector {
    
    UIView *view = [[UIView alloc] init:[Layout aspecRect:CGRectMake(x, y, w, h)] parent:parent tag:tag color:UIColor_main];
    
    UILabel *label1 = [[UILabel alloc] init:[Layout aspecRect:CGRectMake(15, 10, w / 2, h / 3 - 10)] parent:view tag:tag + 1 text:title color:UIColor_text bgColor:nil align:NSTextAlignmentLeft font:nil size:[Layout aspecValue:SIZE_TEXT_S]];

    UITextField  *textField = [[UITextField alloc]init:[Layout aspecRect:CGRectMake(5, h / 3, w - 30, h * 2 / 3)] parent:view tag:tag + 2 text:content placeholder:placeholder color:UIColor_sub_text align:NSTextAlignmentLeft font:nil size:SIZE_TEXT_M type:UIKeyboardTypeDefault password:NO delegate:self];
    
    [view setHeight:[Layout aspecValue:h]];
    
    [UIView makeBottomLine:CGRectMake(0, view.frame.size.height - 1, view.frame.size.width, 1) parent:view tag:tag + 4 color:UIColor_line];
    
    
    return h;
}

- (float)makeMultiLine:(NSString *)title content:(NSString *)content parent:(UIView *)parent tag:(int)tag x:(float)x y:(float)y w:(float)w h:(float)h selector:(SEL)selector {
    
    UIView *view = [[UIView alloc] init:[Layout aspecRect:CGRectMake(x, y, w, h)] parent:parent tag:tag color:UIColor_main];
    [view addTarget:self action:selector];
    
    UILabel *label1 = [[UILabel alloc] init:[Layout aspecRect:CGRectMake(15, 0, w / 2, h)] parent:view tag:tag + 1 text:title color:UIColor_text bgColor:nil align:NSTextAlignmentLeft font:nil size:[Layout aspecValue:SIZE_TEXT_S]];
    [label1 sizeToFitWidth];
    
    float x1 = [Layout revert:label1.frame.origin.x + label1.frame.size.width] + 10;
    
    UILabel *label2 = [[UILabel alloc] init:[Layout aspecRect:CGRectMake(x1, 10, w - x1 - 45, h - 20)] parent:view tag:tag + 2 text:content color:UIColor_sub_text bgColor:nil align:NSTextAlignmentRight font:nil size:[Layout aspecValue:SIZE_TEXT_S]];
    [label2 sizeToFitHeight:h - 20];
    
    [[[UIButton alloc] init:[Layout aspecRect:CGRectMake(w - 40, (h - 25) / 2, 25, 25)] parent:view tag:tag + 3 target:self action:selector] addImageName:@"btn_chevron_right_black"];
    
    h = MAX(h, [Layout revert:label2.frame.size.height] + 20);
    
    
    [view setHeight:[Layout aspecValue:h]];
    
    [UIView makeBottomLine:CGRectMake(0, view.frame.size.height - 1, view.frame.size.width, 1) parent:view tag:tag + 4 color:UIColor_line];
    
    return h;
}

- (float)makeArrowLine:(NSString *)title content:(NSString *)content icon:(NSString *)icon parent:(UIView *)parent tag:(int)tag x:(float)x y:(float)y w:(float)w h:(float)h selector:(SEL)selector {
    
    UIView *view = [[UIView alloc] init:[Layout aspecRect:CGRectMake(x, y, w, h)] parent:parent tag:tag color:UIColor_main];
    [view addTarget:self action:selector];
    
    if ( icon ) {
        [[UIImageView alloc] init:[Layout aspecRect:CGRectMake(15, (h - 25) / 2, 25, 25)] parent:view tag:0 imageName:icon];
        [[UILabel alloc] init:[Layout aspecRect:CGRectMake(45, 0, w / 2, h)] parent:view tag:tag + 1 text:title color:UIColor_text bgColor:nil align:NSTextAlignmentLeft font:nil size:[Layout aspecValue:SIZE_TEXT_S]];
    } else {
        [[UILabel alloc] init:[Layout aspecRect:CGRectMake(15, 0, w / 2, h)] parent:view tag:tag + 1 text:title color:UIColor_text bgColor:nil align:NSTextAlignmentLeft font:nil size:[Layout aspecValue:SIZE_TEXT_S]];
    }
    
    [[UILabel alloc] init:[Layout aspecRect:CGRectMake(w / 2, 0, w / 2 - 45, h)] parent:view tag:tag + 2 text:content color:UIColor_sub_text bgColor:nil align:NSTextAlignmentRight font:nil size:[Layout aspecValue:SIZE_TEXT_S]];
    
    [[[UIButton alloc] init:[Layout aspecRect:CGRectMake(w - 40, (h - 25) / 2, 25, 25)] parent:view tag:tag + 3 target:self action:selector] addImageName:@"btn_chevron_right_black"];
      
    [view setHeight:[Layout aspecValue:h]];
    
    [UIView makeBottomLine:CGRectMake(0, view.frame.size.height - 1, view.frame.size.width, 1) parent:view tag:tag + 4 color:UIColor_line];
    
    return h;
}

- (float)makeSwitchLine:(NSString *)title on:(BOOL)on icon:(NSString *)icon parent:(UIView *)parent tag:(int)tag x:(float)x y:(float)y w:(float)w h:(float)h selector:(SEL)selector {
    
    UIView *view = [[UIView alloc] init:[Layout aspecRect:CGRectMake(x, y, w, h)] parent:parent tag:tag color:UIColor_main];
    
    if ( icon ) {
        [[UIImageView alloc] init:[Layout aspecRect:CGRectMake(15, (h - 25) / 2, 25, 25)] parent:view tag:0 imageName:icon];
        [[UILabel alloc] init:[Layout aspecRect:CGRectMake(45, 0, w / 2, h)] parent:view tag:tag + 1 text:title color:UIColor_text bgColor:nil align:NSTextAlignmentLeft font:nil size:[Layout aspecValue:SIZE_TEXT_S]];
    } else {
        [[UILabel alloc] init:[Layout aspecRect:CGRectMake(15, 0, w / 2, h)] parent:view tag:tag + 1 text:title color:UIColor_text bgColor:nil align:NSTextAlignmentLeft font:nil size:[Layout aspecValue:SIZE_TEXT_S]];
    }
    
    UISwitch *button = [[UISwitch alloc] init:[Layout aspecRect:CGRectMake(w - 51 - 15, (h - 31) / 2, 51, 31)] parent:view tag:tag + 2];
    [button setPosition:CGPointMake(view.frame.size.width - button.frame.size.width - [Layout aspecValue:15], (view.frame.size.height - button.frame.size.height) / 2)];
    [button setOnTintColor:UIColorFromRGB(0xffd800)];
    [button addTarget:self action:selector forControlEvents:UIControlEventValueChanged];
    [button setOn:on];
    
    [view setHeight:[Layout aspecValue:h]];
    
    [UIView makeBottomLine:CGRectMake(0, view.frame.size.height - 1, view.frame.size.width, 1) parent:view tag:tag + 4 color:UIColor_line];
    
    return h;
}

- (float)makeDropdownhLine:(NSString *)title content:(NSString *)content icon:(NSString *)icon parent:(UIView *)parent tag:(int)tag x:(float)x y:(float)y w:(float)w h:(float)h selector:(SEL)selector {
    
    UIView *view = [[UIView alloc] init:[Layout aspecRect:CGRectMake(x, y, w, h)] parent:parent tag:tag color:UIColor_main];
    [view addTarget:self action:selector];
    
    if ( icon ) {
        [[UIImageView alloc] init:[Layout aspecRect:CGRectMake(15, (h - 25) / 2, 25, 25)] parent:view tag:0 imageName:icon];
        [[UILabel alloc] init:[Layout aspecRect:CGRectMake(45, 0, w / 2, h)] parent:view tag:tag + 1 text:title color:UIColor_text bgColor:nil align:NSTextAlignmentLeft font:nil size:[Layout aspecValue:SIZE_TEXT_S]];
    } else {
        [[UILabel alloc] init:[Layout aspecRect:CGRectMake(15, 0, w / 2, h)] parent:view tag:tag + 1 text:title color:UIColor_text bgColor:nil align:NSTextAlignmentLeft font:nil size:[Layout aspecValue:SIZE_TEXT_S]];
    }
    
    [[UILabel alloc] init:[Layout aspecRect:CGRectMake(w / 2, 0, w / 2 - 45, h)] parent:view tag:tag + 2 text:content color:UIColor_sub_text bgColor:nil align:NSTextAlignmentRight font:nil size:[Layout aspecValue:SIZE_TEXT_S]];
    
    [[[UIButton alloc] init:[Layout aspecRect:CGRectMake(w - 40, (h - 25) / 2, 25, 25)] parent:view tag:tag + 3 target:self action:selector] addImageName:@"arrow_drop_down" highlightedImageName:nil selectedImageName:@"arrow_drop_up" disabledImageName:nil];
    
    [UIView makeBottomLine:[Layout aspecRect:CGRectMake(0, h - 1, w, 1)] parent:view tag:tag + 4 color:UIColor_line];
    
    return h;
}

- (void)resizeSettingView {
    
    //[_photoBtn setY:_photoImg.frame.origin.y + _photoImg.frame.size.height - [Layout aspecValue:35]];
    [self.subTitleView setY:self.titleView.frame.origin.y + self.titleView.frame.size.height - [Layout aspecValue:67 / 2]];
    
    [_settingView posBelow:self.titleView margin:[Layout aspecValue:67 / 2 + 20]];
    
    [self setBodyHiehgt:_settingView.frame.origin.y + _settingView.frame.size.height];
    
}

- (void)onClickRegist {

    [self hideKeyboard];
    
    LocationManager *locationManager = [LocationManager sharedLocationManager];
    if ( locationManager.enableLocation == NO || locationManager.hasLocationInfo == NO ) {
     
        [GALangtudyUtils showAlertWithButtons:@[@"확인"] message:@"위치정보를 사용 할 수 없습니다.\nGPS 설정 후 다시 시도하십시오." close:^(int buttonIndex) {
            
        }];
        return;
    }
    _wezone.latitude = [NSString stringWithFormat:@"%f", [LocationManager sharedLocationManager].latitude];
    _wezone.longitude = [NSString stringWithFormat:@"%f", [LocationManager sharedLocationManager].longitude];

    _wezone.title = ((UITextField *)[_settingView viewWithTag:VIEW_WEZONE_MANAGER_TITLE + 2]).text;
    _wezone.introduction = ((UITextField *)[_settingView viewWithTag:VIEW_WEZONE_MANAGER_INTRODUCE + 2]).text;
    
//    if ( [CommonUtil isEmpty:_wezone.title] ) {
//        [GALToastView showWithText:[self getStringWithKey:@"wezone_manager_title_placeholder"]];
//        return;
//    }
//    if ( [CommonUtil isEmpty:_wezone.introduction] ) {
//        [GALToastView showWithText:[self getStringWithKey:@"wezone_manager_introduce_placeholder"]];
//        return;
//    }
    
    NSLog(@"regist : %@", [_wezone dictionary]);
    
    [self uploadBgImage];
}

- (void)uploadBgImage {
    
    if ( _uploadBgImg ) {
        
        [[GALLangtudyEngine sharedEngine] uploadImage:_uploadBgImg withUuid:ApplicationDelegate.loginData.user_info.uuid type:@"wg" id:nil status:@"2" resultHandler:^(NSString *imageUrl) {
            
            _wezone.bg_img_url = imageUrl;
            [self uploadImage];
            
        } errorHandler:^(NSDictionary *data, NSError *error) {
            [GALToastView showWithText:[self getStringWithKey:@"file_upload_failed"]];
        }];
        
    } else {
        
        [self uploadImage];
    }
}

- (void)uploadImage {
    
    if ( _uploadImg ) {
        
        [[GALLangtudyEngine sharedEngine] uploadImage:_uploadImg withUuid:ApplicationDelegate.loginData.user_info.uuid type:@"we" id:nil status:@"2" resultHandler:^(NSString *imageUrl) {
            
            _wezone.img_url = imageUrl;
            
            [self registWezone];
            
        } errorHandler:^(NSDictionary *data, NSError *error) {
            [GALToastView showWithText:[self getStringWithKey:@"file_upload_failed"]];
        }];
        
    } else {
        
        [self registWezone];
    }
}

- (void)registWezone {
    
    
    [[GALLangtudyEngine sharedEngine] sendRegistWezone:_wezone resultHandler:^(NSString *_id) {
        
        [self makeWezone];
        
    } errorHandler:^(NSDictionary *data, NSError *error) {
        [self showErrorToast:data error:error];
    }];
    
}

- (void)onClickAddPhoto {
    
    _pickerImageView = _photoImg;
    [self showPhotoMenu];
}

- (void)onClickAddProfile {
    
    _pickerImageView = _profileImg;
    [self showPhotoMenu];
}

- (void)onClickTitle:(id)sender {
    
    EditViewController *vc = [[EditViewController alloc] init:[self getStringWithKey:@"wezone_manager_input_title"] content:_wezone.title placeholder:[self getStringWithKey:@"wezone_manager_title_placeholder"] completion:^(NSString *content) {
        
        NSArray *wezone_info = @[@{@"flag":@"title", @"val":content}];
        [[GALLangtudyEngine sharedEngine] sendModifyWezone:_wezone.wezone_id wezone_info:wezone_info resultHandler:^() {
            
            _wezone.title = content;
            [self makeWezone];
            
        } errorHandler:^(NSDictionary *data, NSError *error) {
            [self showErrorToast:data error:error];
        }];
    }];
    [ApplicationDelegate.mainNaviController pushViewController:vc animated:YES];
}

- (void)onClickIntroduce:(id)sender {
    
    EditViewController *vc = [[EditViewController alloc] init:[self getStringWithKey:@"wezone_manager_input_introduce"] content:_wezone.introduction placeholder:[self getStringWithKey:@"wezone_manager_introduce_placeholder"] completion:^(NSString *content) {
        
        NSArray *wezone_info = @[@{@"flag":@"introduction", @"val":content}];
        [[GALLangtudyEngine sharedEngine] sendModifyWezone:_wezone.wezone_id wezone_info:wezone_info resultHandler:^() {
            
            _wezone.introduction = content;
            [self makeWezone];
            
        } errorHandler:^(NSDictionary *data, NSError *error) {
            [self showErrorToast:data error:error];
        }];
        
    }];
    [ApplicationDelegate.mainNaviController pushViewController:vc animated:YES];
}

- (void)onClickLocationType:(id)sender {
    
    LocationTypeViewController *vc = [[LocationTypeViewController alloc] init:[self getStringWithKey:@"wezone_manager_location_type"] wezone:_wezone completion:^(NSString *locationType, NSString *value) {
        
        if ( _wezone.wezone_id ) {
            
            NSArray *wezone_info = @[@{@"flag":@"location_type", @"val":locationType}, @{@"flag":@"location_data", @"val":value}];
            [[GALLangtudyEngine sharedEngine] sendModifyWezone:_wezone.wezone_id wezone_info:wezone_info resultHandler:^() {
                
                _wezone.location_type = locationType;
                _wezone.location_data = value;
                
                [self makeWezone];
                
            } errorHandler:^(NSDictionary *data, NSError *error) {
                [self showErrorToast:data error:error];
            }];
            
        } else {
            
            _wezone.location_type = locationType;
            _wezone.location_data = value;
            [self makeWezone];
        }
    }];
    [ApplicationDelegate.mainNaviController pushViewController:vc animated:YES];
}

- (void)onClickMemberLimit:(id)sender {
    
    UIButton *button;
    if ( [sender isKindOfClass:[UIButton class]] ) {
        button = (UIButton *)sender;
    } else if ( [sender isKindOfClass:[UIGestureRecognizer class]] ) {
        UIView *view = ((UIGestureRecognizer *)sender).view;
        button = [view viewWithTag:view.tag + 3];
    }
    
    UIViewController *controller = [[UIViewController alloc] init];
    UIView *popoverView = [[UIView alloc]initWithFrame:[Layout aspecRect:CGRectMake(0, 0, 100, 160)]];
    
    [[[UIButton alloc] init:[Layout aspecRect:CGRectMake(10, 0, 60, 40)] parent:popoverView tag:1 target:self action:@selector(onClickMember:)]
     addTitle:[self getStringWithKey:@"member_unlimit"] normalColor:UIColorFromRGB(0x212121) highlightedColor:nil disabledColor:nil font:nil size:[Layout aspecValue:SIZE_TEXT_S] align:UIControlContentHorizontalAlignmentLeft];
    
    [[[UIButton alloc] init:[Layout aspecRect:CGRectMake(10, 40, 60, 40)] parent:popoverView tag:2 target:self action:@selector(onClickMember:)]
     addTitle:[NSString stringWithFormat:[self getStringWithKey:@"member_format"], 100] normalColor:UIColorFromRGB(0x212121) highlightedColor:nil disabledColor:nil font:nil size:[Layout aspecValue:SIZE_TEXT_S] align:UIControlContentHorizontalAlignmentLeft];
    
    [[[UIButton alloc] init:[Layout aspecRect:CGRectMake(10, 80, 60, 40)] parent:popoverView tag:3 target:self action:@selector(onClickMember:)]
     addTitle:[NSString stringWithFormat:[self getStringWithKey:@"member_format"], 50] normalColor:UIColorFromRGB(0x212121) highlightedColor:nil disabledColor:nil font:nil size:[Layout aspecValue:SIZE_TEXT_S] align:UIControlContentHorizontalAlignmentLeft];
    
    [[[UIButton alloc] init:[Layout aspecRect:CGRectMake(10, 120, 60, 40)] parent:popoverView tag:4 target:self action:@selector(onClickMember:)]
     addTitle:[NSString stringWithFormat:[self getStringWithKey:@"member_format"], 10] normalColor:UIColorFromRGB(0x212121) highlightedColor:nil disabledColor:nil font:nil size:[Layout aspecValue:SIZE_TEXT_S] align:UIControlContentHorizontalAlignmentLeft];
    
    [UIView makeHorizontalLine:[Layout aspecRect:CGRectMake(0, 40, 100, 1)] parent:popoverView tag:0 color:UIColor_line];
    [UIView makeHorizontalLine:[Layout aspecRect:CGRectMake(0, 80, 100, 1)] parent:popoverView tag:0 color:UIColor_line];
    [UIView makeHorizontalLine:[Layout aspecRect:CGRectMake(0, 120, 100, 1)] parent:popoverView tag:0 color:UIColor_line];
    
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

- (void)onClickMember:(UIButton *)button {

    [self dismissViewControllerAnimated:YES completion:nil];
    
    int index = (int)button.tag - 1;
    int member = 10000;
    
    if ( index == 1 ) member = 100;
    else if ( index == 2 ) member = 50;
    else if ( index == 3 ) member = 10;
    
    if ( _wezone.wezone_id ) {
        
        NSArray *wezone_info = @[@{@"flag":@"member_limit", @"val":[NSString stringWithFormat:@"%d", member]}];
        [[GALLangtudyEngine sharedEngine] sendModifyWezone:_wezone.wezone_id wezone_info:wezone_info resultHandler:^() {
            
            _wezone.member_limit = [NSString stringWithFormat:@"%d", member];
            
            [self makeWezone];
            
        } errorHandler:^(NSDictionary *data, NSError *error) {
            [self showErrorToast:data error:error];
        }];
        
    } else {
        
        _wezone.member_limit = [NSString stringWithFormat:@"%d", member];
        [self makeWezone];
    }

}

- (void)onClickZoneType:(UISwitch *)button {
    
    NSString *wezone_type = button.isOn ? @"F":@"T";
    
    if ( _wezone.wezone_id ) {
        
        NSArray *wezone_info = @[@{@"flag":@"wezone_type", @"val":wezone_type}];
        [[GALLangtudyEngine sharedEngine] sendModifyWezone:_wezone.wezone_id wezone_info:wezone_info resultHandler:^() {
            
            _wezone.wezone_type = wezone_type;
            [self makeWezone];
            
        } errorHandler:^(NSDictionary *data, NSError *error) {
            [self showErrorToast:data error:error];
        }];
        
    } else {
        
        _wezone.wezone_type = wezone_type;
        [self makeWezone];
    }
}

- (void)onClickPush:(UISwitch *)button {
    
    NSString *push = button.isOn ? @"T":@"F";
    
    if ( _wezone.wezone_id ) {
    
        NSArray *wezone_info = @[@{@"flag":@"push_flag", @"val":push}];
        
        [[GALLangtudyEngine sharedEngine] sendModifyWezone:_wezone.wezone_id wezone_info:wezone_info resultHandler:^() {
            
            _wezone.push_flag = push;
            [self makeWezone];

        } errorHandler:^(NSDictionary *data, NSError *error) {
            [self showErrorToast:data error:error];
        }];
    } else {
        
        _wezone.push_flag = push;
        [self makeWezone];

    }
}

- (void)onClickZoneIn:(id)sender {
    
}

- (void)onClickZoneOut:(id)sender {
    
}

#pragma mark -
#pragma mark ImagePicker

- (void)setPickerImage:(UIImage *)image {
    
    if ( image ) {
        
        if ( _pickerImageView == _photoImg ) {
            
            if ( _wezone.wezone_id ) {
                
                [[GALLangtudyEngine sharedEngine] uploadImage:image withUuid:ApplicationDelegate.loginData.user_info.uuid type:@"wg" id:nil status:@"2" resultHandler:^(NSString *imageUrl) {
                    
                    _wezone.bg_img_url = imageUrl;
                    NSArray *wezone_info = @[@{@"flag":@"bg_img_url", @"val":imageUrl}];
                    
                    [[GALLangtudyEngine sharedEngine] sendModifyWezone:_wezone.wezone_id wezone_info:wezone_info resultHandler:^() {
                        
                        _wezone.bg_img_url = imageUrl;
                        [self makeWezone];
                        
                    } errorHandler:^(NSDictionary *data, NSError *error) {
                        [self showErrorToast:data error:error];
                    }];
                    
                } errorHandler:^(NSDictionary *data, NSError *error) {
                    [GALToastView showWithText:[self getStringWithKey:@"file_upload_failed"]];
                }];
                
            } else {
                
                _photoImg.image = image;
                _uploadBgImg = image;
                
                float rate = image.size.height / image.size.width;
                [_photoImg setHeight:_photoImg.frame.size.width * rate];
                [_photoImg setContentMode:UIViewContentModeScaleAspectFit];
                
                [self.titleView setHeight:_photoImg.frame.size.height];
                
                [self resizeSettingView];
            }
            
        } else if ( _pickerImageView == _profileImg ) {
            
            if ( _wezone.wezone_id ) {
                
                [[GALLangtudyEngine sharedEngine] uploadImage:image withUuid:ApplicationDelegate.loginData.user_info.uuid type:@"we" id:nil status:@"2" resultHandler:^(NSString *imageUrl) {
                    
                    NSArray *wezone_info = @[@{@"flag":@"img_url", @"val":imageUrl}];
                    
                    [[GALLangtudyEngine sharedEngine] sendModifyWezone:_wezone.wezone_id wezone_info:wezone_info resultHandler:^() {
                        
                        _wezone.img_url = imageUrl;
                        [self makeWezone];
                        
                    } errorHandler:^(NSDictionary *data, NSError *error) {
                        [self showErrorToast:data error:error];
                    }];
                    
                    
                } errorHandler:^(NSDictionary *data, NSError *error) {
                    [GALToastView showWithText:[self getStringWithKey:@"file_upload_failed"]];
                }];
                
            } else {
                
                _profileImg.image = image;
                _uploadImg = image;
            }
        }
    }
}

- (void)showPhotoMenu {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:[self getStringWithKey:@"take_photo"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        _imagePickerController = [[UIImagePickerController alloc] init];
        _imagePickerController.delegate = self;
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            _imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:_imagePickerController animated:YES completion:NULL];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"No Camera Available." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            alert = nil;
        }
        NSLog(@"%@",[action title]);
    }];
    [alertController addAction:cameraAction];
    
    UIAlertAction *gallaryAction = [UIAlertAction actionWithTitle:[self getStringWithKey:@"choose_from_library"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        _imagePickerController= [[UIImagePickerController alloc] init];
        _imagePickerController.delegate = self;
        _imagePickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        
        [self presentViewController:_imagePickerController animated:YES completion:nil];
        
        NSLog(@"%@",[action title]);
    }];
    [alertController addAction:gallaryAction];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:[self getStringWithKey:@"cancel"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - ImagePickerController Delegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *takeImage= [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    takeImage = [GALangtudyUtils imageWithImage:takeImage scaledToHeight:720];
    
    [self setPickerImage:takeImage];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
#pragma mark UITextViewDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if ( textField.tag == VIEW_WEZONE_MANAGER_TITLE + 2 ) {
        
        _wezone.title = textField.text;
        
    } else if ( textField.tag == VIEW_WEZONE_MANAGER_INTRODUCE + 2 ) {
        
        _wezone.introduction = textField.text;
    }
}

#pragma mark -
#pragma mark UIPopoverPresentationControllerDelegate

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return UIModalPresentationNone;
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

@end
