//
//  WezoneBoardDetailViewController.m
//  wezone
//
//  Created by Kim Sunmi on 2017. 3. 20..
//  Copyright © 2017년 Kim Sunmi. All rights reserved.
//

#import "WezoneBoardDetailViewController.h"
#import "WezoneBoardViewController.h"

@interface WezoneBoardDetailViewController ()<UIPopoverPresentationControllerDelegate>
{
    WezoneModel *_wezone;
    WezoneBoard *_board;
    UIView *_commentView;
    UIView *_inputView;
    UITextField *_textField;
}
@end

@implementation WezoneBoardDetailViewController

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

- (void)viewWillAppear:(BOOL)animated {
    
    if ( _board == nil ) {
        [self goBack];
        return;
    }
    [self getWezoneBoard:_board.board_id];
}

#pragma mark -
#pragma mark Layout

- (void)makeLayout {
    
    [self makeRoot:YES title:_wezone.title bgColor:UIColorFromRGB(0xeeeeee)];
    [self makeLeftBackButton];
    
    if ( [_board.uuid isEqualToString:ApplicationDelegate.loginData.user_info.uuid] ) {
        [self makeRightButton:@"btn_more_white" target:self selector:@selector(onClickBoardMenu:)];
    }
    
    float w = [Layout revert:self.rootView.frame.size.width];
    float h = [Layout aspecValue:40];
    float y = [Layout revert:self.rootView.frame.size.height] - h;
    
    _inputView = [[UIView alloc] init:[Layout aspecRect:CGRectMake(0, y, w, h)] parent:self.rootView tag:0 color:UIColor_main borderColor:UIColor_line borderWidth:1];
    _textField = [[UITextField alloc]init:[Layout aspecRect:CGRectMake(0, 0, w, h)] parent:_inputView tag:0 text:@"" placeholder:[self getStringWithKey:@"wezone_board_comment_placeholder"] color:UIColor_text align:NSTextAlignmentLeft font:nil size:SIZE_TEXT_M type:UIKeyboardTypeDefault password:NO delegate:nil];
    
    [[[[UIButton alloc] init:[Layout aspecRect:CGRectMake(w - h, 0, h, h)] parent:_inputView tag:0 target:self action:@selector(onClickRegist)] addImageName:@"btn_check"] addBackgroundColor:UIColorFromRGB(0x689df9)];
    
    [self.scrollView setHeight:self.scrollView.frame.size.height - _inputView.frame.size.height];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [self.rootView bringSubviewToFront:_inputView];
    
    [self.bodyView addTarget:self action:@selector(dismissKeyboard)];
}

- (float)makeBoard:(WezoneBoard *)board parent:(UIView *)parent tag:(int)tag x:(float)x y:(float)y w:(float)w {
    
    [CommonUtil removeAllChildView:parent];
    
    UIView *view = [[UIView alloc] init:[Layout aspecRect:CGRectMake(x, y, w, 80)] parent:parent tag:tag color:UIColorFromRGB(0xffffff)];
    
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
    
    y = 60;
    UIImageView *img = [[UIImageView alloc] init:[Layout aspecRect:CGRectMake(0, y, w, 0)] parent:view tag:0 imageName:nil];
    
    UILabel *contentLabel = [[UILabel alloc] init:[Layout aspecRect:CGRectMake(15, y, w - 30, 100)] parent:view tag:0 text:board.content color:UIColor_text bgColor:nil align:NSTextAlignmentLeft font:nil size:[Layout aspecValue:SIZE_TEXT_SS]];
    [contentLabel sizeToFit];
    y += [Layout revert:contentLabel.frame.size.height] + 10;
    
    _commentView = [[UIView alloc] init:[Layout aspecRect:CGRectMake(x, y, w, 0)] parent:view tag:0 color:UIColorFromRGB(0xffffff)];
    if ( board.comments ) {
        y += [self makeBoradCommentList:board.comments total:board.comment_count parent:_commentView];
    }
    
    //UIView *line = [UIView makeBottomLine:[Layout aspecRect:CGRectMake(x, y, w, 1)] parent:view tag:0 color:UIColor_line];
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
                    [_commentView posBelow:contentLabel margin:10];
                    
                    [view sizeToFitHeight:_commentView padding:0];
                    //[line alignBottom:view margin:0];
                    
                    [self setBodyHiehgt:view.frame.size.height];
                    
                }
            } errorHandler:^(NSDictionary *data, NSError *error) {
                
            }];
        }
    }
    if ( board.comments == nil ) {
        [self getWezoneBoardCommentList:0 limit:10 completion:nil];
    }
    
    [view sizeToFitHeight:_commentView padding:0];
    //[line alignBottom:view margin:0];
    
    return [Layout revert:view.frame.size.height];
}

