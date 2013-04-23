//
//  AddItemViewController.m
//  OnBudget
//
//  Created by KEVIN SCHIROO on 2/13/13.
//  Copyright (c) 2013 KEVIN SCHIROO. All rights reserved.
//

#import "AddItemViewController.h"
const int DYNAMICSECTION = 1;

@interface AddItemViewController ()
@property (weak, nonatomic) IBOutlet UITextField *itemQuantityInputString;
@property (weak, nonatomic) IBOutlet UITextField *itemCostInputString;
@property (weak, nonatomic) IBOutlet UISwitch *itemTaxedInputSwitch;
@property (weak, nonatomic) IBOutlet UITextField *itemNameInputString;
//@property (weak, nonatomic) IBOutlet UIPickerView *prices;

@end

@implementation AddItemViewController

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
    if(self.item == nil)
    {
        self.item = [[NSMutableDictionary alloc] init];
    }
    //self.navigationItem.leftBarButtonItem = self.editButtonItem;
    /*
    if(self.itemNameInput != nil && self.itemCostInput != nil && self.itemQuantityInput != nil && self.itemTaxedInput != nil)
    {
        self.itemNameInputString.text = self.itemNameInput;
        self.itemCostInputString.text = [NSString stringWithFormat:@"%.02f", self.itemCostInput.floatValue];
        self.itemQuantityInputString.text = [NSString stringWithFormat:@"%.02f", self.itemQuantityInput.floatValue];
        self.itemTaxedInputSwitch.on = [self.itemTaxedInput boolValue];
    }
     */
    if(self.item[@"price"] != nil)
    {
        self.itemCostInputString.text = [NSString stringWithFormat:@"%@", self.item[@"price"]];
        
        //for(NSMutableDictionary *d in self.item[@"cost"])
        //{
        //    self.prices.dataSource = self.item[@"cost"];
        //}
    }
    if(self.item[@"name"] != nil)
    {
        self.itemNameInputString.text = self.item[@"name"];
        if([self.isEdit boolValue])
        {
            self.itemNameInputString.enabled = false;
        }
        for(NSMutableDictionary *d in self.allItems)
        {
            if([d[@"name"] caseInsensitiveCompare:self.item[@"name"]] == 0 )
            {
                self.item[@"cost"] = [ d[@"cost"] mutableCopy];
                break;
            }
        }
    }
    if(self.item[@"quantity"] != nil)
    {
        self.itemQuantityInputString.text = [NSString stringWithFormat:@"%@", (NSNumber *)self.item[@"quantity"]];
    }
    if(self.item[@"taxed"] != nil)
    {
        self.itemTaxedInputSwitch.on = [(NSNumber *)self.item[@"taxed"] boolValue];
    }

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"Text Field Should Return");
    if((textField == self.itemNameInputString)|| textField == self.itemCostInputString)
    {
        [textField resignFirstResponder];
    }
    
    return YES;
}

