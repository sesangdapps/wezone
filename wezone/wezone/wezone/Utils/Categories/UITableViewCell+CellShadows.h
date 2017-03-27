//
//  UITableViewCell+CellShadows.h
//  Langtudy
//
//  Created by SinSuMin on 2016. 9. 21..
//  Copyright © 2016년 galuster. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableViewCell (CellShadows)

/** adds a drop shadow to the background view of the (grouped) cell */
- (void)addShadowToCellInTableView:(UITableView *)tableView
                       atIndexPath:(NSIndexPath *)indexPath;

@end
