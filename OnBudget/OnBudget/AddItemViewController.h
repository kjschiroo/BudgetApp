//
//  AddItemViewController.h
//  OnBudget
//
//  Created by KEVIN SCHIROO on 2/13/13.
//  Copyright (c) 2013 KEVIN SCHIROO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddItemViewController : UITableViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *itemNameInput;
@property (weak, nonatomic) NSNumber *itemCostInput;
@property (weak, nonatomic) NSNumber *itemQuantityInput;
@property (weak, nonatomic) NSNumber *itemTaxedInput;

@end
