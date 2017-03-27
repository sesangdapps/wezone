//
//  ProfileViewController.m
//  wezone
//
//  Created by Kim Sunmi on 2017. 3. 23..
//  Copyright © 2017년 Kim Sunmi. All rights reserved.
//

#import "ProfileViewController.h"
#import "EditViewController.h"

@interface ProfileViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    UserModel *_user;
    UIView *_instroduceView;
    UIImageView *_photoImg;
    UIImageView *_profileImg;
    UIButton *_photoBtn;
    
    UIImagePickerController *_imagePickerController;
    UIImageView *_pickerImageView;
//    UIImage *_uploadBgImg;
//    UIImage *_uploadImg;
    
}
@end

@implementation ProfileViewController

- (instancetype)init:(UserModel *)user {
    
    self = [self init];
    if ( self ) {
        _user = user;
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
    
    [self makeUser];
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
                [self setBodyHiehgt:_instroduceView.frame.origin.y + _instroduceView.frame.size.height];
            }
        } errorHandler:^(NSDictionary *data, NSError *error) {
            
        }];
    }
    
    y += [Layout revert:self.titleView.frame.size.height];
    
    self.subTitleView = [[UIView alloc] init:[Layout aspecRect:CGRectMake(0, y - 67 / 2, w, 67 + 20)] parent:self.bodyView tag:0 color:nil];
    
    // 배경 이미지 추가 버튼
    _photoBtn = [[[UIButton alloc] init:[Layout aspecRect:CGRectMake(w - 35, 0, 25, 25)] parent:self.subTitleView tag:0 target:self action:@selector(onClickAddPhoto)] addImageName:@"btn_add_photo_white"];
    
    
    _profileImg = [[UIImageView alloc] init:[Layout aspecRect:CGRectMake((w - 67) / 2, 0, 67, 67)] parent:self.subTitleView tag:10 imageName:@"im_bunny_photo"];
    [_profileImg setBackgroundColor:UIColorFromRGB(0xeeeeee)];
    _profileImg.layer.cornerRadius = _profileImg.frame.size.width / 2;
    _profileImg.clipsToBounds = YES;
    
    if ( _user.img_url ) {
        
        [[GALLangtudyEngine sharedEngine] getImageWithUrl:_user.img_url completionHandler:^(UIImage *image, BOOL isInCache) {
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
    
    y += [self makeIntroduce:y w:w];
    
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
    
    y += 67 / 2 + 30;
    
    //  이름
    NSString *title = _user.user_name;
    UILabel *label1 = [[UILabel alloc] init:[Layout aspecRect:CGRectMake(x, y, w - x * 2 - 40, 25)] parent:view tag:0 text:title color:UIColor_text bgColor:nil align:NSTextAlignmentCenter font:@"bold" size:[Layout aspecValue:SIZE_TEXT_M]];
    [label1 sizeToFitHeight:[Layout aspecValue:25]];
    y += [Layout revert:label1.frame.size.height];
    
    float x1 = [Layout revert:label1.frame.origin.x + label1.frame.size.width] + 10;
    [[[UIButton alloc] init:[Layout aspecRect:CGRectMake(x1, y - 25, 25, 25)] parent:view tag:0 target:self action:@selector(onClickTitle:)] addImageName:@"btn_edit_contents_black"];
   

    // 상태 메세지
    y += 30;
    UIView *view2 = [[UIView alloc] init:[Layout aspecRect:CGRectMake(0, y, w, 80)] parent:view tag:0 color:nil];
    [view2 addTarget:self action:@selector(onClickStatusMessage:)];
    
    float y2 = 0;
    [UIView makeTopLine:CGRectMake(0, y2, view.frame.size.width, 1) parent:view2 tag:0 color:UIColor_line];
    y2 += 15;
    
    UILabel *label2 = [[UILabel alloc] init:[Layout aspecRect:CGRectMake(x, y2, w - x * 2, 30)] parent:view2 tag:0 text:[self getStringWithKey:@"member_status_message"] color:UIColor_sub_text bgColor:nil align:NSTextAlignmentLeft font:nil  size:[Layout aspecValue:SIZE_TEXT_S]];
    [label2 sizeToFitHeight];
    y2 += [Layout revert:label2.frame.size.height] + 5;
    
    NSString *status_message = [CommonUtil isEmpty:_user.status_message] ? [self getStringWithKey:@"member_staus_message_desc"] : _user.status_message;
    UILabel *label3 = [[UILabel alloc] init:[Layout aspecRect:CGRectMake(x, y2, w - x * 2, 30)] parent:view2 tag:0 text:status_message color:UIColor_text bgColor:nil align:NSTextAlignmentLeft font:nil size:[Layout aspecValue:SIZE_TEXT_M]];
    [label3 sizeToFitHeight];
    y2 += [Layout revert:label3.frame.size.height] + 15;
    
    [view2 setHeight:[Layout aspecValue:y2]];
    [UIView makeBottomLine:CGRectMake(0, view2.frame.size.height - 1, view2.frame.size.width, 1) parent:view2 tag:0 color:UIColor_line];
    
    y += y2;
    
    [view setHeight:[Layout aspecValue:y]];
    
    return y;
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
    
    EditViewController *vc = [[EditViewController alloc] init:[self getStringWithKey:@"member_profile"] content:_user.user_name placeholder:[self getStringWithKey:@"member_name_placeholder"] completion:^(NSString *content) {
        
        [[GALLangtudyEngine sharedEngine] sendModifyUserInfo:_user.uuid flag:@"user_name" val:content resultHandler:^() {
            
            _user.user_name = content;
            [self makeUser];
            
        } errorHandler:^(NSDictionary *data, NSError *error) {
            [self showErrorToast:data error:error];
        }];

    }];
    [ApplicationDelegate.mainNaviController pushViewController:vc animated:YES];
}

- (void)onClickStatusMessage:(id)sender {
    
    EditViewController *vc = [[EditViewController alloc] init:[self getStringWithKey:@"member_profile"] content:_user.status_message placeholder:[self getStringWithKey:@"member_staus_message_placeholder"] completion:^(NSString *content) {
        
        [[GALLangtudyEngine sharedEngine] sendModifyUserInfo:_user.uuid flag:@"status_message" val:content resultHandler:^() {
            
            _user.status_message = content;
            [self makeUser];
            
        } errorHandler:^(NSDictionary *data, NSError *error) {
            [self showErrorToast:data error:error];
        }];
    }];
    [ApplicationDelegate.mainNaviController pushViewController:vc animated:YES];
}

- (void)resizeView {
    
    //[_photoBtn setY:_photoImg.frame.origin.y + _photoImg.frame.size.height - [Layout aspecValue:35]];
    [self.subTitleView setY:self.titleView.frame.origin.y + self.titleView.frame.size.height - [Layout aspecValue:67 / 2]];
    
    [_instroduceView posBelow:self.titleView margin:[Layout aspecValue:67 / 2 + 20]];
    
    [self setBodyHiehgt:_instroduceView.frame.origin.y + _instroduceView.frame.size.height];
    
}

#pragma mark -
#pragma mark ImagePicker

- (void)setPickerImage:(UIImage *)image {
    
    if ( image ) {
        
        if ( _pickerImageView == _photoImg ) {
            
            [[GALLangtudyEngine sharedEngine] uploadImage:image withUuid:ApplicationDelegate.loginData.user_info.uuid type:@"bg" id:nil status:@"2" resultHandler:^(NSString *imageUrl) {
                
                _user.bg_img_url = imageUrl;
                
                [[GALLangtudyEngine sharedEngine] sendModifyUserInfo:_user.uuid flag:@"bg_img_url" val:imageUrl resultHandler:^() {
                    
                    [self makeUser];
                    
                } errorHandler:^(NSDictionary *data, NSError *error) {
                    [self showErrorToast:data error:error];
                }];
                
            } errorHandler:^(NSDictionary *data, NSError *error) {
                [GALToastView showWithText:[self getStringWithKey:@"file_upload_failed"]];
            }];
            
        } else if ( _pickerImageView == _profileImg ) {
            
            [[GALLangtudyEngine sharedEngine] uploadImage:image withUuid:ApplicationDelegate.loginData.user_info.uuid type:@"pr" id:nil status:@"2" resultHandler:^(NSString *imageUrl) {
                
                _user.img_url = imageUrl;
                
                [[GALLangtudyEngine sharedEngine] sendModifyUserInfo:_user.uuid flag:@"img_url" val:imageUrl resultHandler:^() {
                    
                    [self makeUser];
                    
                } errorHandler:^(NSDictionary *data, NSError *error) {
                    [self showErrorToast:data error:error];
                }];

                
            } errorHandler:^(NSDictionary *data, NSError *error) {
                [GALToastView showWithText:[self getStringWithKey:@"file_upload_failed"]];
            }];
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
