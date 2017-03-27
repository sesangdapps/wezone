//
//  WezoneBoardViewController.m
//  wezone
//
//  Created by Kim Sunmi on 2017. 3. 19..
//  Copyright © 2017년 Kim Sunmi. All rights reserved.
//

#import "WezoneBoardViewController.h"

@interface WezoneBoardViewController ()
{
    WezoneModel *_wezone;
    WezoneBoard *_board;
    
    UITextView *_textView;
    UILabel *_placeHolder;
    
    UIButton *_notiBtn;
    UIView *_bottomView;
    UIButton *_imgDeleteBtn;
    UIImageView *_imgView;
    
    UIEdgeInsets _insets;
    
    UIImagePickerController *_imagePickerController;
    
    UIImage *_uploadImage;
    NSString *_oldUrl;
    
}
@end

@implementation WezoneBoardViewController

- (instancetype)init:(WezoneModel *)wezone board:(WezoneBoard *)board {
    
    self = [self init];
    if ( self ) {
        
        _wezone = wezone;
        _board = board;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark -
#pragma mark Layout

- (void)makeLayout {
    
    [self makeRoot:NO title:[self getStringWithKey:@"wezone_board_write"] bgColor:UIColorFromRGB(0xeeeeee)];
    [self makeLeftBackButton];
    [self makeRightButton:@"btn_check" target:self selector:@selector(onClickRegist)];
    
    //[[UIImageView alloc] init:[Layout aspecRect:CGRectMake(15, (40 - 25) / 2, 25, 25)] parent:self.bodyView tag:0 imageName:nil];
    
    CGRect rect = CGRectMake(0, 0, self.bodyView.frame.size.width, self.bodyView.frame.size.height - [Layout aspecValue:79]);
    
    _textView = [[UITextView alloc] init:rect parent:self.bodyView tag:0 text:@"" color:UIColorFromRGB(0x212121) align:NSTextAlignmentLeft font:nil size:SIZE_TEXT_M delegate:self];
    _insets = _textView.textContainerInset;
    
    rect.origin.x = _textView.contentInset.left + _textView.textContainerInset.left + _textView.textContainer.lineFragmentPadding;
    rect.origin.y = _textView.textContainerInset.top;
    
    _placeHolder = [[UILabel alloc] init:rect parent:self.bodyView tag:0 text:[self getStringWithKey:@"wezone_review_write_placeholder"] color:UIColor_hint bgColor:nil align:NSTextAlignmentLeft font:nil size:SIZE_TEXT_M];
    [_placeHolder sizeToFit];
    
    float h = [Layout revert:self.bodyView.frame.size.height];
    float w = [Layout revert:self.bodyView.frame.size.width];
    
    _bottomView = [[UIView alloc] init:[Layout aspecRect:CGRectMake(0, h - 79, w, 79)] parent:self.bodyView tag:0];
    
    UIView *btn1 = [[UIView alloc] init:[Layout aspecRect:CGRectMake(0, 0, w, 40)] parent:_bottomView tag:0 color:UIColorFromRGB(0xffffff) borderColor:UIColor_line borderWidth:1];
    [btn1 addTarget:self action:@selector(onClickAddPhoto)];
    
    [[UIImageView alloc] init:[Layout aspecRect:CGRectMake(15, (40 - 25) / 2, 25, 25)] parent:btn1 tag:0 imageName:@"ic_add_a_photo_black"];
    [[UILabel alloc] init:[Layout aspecRect:CGRectMake(45, 0, w - 45, 40)] parent:btn1 tag:0 text:[self getStringWithKey:@"wezone_board_photo"] color:UIColor_text bgColor:nil align:NSTextAlignmentLeft font:nil size:SIZE_TEXT_M];
    
    UIView *btn2 = [[UIView alloc] init:[Layout aspecRect:CGRectMake(0, 39, w, 40)] parent:_bottomView tag:0 color:UIColorFromRGB(0xffffff) borderColor:UIColor_line borderWidth:1];
    [btn2 addTarget:self action:@selector(onClickRegistNoti)];
    
    [[UIImageView alloc] init:[Layout aspecRect:CGRectMake(15, (40 - 25) / 2, 25, 25)] parent:btn2 tag:0 imageName:@"btn_group_chat"];
    [[UILabel alloc] init:[Layout aspecRect:CGRectMake(45, 0, w - 45, 40)] parent:btn2 tag:0 text:[self getStringWithKey:@"wezone_board_notice_regist"] color:UIColor_text bgColor:nil align:NSTextAlignmentLeft font:nil size:SIZE_TEXT_M];
    
    _notiBtn = [[[UIButton alloc] init:[Layout aspecRect:CGRectMake(w - 40, (40 - 25) / 2, 25, 25)] parent:btn2 tag:0 target:self action:@selector(onClickRegistNoti)] addImageName:nil highlightedImageName:nil selectedImageName:@"btn_check_box" disabledImageName:nil];
    [_notiBtn setBorder:UIColor_line width:1 corner:3];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [self setContent];
}

- (void)setContent {

    _textView.text = _board.content;
  
    if ( [_board.board_file count] > 0 ) {
        
        NSDictionary *file = [_board.board_file objectAtIndex:0];
        
        if ( [file valueForKey:@"url"] ) {
            
            [[GALLangtudyEngine sharedEngine] getImageWithUrl:[file valueForKey:@"url"] completionHandler:^(UIImage *image, BOOL isInCache) {
                
                if ( image ) {
                    _oldUrl = [file valueForKey:@"url"] ;
                    [self setContentImage:image];
                }
            } errorHandler:^(NSDictionary *data, NSError *error) {
                
            }];
        }
    }
    _placeHolder.hidden = _textView.text.length > 0;
    _notiBtn.selected = [_board.notice_flag isEqualToString:@"T"];
}

- (void)setContentImage:(UIImage *)image {
    
    if ( _imgView ) {
        [_imgView removeFromSuperview];
        _imgView = nil;
    }
    if ( _imgDeleteBtn ) {
        [_imgDeleteBtn removeFromSuperview];
        _imgDeleteBtn = nil;
    }
    if ( image ) {
    
        float rate = image.size.height / image.size.width;
        float w = _textView.frame.size.width  / 2;
        CGRect rect = CGRectMake((_textView.frame.size.width - w) / 2, [Layout aspecValue:15], w, w * rate);
        
        _imgView = [[UIImageView alloc] init:[Layout aspecRect:rect] parent:_textView tag:0 image:image];
        _imgView.contentMode = UIViewContentModeScaleAspectFit;
        _textView.textContainerInset = UIEdgeInsetsMake(rect.origin.y + rect.size.height + _insets.top + [Layout aspecValue:10], _insets.left, _insets.bottom, _insets.right);
        
        float b = [Layout aspecValue:15];
        _imgDeleteBtn = [[[UIButton alloc] init:CGRectMake(rect.origin.x + rect.size.width - b / 2, rect.origin.y - b / 2, b, b) parent:_textView tag:0 target:self action:@selector(onClickDeletePhoto)] addImageName:@"btn_close_black"];
        [_imgDeleteBtn setBorder:UIColorFromRGB(0x757575) width:2 corner:b / 2];
        //[_imgDeleteBtn setBackgroundColor:UIColorFromRGB(0xffffff)];
        
    } else {
        _textView.textContainerInset = _insets;
    }
    
    [_placeHolder setY:_textView.textContainerInset.top];
}

- (void)onClickRegist {
    
    if ( _textView.text.length == 0 ) {
        [GALToastView showWithText:[self getStringWithKey:@"wezone_board_write_empty"]];
        return;
    }
    
    [self dismissKeyboard];
    
    GALLangtudyEngine *engine = [GALLangtudyEngine sharedEngine];
    if ( _uploadImage ) {
        [engine uploadImage:_imgView.image withUuid:ApplicationDelegate.loginData.user_info.uuid type:@"bo" id:nil status:@"2" resultHandler:^(NSString *imageUrl) {
            
            _uploadImage = nil;
            [self sendRegistBoard:imageUrl];
            
        } errorHandler:^(NSDictionary *data, NSError *error) {
            [GALToastView showWithText:[self getStringWithKey:@"file_upload_failed"]];
        }];
    } else {
        
        [self sendRegistBoard:nil];
    }
}

- (void)sendRegistBoard:(NSString *)imageUrl {
    
    
    NSString *notice_flag = _notiBtn.selected ? @"T":@"F";
    NSString *content = _textView.text;
    
    if ( _board ) {
        
        NSString *put_flag = @"";
        
        BOOL modifyImage = imageUrl || (imageUrl == nil && _oldUrl);
        BOOL modifyContent = [_board.content isEqualToString:content] == NO || [_board.notice_flag isEqualToString:notice_flag] == NO;
        
        if ( modifyImage == NO && modifyContent == NO ) return;
        
        if ( modifyImage && modifyContent ) {
            put_flag = @"A";
        } else if ( modifyImage ) {
            put_flag = @"B";
        } else {
            put_flag = @"C";
        }
   
        [[GALLangtudyEngine sharedEngine] sendModifyBoard:_board.board_id put_flag:put_flag notice_flag:notice_flag content:content url:imageUrl resultHandler:^(NSInteger board_id){
            
            [self goBack];
            
        } errorHandler:^(NSDictionary *data, NSError *error) {
            
            [self showErrorToast:data error:error];
        }];
    
    } else {
        
        [[GALLangtudyEngine sharedEngine] sendRegistBoard:_wezone.wezone_id notice_flag:notice_flag content:content url:imageUrl resultHandler:^(NSInteger board_id){
            
            [self goBack];
            
        } errorHandler:^(NSDictionary *data, NSError *error) {
            
            [self showErrorToast:data error:error];
        }];
    }

}

- (void)onClickAddPhoto {
    
    [self dismissKeyboard];
    
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

- (void)onClickDeletePhoto {
    
    [self dismissKeyboard];
    [self setContentImage:nil];
}

- (void)onClickRegistNoti {
    
    _notiBtn.selected = !_notiBtn.selected;
    [self dismissKeyboard];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}



#pragma mark - Keyboard Notification Function
- (void)keyboardWillShow: (NSNotification *)notification{
    
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (UIInterfaceOrientationIsLandscape(interfaceOrientation)) {
        CGFloat tmp = keyboardSize.height;
        keyboardSize.height = keyboardSize.width;
        keyboardSize.width = tmp;
    }
    NSLog(@">> %s - keyboardSize:%@", __func__, NSStringFromCGSize(keyboardSize));
    
    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         CGRect rect = self.bodyView.frame;
                        [_textView setHeight:rect.size.height - keyboardSize.height - [Layout aspecValue:79]];
                        [_bottomView setY:rect.size.height - keyboardSize.height - [Layout aspecValue:79]];
                     }
                     completion:nil
     ];
}

- (void)keyboardWillHide: (NSNotification *)notification{
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (UIInterfaceOrientationIsLandscape(interfaceOrientation)) {
        CGFloat tmp = keyboardSize.height;
        keyboardSize.height = keyboardSize.width;
        keyboardSize.width = tmp;
    }
    NSLog(@">> %s - keyboardSize:%@", __func__, NSStringFromCGSize(keyboardSize));
    
    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         CGRect rect = self.bodyView.frame;
                         [_textView setHeight:rect.size.height - [Layout aspecValue:79]];
                         [_bottomView setY:rect.size.height - [Layout aspecValue:79]];
                     }
                     completion:nil
     ];
}

- (void) dismissKeyboard{
    [_textView endEditing:YES];
}

#pragma mark -
#pragma mark UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    NSString *string = [textView.text stringByReplacingCharactersInRange:range withString:text];
    
    _placeHolder.hidden = string.length > 0;
    
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark ImagePicker

- (void)setPickerImage:(UIImage *)image {
    
    _uploadImage = image;
    [self setContentImage:image];
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
