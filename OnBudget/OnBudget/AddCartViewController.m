//
//  AddCartViewController.m
//  OnBudget
//
//  Created by KEVIN SCHIROO on 3/21/13.
//  Copyright (c) 2013 KEVIN SCHIROO. All rights reserved.
//

#import "AddCartViewController.h"
#import <AddressBookUI/AddressBookUI.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreLocation/CLPlacemark.h>

//#import <UIKit/UIKit.h>

@interface AddCartViewController ()
{
    //CLLocationManager *location;
}
@property (weak, nonatomic) IBOutlet UITextField *nameInput;
@property (weak, nonatomic) IBOutlet UITextField *budgetInput;
@property (weak, nonatomic) IBOutlet UITextField *taxRateInput;


@end

@implementation AddCartViewController

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
    if(self.cart == nil)
    {
        self.cart = [[NSMutableDictionary alloc] init];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if((textField == self.nameInput)|| textField == self.budgetInput)
    {
        [textField resignFirstResponder];
    }
    
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if(textField == self.budgetInput)
    {
        //only considering budget input
        NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        
        NSArray *sep = [newString componentsSeparatedByString:@"."];
        if([sep count] <=2)
        {
            //if there is already one decimal point
            if([sep count] ==2)
            {
                //Make sure there are only two places
                return [sep[1] length]<=2;
            }
            return YES;
        }
        else
        {
            //There would be more than one decimal point
            return NO;
        }
    }
    
    if(textField == self.taxRateInput)
    {
        //Considering only the tax rate input
        NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        
        NSArray *sep = [newString componentsSeparatedByString:@"."];
        if([sep count] <=2)
        {
            //if there is already one decimal point
            return YES;
        }
        else
        {
            //There would be more than one decimal point
            return NO;
        }
    }
    return YES;
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"ReturnCart"])
    {
        //The user wants to return a new cart
        if(![self.nameInput.text isEqualToString:@""])
        {
            //The name has been set
            
            //Set up a number formatter to read user input
            NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
            [f setNumberStyle:NSNumberFormatterDecimalStyle];
            
            //Set name
            self.cart[@"name"] = self.nameInput.text;
            
            //Set budget
            if([ f numberFromString:self.budgetInput.text] != nil)
            {
                self.cart[@"budget"] = [ f numberFromString:self.budgetInput.text];
            }
            
            //Set tax rate
            if([ f numberFromString:self.taxRateInput.text] != nil)
            {
                self.cart[@"tax"] = [ f numberFromString:self.taxRateInput.text];
            }
            
            //Initialize objects array
            self.cart[@"objects"] = [[NSMutableArray alloc] init];
        }
        
    }
}


@end
