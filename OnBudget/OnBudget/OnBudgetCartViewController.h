//
//  OnBudgetMasterViewController.h
//  OnBudget
//
//  Created by KEVIN SCHIROO on 2/13/13.
//  Copyright (c) 2013 KEVIN SCHIROO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OnBudgetCartViewController : UITableViewController
- (IBAction)done:(UIStoryboardSegue *)segue;
- (IBAction)cancel:(UIStoryboardSegue *)segue;
@property (strong, nonatomic) NSMutableDictionary *cart;
@property (strong, nonatomic) NSMutableArray *allItems;
/*
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSMutableArray *objects;
@property (strong, nonatomic) NSNumber *budget;
@property (strong, nonatomic) NSNumber *taxRate;
 */

@end
