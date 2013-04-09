//
//  ItemListViewController.h
//  OnBudget
//
//  Created by KEVIN SCHIROO on 3/12/13.
//  Copyright (c) 2013 KEVIN SCHIROO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ItemListViewController : UITableViewController
@property (strong, nonatomic) NSMutableArray* selectedList;
@property (strong, nonatomic) NSMutableArray* allItems;
@end
