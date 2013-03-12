//
//  AddItemViewController.m
//  OnBudget
//
//  Created by KEVIN SCHIROO on 2/13/13.
//  Copyright (c) 2013 KEVIN SCHIROO. All rights reserved.
//

#import "AddItemViewController.h"

@interface AddItemViewController ()
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
    if(self.item == nil)
    {
        self.item = [[NSMutableDictionary alloc] init];
    }
    /*
    if(self.itemNameInput != nil && self.itemCostInput != nil && self.itemQuantityInput != nil && self.itemTaxedInput != nil)
    {
        self.itemNameInputString.text = self.itemNameInput;
        self.itemCostInputString.text = [NSString stringWithFormat:@"%.02f", self.itemCostInput.floatValue];
        self.itemQuantityInputString.text = [NSString stringWithFormat:@"%.02f", self.itemQuantityInput.floatValue];
        self.itemTaxedInputSwitch.on = [self.itemTaxedInput boolValue];
    }
     */
    if(self.item[@"name"] != nil)
    {
        self.itemNameInputString.text = self.item[@"name"];
    }
    if(self.item[@"cost"] != nil)
    {
        self.itemCostInputString.text = [NSString stringWithFormat:@"%@", (NSNumber *)self.item[@"cost"]];
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
            if([ f numberFromString:self.itemCostInputString.text] != nil)
            {
                self.item[@"cost"] = [ f numberFromString:self.itemCostInputString.text];
            }
            self.item[@"taxed"] = [ NSNumber numberWithBool:[self.itemTaxedInputSwitch isOn]];
        }
        
    }
}

#pragma mark - Table view data source
/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate
/*
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     
}
 */


@end
