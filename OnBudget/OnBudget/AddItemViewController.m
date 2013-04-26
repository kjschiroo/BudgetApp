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
{
    BOOL altered;
}
@property (weak, nonatomic) IBOutlet UITextField *itemQuantityInputString;
@property (weak, nonatomic) IBOutlet UITextField *itemCostInputString;
@property (weak, nonatomic) IBOutlet UISwitch *itemTaxedInputSwitch;
@property (weak, nonatomic) IBOutlet UITextField *itemNameInputString;


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
    //At this point nothing has been altered
    altered = false;
    
    if(self.item == nil)
    {
        //if we were not given an item, we give ourselves one
        self.item = [[NSMutableDictionary alloc] init];
    }
    
    if(self.item[@"cost"] == nil)
    {
        //if the cost array isn't allocated we allocate it
        [self.item setObject:[[NSMutableArray alloc] init] forKey:@"cost"];
    }
    
    if(self.item[@"price"] != nil)
    {
        //if we have a price, write it out
        self.itemCostInputString.text = [NSString stringWithFormat:@"%@", self.item[@"price"]];
    }
    if(self.item[@"name"] != nil)
    {
        //if we have a name, write it out
        self.itemNameInputString.text = self.item[@"name"];
        
        if([self.isEdit boolValue])
        {
            //if the person is editing an existing item, they don't get to change the name
            self.itemNameInputString.enabled = false;
        }
        
        //see if this item happens to already exist in the big list
        for(NSMutableDictionary *d in self.allItems)
        {
            if([d[@"name"] caseInsensitiveCompare:self.item[@"name"]] == 0 )
            {
                //if it does we will use the big list info
                int i = 0;
                [self.item[@"cost"] removeAllObjects];
                for(NSMutableDictionary* c in d[@"cost"])
                {
                    [self.item[@"cost"] insertObject:c atIndex:i];
                    i++;
                }
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
    if(textField == self.itemCostInputString)
    {
        NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
        NSArray *sep = [newString componentsSeparatedByString:@"."];
        if([sep count] < 2)
        {
            altered = true;
            return YES;
        }
        else if([sep count] ==2)
        {
            if([sep[1] length]<= 2)
            {
                altered = true;
                return YES;
            }
            else
            {
                return NO;
            }
        }
        else
        {
            return NO;
        }
    }
    if(textField == self.itemQuantityInputString)
    {
        NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        
        NSArray *sep = [newString componentsSeparatedByString:@"."];
        if([sep count] <= 2)
        {
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
    //If the user is trying to return input, and we at least have a name for the item
    if([[segue identifier] isEqualToString:@"ReturnInput"] && ![self.itemNameInputString.text isEqualToString:@""])
    {
        //Create a number formater to get number from text
        NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        
        //Start reading in user input
        self.item[@"name"] = self.itemNameInputString.text;
        
        
        if ([ f numberFromString:self.itemCostInputString.text] != nil)
        {
            //if the user gave a valid string for price
            self.item[@"price"] = [ f numberFromString:self.itemCostInputString.text];
        }
        
        if([ f numberFromString:self.itemQuantityInputString.text] != nil)
        {
            //if the user gave a valid string quantity
            self.item[@"quantity"] = [ f numberFromString:self.itemQuantityInputString.text];
        }
        else if([ f numberFromString:self.itemCostInputString.text] != nil)
        {
            //if the user didn't give us a valid string, but there is a cost
            //we assume they selected 1 item
            self.item[@"quantity"] = [NSNumber numberWithInt:1];
        }
        
        
        self.item[@"taxed"] = [ NSNumber numberWithBool:[self.itemTaxedInputSwitch isOn]];
        
        if(altered && [ f numberFromString:self.itemCostInputString.text] != nil)
        {
            //if the cost has been changed
            //Create a temp entry for date and cost
            NSMutableDictionary *tempCostDate = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[ f numberFromString:self.itemCostInputString.text], @"cost", [NSDate date], @"date", nil];
            
            //Add entry to cost list
            [self.item[@"cost"] insertObject:tempCostDate atIndex:0];
        }
        
        //Now we attempt to locate the object in the library
        NSMutableDictionary *itemFromList;
        for(NSMutableDictionary *d in self.allItems)
        {
            if([[d objectForKey:@"name"] caseInsensitiveCompare:self.itemNameInputString.text] == 0 )
            {
                //They have the same name and are thus the same item
                itemFromList = d;
                break;
            }
        }
        
        
        if (itemFromList == nil)
        {
            //we didn't find the item
            //Find where our item belongs in the big list
            int i = 0;
            while(i < [self.allItems count] && [[[self.allItems objectAtIndex:i] objectForKey:@"name"] caseInsensitiveCompare:self.itemNameInputString.text]<0)
            {
                i++;
            }
            
            //Create an entry for our big list
            NSMutableArray *tempList = [[NSMutableArray alloc]init];
            for(NSMutableDictionary *d in [self.item objectForKey:@"cost"])
            {
                [tempList insertObject:d atIndex:[tempList count]];
            }
            NSMutableDictionary* bigListItem = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[self.item objectForKey:@"name"], @"name", tempList, @"cost", [NSNumber numberWithBool:NO], @"Selected", nil];
            [self.allItems insertObject:bigListItem atIndex:i];
            
            
        }
        else
        {
            //we found the item
            //Clean out everything that was in it
            [[itemFromList objectForKey:@"cost"] removeAllObjects];
            
            //replace it with what we now have
            for( NSMutableDictionary *d in [self.item objectForKey:@"cost"])
            {
                [[itemFromList objectForKey:@"cost"] insertObject:d atIndex:[[itemFromList objectForKey:@"cost"] count]];
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
        return 0;
        //return [self.item[@"cost"] count];
    } else {
        return [super tableView:tableView numberOfRowsInSection:section];
    }
}

-(UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    
    if (indexPath.section == DYNAMICSECTION) {
        NSMutableDictionary *costDate = [[self.item objectForKey:@"cost"] objectAtIndex:indexPath.row];
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OldPriceCell"];
        
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"OldPriceCell"];
        }
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterLongStyle];
        cell.textLabel.text = [dateFormatter stringFromDate:[costDate objectForKey:@"date"]];
        cell.textLabel.font = [UIFont systemFontOfSize:17];
        
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        cell.detailTextLabel.text = [formatter stringFromNumber:[costDate objectForKey:@"cost"]];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
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
/*
//Based on
//http://stackoverflow.com/questions/949416/how-to-compare-two-dates-in-objective-c
//http://stackoverflow.com/questions/3694867/nsdate-get-year-month-day
- (BOOL) sameDate:(NSDate*)date1 asDate:(NSDate*)date2
{
    NSDateComponents* comp1 = [[NSCalendar currentCalendar] components:NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit fromDate:date1];
    NSDateComponents* comp2 = [[NSCalendar currentCalendar] components:NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit fromDate:date2];
 
    return [comp1 day] == [comp2 day] && [comp1 month] == [comp2 month] && [comp1 year] == [comp2 year];
}
*/
@end
