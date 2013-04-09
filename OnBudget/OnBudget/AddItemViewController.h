//
//  AddItemViewController.h
//  OnBudget
//
//  Created by KEVIN SCHIROO on 2/13/13.
//  Copyright (c) 2013 KEVIN SCHIROO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddItemViewController : UITableViewController <UITextFieldDelegate>
/*
@property (strong, nonatomic) NSString *itemNameInput;
@property (strong, nonatomic) NSNumber *itemCostInput;
@property (strong, nonatomic) NSNumber *itemQuantityInput;
@property (strong, nonatomic) NSNumber *itemTaxedInput;
@property (strong, nonatomic) NSNumber *rowIfEdit;
 */
@property (strong, nonatomic) NSMutableDictionary *item;
@property (strong,nonatomic) NSNumber *isEdit;
@property (strong, nonatomic) NSMutableArray *allItems;

@end