//Method drawn largly from
//http://stackoverflow.com/questions/8076160/limiting-text-field-entry-to-only-one-decimal-point
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSLog(@"should change characters in range");
    if(textField == self.itemCostInputString || textField == self.itemQuantityInputString)
    {
        NSLog(@"In If");
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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"ReturnInput"])
    {
        if(![self.itemNameInputString.text isEqualToString:@""])
        {
            NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
            [f setNumberStyle:NSNumberFormatterDecimalStyle];
            self.item[@"name"] = self.itemNameInputString.text;
            
            if([ f numberFromString:self.itemQuantityInputString.text] != nil)
            {
                self.item[@"quantity"] = [ f numberFromString:self.itemQuantityInputString.text];
            }
            else if([ f numberFromString:self.itemCostInputString.text] != nil)
            {
                self.item[@"quantity"] = [NSNumber numberWithInt:1];
            }
            
            self.item[@"taxed"] = [ NSNumber numberWithBool:[self.itemTaxedInputSwitch isOn]];
            
            
            bool found = false;
            if( [ f numberFromString:self.itemCostInputString.text] != nil )
            {
                for(NSMutableDictionary *d in self.allItems)
                {
                    if([d[@"name"] caseInsensitiveCompare:self.itemNameInputString.text] == 0 )
                    {
                    
                    
                        NSMutableDictionary *temp = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[ f numberFromString:self.itemCostInputString.text], @"cost", [NSDate date], @"date", nil];
                        [d[@"cost"] insertObject:temp atIndex:0];
                        //self.item[@"cost"] = [NSMutableDictionary dictionaryWithDictionary:d[@"cost"]];
                        self.item[@"cost"] = [ d[@"cost"] mutableCopy];
                    
                        found = true;
                        break;
                    }
                }
                self.item[@"price"] = [ f numberFromString:self.itemCostInputString.text];
            }
            
            if(!found)
            {
                if([ f numberFromString:self.itemCostInputString.text] != nil)
                {
                    if(self.item[@"cost"] == nil)
                    {
                        self.item[@"cost"] = [[NSMutableArray alloc] init];
                    }
                    
                    
                    NSMutableDictionary *temp = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[ f numberFromString:self.itemCostInputString.text], @"cost", [NSDate date], @"date", nil];
                    [self.item[@"cost"] insertObject:temp atIndex:0];
                    //self.item[@"cost"] = [ f numberFromString:self.itemCostInputString.text];
                }
                
                int i = 0;
                while(i < [self.allItems count] && [self.allItems[i][@"name"] caseInsensitiveCompare:self.itemNameInputString.text]<0)
                {
                    i++;
                }
                
                NSMutableDictionary *temp = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[ f numberFromString:self.itemCostInputString.text], @"cost", [NSDate date], @"date", nil];
                NSMutableArray *tempList = [[NSMutableArray alloc] init];
                [tempList insertObject:temp atIndex:0];
                NSMutableDictionary *item = [[NSMutableDictionary alloc] initWithObjectsAndKeys: self.itemNameInputString.text, @"name", tempList, @"cost", [NSNumber numberWithBool:NO], @"Selected", nil];
                [self.allItems insertObject:item atIndex:i];
            }
        }
        
    }
}


//Based in large part on
//http://stackoverflow.com/questions/10043521/adding-unknown-number-of-rows-to-static-cells-uitableview/10060997#comment15940351_10060997
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == DYNAMICSECTION)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == DYNAMICSECTION)
    {
        return UITableViewCellEditingStyleDelete;
    }
    else
    {
        return UITableViewCellEditingStyleNone;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == DYNAMICSECTION) {
        return [super tableView:tableView heightForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    } else {
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }
}

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    // if dynamic section make all rows the same indentation level as row 0
    if (indexPath.section == DYNAMICSECTION) {
        return [super tableView:tableView indentationLevelForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    } else {
        return [super tableView:tableView indentationLevelForRowAtIndexPath:indexPath];
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == DYNAMICSECTION ) {
        return [self.item[@"cost"] count];
    } else {
        return [super tableView:tableView numberOfRowsInSection:section];
    }
}

-(UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    
    if (indexPath.section == DYNAMICSECTION) {
        NSMutableDictionary *costDate = [self.item[@"cost"] objectAtIndex:indexPath.row];
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OldPriceCell"];
        
        if (!cell) {
            //cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"OldPriceCell"];
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"OldPriceCell"];
        }
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterLongStyle];
        cell.textLabel.text = [dateFormatter stringFromDate:costDate[@"date"]];
        cell.textLabel.font = [UIFont systemFontOfSize:17];
        
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        cell.detailTextLabel.text = [formatter stringFromNumber:costDate[@"cost"]];
        
        
        return cell;
    } else {
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
            if(indexPath.section == DYNAMICSECTION)
            {
                [self.item[@"cost"] removeObjectAtIndex:indexPath.row];
                for(NSMutableDictionary *d in self.allItems)
                {
                    if([d[@"name"] caseInsensitiveCompare:self.itemNameInputString.text] == 0 )
                    {
                        [d[@"cost"] removeObjectAtIndex:indexPath.row];
                        break;
                    }
                }
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == DYNAMICSECTION)
    {
        _itemCostInputString.text = [NSString stringWithFormat:@"%@", self.item[@"cost"][indexPath.row][@"cost"]];
    }
    else
    {
        //[super tableView:tableView didSelectRowAtIndexPath:indexPath];
    }
}



@end