- (float)makeBoradCommentList:(NSArray *)list total:(int)total parent:(UIView *)parent {
    
    [_board.comments addObjectsFromArray:list];
    _board.comment_count = total;
    
    [CommonUtil removeAllChildView:parent];
    
    if ( [_board.comments count] == 0 ) return 0;
    
    float x = 0;
    float w = [Layout revert:parent.frame.size.width];
    float y = 0;
    int index = 0;
    
//    UIView *titleView = [[UIView alloc] init:[Layout aspecRect:CGRectMake(x, y, w, 20)] parent:parent tag:0 color:UIColorFromRGB(0xffffff)];
//    
//    NSString *text = [NSString stringWithFormat:[self getStringWithKey:@"wezone_comment_all"], total];
//    UILabel *label = [[UILabel alloc] init:[Layout aspecRect:CGRectMake(15, 0, w / 2, 20)] parent:titleView tag:0 text:text color:UIColor_sub_text bgColor:nil align:NSTextAlignmentLeft font:nil size:[Layout aspecValue:SIZE_TEXT_SS]];
//    y += 20;
    
    for( WezoneComment *comment in _board.comments) {
        index++;
        y += [self makeComment:comment parent:parent tag:index x:x y:y w:w];
    }
    if ( _board.comments.count < total ) {
        index++;
        y += [self makeFooter:(int)(total -_board.comments.count) parent:parent tag:index x:x y:y w:w selector:@selector(onClickMoreComment)];
    }
    
    [parent setHeight:[Layout aspecValue:y]];
    
    return y;
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
    
    WezoneBoardViewController *vc = [[WezoneBoardViewController alloc] init:_wezone board:_board];
    [ApplicationDelegate.mainNaviController pushViewController:vc animated:YES];
}

- (void) onClickDeleteBoard:(UIButton *)button {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    GALLangtudyEngine *engine = [GALLangtudyEngine sharedEngine];
    [engine sendDeleteBoard:_board.board_id resultHandler:^(){
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self goBack];
        });
        
    } errorHandler:^(NSDictionary *data, NSError *error) {
        
        NSString *errorCode = data[@"code"];
        NSLog(@"%@",errorCode);
    }];
}

- (void)onClickMoreComment {
    
    [self getWezoneBoardCommentList:(int)_board.comments.count limit:10 completion:nil] ;
}

- (void)getWezoneBoard:(NSString *)board_id {
    
    GALLangtudyEngine *engine = [GALLangtudyEngine sharedEngine];
    [engine getWezoneBoard:board_id resultHandler:^(WezoneBoard *board){
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            _board = board;
            [self makeBoard:_board parent:self.bodyView tag:0 x:0 y:0 w:[Layout revert:self.bodyView.frame.size.width]];
        });
        
    } errorHandler:^(NSDictionary *data, NSError *error) {
        
        NSString *errorCode = data[@"code"];
        NSLog(@"%@",errorCode);
    }];
}

