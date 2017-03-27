//
//  CommonTableView.m
//  sobanne
//
//  Created by Kim Sunmi on 2017. 2. 9..
//  Copyright © 2017년 Kim Sunmi. All rights reserved.
//

#import "CommonTableView.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-value"
#pragma clang diagnostic ignored "-Wnonnull"

@implementation CommonTableView

- (instancetype)init:(CGRect)rect parent:(UIView*)parent tag:(NSInteger)tag color:(UIColor *)color cellIdentifier:(NSString *)cellIdentifier cellHeight:(int)cellHeight emptyMessage:(NSString *)emptyMessage hiddenRow:(float)hiddenRow tableViewDelegate:(id<CommonTableViewDelegate>) tableViewDelegate  {
    
    self = [self init:rect parent:parent tag:tag color:color];
    
    if ( self ) {
        
        self.cellHeight = cellHeight;
        self.cellIdentifier = cellIdentifier;
        self.emptyMessage = emptyMessage;
        self.tableViewDelegate = tableViewDelegate;
        self.hiddenRow = hiddenRow;
        
        [self setDelegate:self];
        [self setDataSource:self];
        [self setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        
        if ( cellHeight == 0 ) {
            self.rowHeight = UITableViewAutomaticDimension;
            self.estimatedRowHeight = 50;
        }
    }
    return self;
}

- (void)reloadData:(NSMutableArray *)dataList {

    self.dataList = dataList;
    [self reloadData];
}

- (void)moreData {
    
}

- (void)makeCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath {
    
}

- (void)clickCell:(NSIndexPath *)indexPath {
   
    
}

- (void)makeBlankView:(UIView *)view text1:(NSString *)text1 text2:(NSString *)text2 text3:(NSString *)text3 {
    
//    float y = view.frame.size.height / 2 - [Layout aspecValue:50];
//    float x = [Layout aspecValue:30];
//    float w = view.frame.size.width - [Layout aspecValue:60];
//    
//    UILabel *label = [[UILabel alloc] init:CGRectMake(x, y, w, 22) parent:view tag:0 text:text1 color:RGBHEX(0x5a5a5a) bgColor:nil align:NSTextAlignmentLeft font:FONT_REGULAR size:[Layout aspecValue:20.0]];
//    [label sizeToFit];
//    [label setX:x + (w - label.frame.size.width) / 2];
//    
//    if ( text2 ) {
//        y += label.frame.size.height + [Layout aspecValue:10];
//        label = [[UILabel alloc] init:CGRectMake(x, y, w, 17) parent:view tag:0 text:text2 color:RGBHEX(0xa5a5a5) bgColor:nil align:NSTextAlignmentLeft font:FONT_REGULAR size:[Layout aspecValue:15.0]];
//        [label sizeToFit];
//        [label setX:x + (w - label.frame.size.width) / 2];
//    }
//    
//    if ( text3 ) {
//        label = [[UILabel alloc] init:CGRectMake(x, y, w, 15) parent:view tag:0 text:text3 color:RGBHEX(0xa5a5a5) bgColor:nil align:NSTextAlignmentLeft font:FONT_REGULAR size:[Layout aspecValue:13.0]];
//        [label sizeToFit];
//        [label setY:(view.frame.size.height - label.frame.size.height) - [Layout aspecValue:33]];
//        [label setX:x + (w - label.frame.size.width) / 2];
//    }
}

#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    

    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
    
    NSInteger count = 0;
    if ( self.dataList == nil || self.dataList.count == 0 ) {
        if ( self.emptyMessage ) count = 1;
    } else {
        count = [self.dataList count];
    }
    if ( self.hiddenRow > 0 ) {
        count ++;
    }
    return count;
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat height = self.cellHeight;
    
    if ( self.hiddenRow > 0 && indexPath.row == 0 ) {
        
        return self.hiddenRow;
        
    } else if ( self.dataList == nil || self.dataList.count == 0 ) {
        
        return [Layout revert:self.frame.size.height];
        
    } else if ( self.cellHeight == 0 ) {
        
        //static CommonTableCell *cell = nil;
        //static dispatch_once_t onceToken;
        
        //dispatch_once(&onceToken, ^{
        CommonTableCell *cell = [self dequeueReusableCellWithIdentifier:self.cellIdentifier];
        if (cell == nil) {
            cell = [[CommonTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"empty_cell"];
            cell.backgroundColor = [UIColor clearColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        //});
        if ( self.tableViewDelegate ) {
            if ([self.tableViewDelegate respondsToSelector:@selector(makeCell:cell:indexPath:)]) {
                [self.tableViewDelegate makeCell:self cell:cell indexPath:indexPath];
            }
        }
        UIView *view = [cell.contentView viewWithTag:VIEW_TABLE_CELL];
        if ( view ) return view.frame.size.height;
    }
    return [Layout aspecValue:height];
    
}

- (CommonTableCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( self.hiddenRow > 0 && indexPath.row == 0 ) {
        
        CommonTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"hidden_cell"];
        if (cell == nil) {
            cell = [[CommonTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"hidden_cell"];
            cell.backgroundColor = [UIColor clearColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }        
        return cell;
        
    } else if ( self.dataList == nil || self.dataList.count == 0 ) {
        
        CommonTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"empty_cell"];
        if (cell == nil) {
            cell = [[CommonTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"empty_cell"];
            cell.backgroundColor = [UIColor clearColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if ( self.tableViewDelegate ) {
            if ([self.tableViewDelegate respondsToSelector:@selector(makeBlankCell:cell:indexPath:)]) {
                [self.tableViewDelegate makeBlankCell:self cell:cell indexPath:indexPath];
                return cell;
            }
        }
        CGRect rect = self.frame;
        UIView *view = [cell.contentView viewWithTag:VIEW_TABLE_CELL];
        if ( view == nil ) {
            view = [[UIView alloc] init:CGRectMake(0, 0, rect.size.width, rect.size.height) parent:cell.contentView tag:VIEW_TABLE_CELL color:nil];
        }

        UILabel *label = [view viewWithTag:VIEW_TABLE_CELL + 1];
        if  ( label == nil ) {
             label = [[UILabel alloc] init:CGRectMake(0, 0, rect.size.width, rect.size.height) parent:view tag:VIEW_TABLE_CELL + 1 text:@"" color:UIColorFromRGB(0x757575) bgColor:nil align:NSTextAlignmentCenter font:nil size:[Layout aspecValue:15.0f]];
        }
        label.text = self.emptyMessage;
        return cell;
        
    } else {
        
        CommonTableCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier];
        if (cell == nil) {
            cell = [[CommonTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:self.cellIdentifier];
            cell.backgroundColor = [UIColor clearColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        [cell.contentView setTag:indexPath.row];
        
        if ( self.tableViewDelegate ) {
            if ([self.tableViewDelegate respondsToSelector:@selector(makeCell:cell:indexPath:)]) {
                [self.tableViewDelegate makeCell:self cell:cell indexPath:indexPath];
            }
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ( self.tableViewDelegate ) {
        if ([self.tableViewDelegate respondsToSelector:@selector(clickCell:indexPath:)]) {
            [self.tableViewDelegate clickCell:self indexPath:indexPath];
        }
    }
}
/*
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code here for when you hit delete
    }
}
*/
#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if ( self.tableViewDelegate ) {
        if ([self.tableViewDelegate respondsToSelector:@selector(scrollViewChanged:)]) {
            [self.tableViewDelegate scrollViewChanged:self];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    NSLog(@"scrollViewDidEndDecelerating : %f, %f, %f, %f", scrollView.contentOffset.y, scrollView.frame.size.height, (scrollView.contentOffset.y + scrollView.frame.size.height), scrollView.contentSize.height);
    if ( scrollView.contentOffset.y + scrollView.frame.size.height >= scrollView.contentSize.height - 10 ) {
        
        if ( self.tableViewDelegate ) {
            if ([self.tableViewDelegate respondsToSelector:@selector(moreData:)]) {
                [self.tableViewDelegate moreData:self];
            }
        }
    }
    
    if ( self.tableViewDelegate ) {
        if ([self.tableViewDelegate respondsToSelector:@selector(scrollViewChanged:)]) {
            [self.tableViewDelegate scrollViewChanged:self];
        }
    }
}

@end

#pragma clang diagnostic pop
