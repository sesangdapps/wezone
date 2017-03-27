//
//  WezoneSearchViewController.m
//  wezone
//
//  Created by Kim Sunmi on 2017. 3. 23..
//  Copyright © 2017년 Kim Sunmi. All rights reserved.
//

#import "WezoneSearchViewController.h"
#import "WezoneListView.h"
#import "UIFont+Layout.h"

@interface WezoneSearchViewController ()<UITextFieldDelegate>
{
    UIView *_searchView;
    UIScrollView *_hashtagView;
    UITextField *_searchInput;
    WezoneListView *_wezoneListView;
    UIScrollView *_listView;
    NSMutableArray *_hashtagList;
}
@end

@implementation WezoneSearchViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self getHashtag];
    [self getWezone];
}


#pragma mark -
#pragma mark Layout

- (void)makeLayout {
    
    [self makeRoot:YES title:[self getStringWithKey:@"wezone_search_title"] bgColor:UIColorFromRGB(0xeeeeee)];
    [self makeLeftBackButton];
    
    float w = [Layout revert:self.bodyView.frame.size.width];
    float h = [Layout revert:self.bodyView.frame.size.height];
    float y = 0;
    
    y += [self makeSearchView:y w:w];
    y += [self makeHashtag:y w:w];
    
    [self makeWezoneList:y w:w h:h - y];
}

- (float)makeSearchView:(float)y w:(float)w {
    
    _searchView = [[UIView alloc] init:[Layout aspecRect:CGRectMake(0, y, w, 44)] parent:self.bodyView tag:0 color:UIColorFromRGB(0xefeff4)];
    
    _searchInput = [[[UITextField alloc]init:[Layout aspecRect:CGRectMake(10, 6, w - 20, 32)] parent:_searchView tag:0] defaultStyle:@"" placeholder:STR(@"wezone_search_placeholder") type:UIKeyboardTypeDefault password:NO delegate:self];
    [_searchInput setFont:[UIFont defalutFont:nil size:[Layout aspecValue:13.0f]]];
    
    UIView *right = [[UIView alloc] initWithFrame:[Layout aspecRect:CGRectMake(0, 0, 35, 25)]];
    [[[UIButton alloc] init:[Layout aspecRect:CGRectMake(0, 0, 25, 25)] parent:right tag:0 target:self action:@selector(onClickSearch)] addImageName:@"ic_seach"];
    
    _searchInput.rightView = right;
    
    _searchInput.rightViewMode = UITextFieldViewModeAlways;
    
    return 44;
}

- (float)makeHashtag:(float)y w:(float)w {
    
    UIView *view = [[UIView alloc] init:[Layout aspecRect:CGRectMake(0, y, w, 64)] parent:self.bodyView tag:0];
   
    [[UILabel alloc] init:[Layout aspecRect:CGRectMake(10, 0, w - 20, 20)] parent:view tag:0 text:[self getStringWithKey:@"wezone_search_hashtag"] color:UIColor_text bgColor:nil align:NSTextAlignmentLeft font:nil size:SIZE_TEXT_S];
    
    _hashtagView = [[UIScrollView alloc] init:[Layout aspecRect:CGRectMake(0, 20, w, 44)] parent:view tag:0 color:UIColorFromRGB(0xefeff4)];
    
    return 64;
}

- (void)makeWezoneList:(float)y w:(float)w h:(float)h{
    
    _listView = [[UIScrollView alloc] init:[Layout aspecRect:CGRectMake(0, y, w, h)] parent:self.bodyView tag:0 color:UIColorFromRGB(0xffffff)];
    
    _wezoneListView = [[WezoneListView alloc] init:STR(@"wezone_near_wezone") rect:[Layout aspecRect:CGRectMake(0, 0, w, 44)] parent:_listView sizeChanged:^(CGRect rect) {
        
        [_listView setContentSize:CGSizeMake(_listView.frame.size.width, _wezoneListView.frame.origin.y + _wezoneListView.frame.size.height)];
    }];
}

- (void)makeHashtagList:(NSArray *)list {
    
    [CommonUtil removeAllChildView:_hashtagView];
    
    float x = 10;
    
    for( NSString *hashtag in list ) {
        
        float w = [Layout revert:[Layout stringWidth:hashtag font:nil fontSize:[Layout aspecValue:SIZE_TEXT_S]] + 30];
        
        UIButton *button = [[[[UIButton alloc] init:[Layout aspecRect:CGRectMake(x, 5, w, 30)] parent:_hashtagView tag:0 target:self action:@selector(onClickHashtag:)] addBackgroundImageName:@"btn_hash_tag"] addTitle:hashtag normalColor:UIColorFromRGB(0xffffff) highlightedColor:nil disabledColor:nil font:nil size:[Layout aspecValue:SIZE_TEXT_S]];
        button.layer.cornerRadius = [Layout aspecValue:10];
        
        x += [Layout revert:button.frame.size.width] + 10;
    }
    [_hashtagView setContentSize:CGSizeMake([Layout aspecValue:x], _hashtagView.frame.size.height)];
}

- (void)onClickHashtag:(UIButton *)button {
    
    _searchInput.text = button.titleLabel.text;
}

- (void)onClickSearch {
    
    [self getWezone:_searchInput.text];
}

- (void)getWezone {
    
    GALLangtudyEngine *engine = [GALLangtudyEngine sharedEngine];
    
    [engine getWezoneList:ApplicationDelegate.loginData.user_longitude latitude:ApplicationDelegate.loginData.user_latitude resultHandler:^(int total_count, NSArray *list){
        
        for(WezoneModel *wezone in list) {
            
            wezone.isJoin = NO;
        }
        [_wezoneListView reloadData:list];
        
    } errorHandler:^(NSDictionary *data, NSError *error) {
        
        NSString *errorCode = data[@"code"];
        NSLog(@"%@",errorCode);
    }];
}

- (void)getWezone:(NSString *)keyword {
    
    GALLangtudyEngine *engine = [GALLangtudyEngine sharedEngine];
    
    NSString *search_type = [_hashtagList containsObject:keyword] ? @"1" : @"1";
    
    [engine getWezoneList:search_type keyword:keyword longitude:ApplicationDelegate.loginData.user_longitude latitude:ApplicationDelegate.loginData.user_latitude offset:0 limit:10 resultHandler:^(int total_count, NSArray *list){
        
        for(WezoneModel *wezone in list) {
            wezone.isJoin = NO;
        }
        [_wezoneListView reloadData:list];
        
    } errorHandler:^(NSDictionary *data, NSError *error) {
        
        NSString *errorCode = data[@"code"];
        NSLog(@"%@",errorCode);
    }];
}

- (void)getHashtag {
    
    GALLangtudyEngine *engine = [GALLangtudyEngine sharedEngine];
    
    [engine getWezoneHashtag:^(int total_count, NSArray *list){
        
        _hashtagList = [NSMutableArray array];
        for(NSDictionary *dic in list) {
            [_hashtagList addObject:[NSString stringWithFormat:@"#%@", [dic valueForKey:@"hashtag"]]];
        }
        [self makeHashtagList:_hashtagList];
        
    } errorHandler:^(NSDictionary *data, NSError *error) {
        
        NSString *errorCode = data[@"code"];
        NSLog(@"%@",errorCode);
    }];
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