- (void)getWezoneBoardCommentList:(int)offset limit:(int)limit completion:(void (^)(void))completion {
    
    NSString *wezoneId = _wezone.wezone_id;
    
    if ( _board.comments == nil ) {
        _board.comments = [NSMutableArray array];
    }
    if ( offset == 0 ) {
        [_board.comments removeAllObjects];
    }
    GALLangtudyEngine *engine = [GALLangtudyEngine sharedEngine];
    [engine getWezoneCommentList:wezoneId type:@"B" board_id:_board.board_id offset:offset limit:limit resultHandler:^(int total_count, NSArray *list){
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self makeBoradCommentList:list total:total_count parent:_commentView];
            
            [_commentView.superview sizeToFitHeight:_commentView padding:0];
            [self setBodyHiehgt:_commentView.superview.frame.size.height];
            
            if ( completion ) {
                completion();
            }
        });
        
    } errorHandler:^(NSDictionary *data, NSError *error) {
        
        NSString *errorCode = data[@"code"];
        NSLog(@"%@",errorCode);
    }];
}


- (void)onClickRegist {
    
    if ( _textField.text.length == 0 ) {
        [GALToastView showWithText:[self getStringWithKey:@"wezone_review_write_placeholder"]];
        return;
    }
    
    NSString *content = _textField.text;
    _textField.text = @"";
    
    GALLangtudyEngine *engine = [GALLangtudyEngine sharedEngine];
    [engine sendRegistComment:_wezone.wezone_id type:@"B" board_id:_board.board_id content:content resultHandler:^(){
        
        [self getWezoneBoardCommentList:0 limit:_board.comments.count + 1 completion:^(){
            
            UIView *view = [_commentView viewWithTag:1];
            if ( view ) {
                float t = _commentView.frame.origin.y + view.frame.origin.y;
                float b = t + view.frame.size.height;//[_commentView convertPoint:CGPointMake(0, view.frame.origin.y + view.frame.size.height) toView:self.bodyView].y;
                float off = self.scrollView.contentOffset.y;
                
                if ( self.scrollView.contentOffset.y + self.scrollView.frame.size.height < b ) {
                    off = b - self.scrollView.frame.size.height;
                }
                if ( self.scrollView.contentOffset.y > t ) {
                    off = t;
                }
                off = MAX(0, MIN(off, self.scrollView.contentSize.height - self.scrollView.frame.size.height));
                
                NSLog(@"scroll %f, %f, %f, %f", self.scrollView.contentOffset.y, t, b, off);
                if ( off != self.scrollView.contentOffset.y ) {
                    [self.scrollView setContentOffset:CGPointMake(0, off) animated:YES];
                }
            }
        }];
        
    } errorHandler:^(NSDictionary *data, NSError *error) {
        
        [self showErrorToast:data error:error];
    }];
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
    
    float bottom = self.scrollView.contentSize.height - self.scrollView.contentOffset.y + self.scrollView.frame.size.height;
    
    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         CGRect rect = self.rootView.frame;
                         [self.scrollView setHeight:rect.size.height - self.scrollView.frame.origin.y - keyboardSize.height - _inputView.frame.size.height];
                         
                         self.scrollView.contentOffset = CGPointMake(0, MIN(self.scrollView.contentOffset.y + keyboardSize.height, self.scrollView.contentSize.height - self.scrollView.frame.size.height));
                         //float bottom = self.scrollView.contentSize.height - self.scrollView.contentOffset.y + self.scrollView.frame.size.height;
                         
                         [_inputView setY:rect.size.height - _inputView.frame.size.height - keyboardSize.height];
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
                         CGRect rect = self.rootView.frame;
                         [self.scrollView setHeight:rect.size.height - self.scrollView.frame.origin.y - _inputView.frame.size.height];
                         self.scrollView.contentOffset = CGPointMake(0, MAX(self.scrollView.contentOffset.y - keyboardSize.height, 0));
                         
                         [_inputView setY:rect.size.height - _inputView.frame.size.height];
                     }
                     completion:nil
     ];
}

- (void) dismissKeyboard{
    [_textField endEditing:YES];
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
