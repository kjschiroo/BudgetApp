//
//  EditBudgetViewController.m
//  OnBudget
//
//  Created by KEVIN SCHIROO on 2/21/13.
//  Copyright (c) 2013 KEVIN SCHIROO. All rights reserved.
//

#import "EditBudgetViewController.h"

@interface EditBudgetViewController ()
@property (weak, nonatomic) IBOutlet UITextField *BudgetInput;

@end

@implementation EditBudgetViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if(_budget == nil)
    {
        _BudgetInput.text = @"";
    }
    else
    {
        _BudgetInput.text = [NSString stringWithFormat:@"%.02f", _budget.floatValue];
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    //Only allow numbers with two or less decimal places
    if(textField == self.BudgetInput)
    {
        NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        
        NSArray *sep = [newString componentsSeparatedByString:@"."];
        if([sep count] <=2)
        {
            if([sep count] ==2)
            {
                return [sep[1] length]<=2;
            }
            return YES;
        }
        else
        {
            return NO;
        }
    }
    return YES;
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"ReturnBudget"])
    {
        NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        self.budget = [f numberFromString:self.BudgetInput.text];
        if(self.budget == nil)
        {
            self.budget = [[NSNumber alloc] initWithDouble:0.00];
        }
    
    }
}

@end
