//
//  CommonTableView.h
//  sobanne
//
//  Created by Kim Sunmi on 2017. 2. 9..
//  Copyright © 2017년 Kim Sunmi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Layout.h"
#import "CommonTableCell.h"

#define VIEW_TABLE_CELL 100

@class CommonTableView;

@protocol CommonTableViewDelegate <UITableViewDataSource>

- (void)makeCell:(CommonTableView *)tableView cell:(CommonTableCell *)cell indexPath:(NSIndexPath *)indexPath;
- (void)makeBlankCell:(CommonTableView *)tableView cell:(CommonTableCell *)cell indexPath:(NSIndexPath *)indexPath;
- (void)clickCell:(CommonTableView *)tableView indexPath:(NSIndexPath *)indexPath;
- (void)moreData:(CommonTableView *)tableView;
- (void)scrollViewChanged:(UIScrollView *)scrollView;

@end

@interface CommonTableView : UITableView<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *dataList;
@property (nonatomic, assign) int cellHeight;
@property (nonatomic, strong) NSString * cellIdentifier;
@property (nonatomic, strong) NSString * emptyMessage;
@property (nonatomic, assign) int totalPage;
@property (nonatomic, assign) int currentPage;
@property (nonatomic, assign) float hiddenRow;
@property (nonatomic, assign) BOOL hasNextPage;

@property (nonatomic, strong) id<CommonTableViewDelegate> tableViewDelegate;

- (instancetype)init:(CGRect)rect parent:(UIView*)parent tag:(NSInteger)tag color:(UIColor *)color cellIdentifier:(NSString *)cellIdentifier cellHeight:(int)cellHeight emptyMessage:(NSString *)emptyMessage hiddenRow:(float)hiddenRow tableViewDelegate:(id<CommonTableViewDelegate>) tableViewDelegate;

- (void)reloadData:(NSMutableArray *)dataList;
@end
