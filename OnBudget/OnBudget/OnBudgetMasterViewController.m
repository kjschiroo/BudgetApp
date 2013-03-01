//
//  OnBudgetMasterViewController.m
//  OnBudget
//
//  Created by KEVIN SCHIROO on 2/13/13.
//  Copyright (c) 2013 KEVIN SCHIROO. All rights reserved.
//

#import "OnBudgetMasterViewController.h"

#import "OnBudgetDetailViewController.h"

#import "AddItemViewController.h"

#import "EditBudgetViewController.h"

@interface OnBudgetMasterViewController () {
    NSMutableArray *_objects;
    bool displayTotal;
    NSNumber *_budget;
    NSNumber *_taxRate;
    
}
@end

@implementation OnBudgetMasterViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    _budget =[[NSNumber alloc] initWithFloat:0.00];
    _taxRate = [[NSNumber alloc] initWithFloat:0.065];
    displayTotal = NO;
    
    /*
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
     */
    
    UIApplication *app = [UIApplication sharedApplication];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:app];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:@"data.plist"];
    
    
    if([fileManager fileExistsAtPath:plistPath] == YES)
    {
        //Uses much of the same as D.C.'s example, but different final bit
        //http://www.scratchmytail.com/2009/11/06/storing-custom-objects-to-disk-on-the-iphone/
        NSMutableArray *storageBox = [[NSMutableArray alloc] init];
        storageBox = [NSKeyedUnarchiver unarchiveObjectWithFile:plistPath];
        _objects = (NSMutableArray *)storageBox[0];
        _budget = (NSNumber *)storageBox[1];
        [self.tableView reloadData];
    }
    
}

- (IBAction)done:(UIStoryboardSegue *)segue
{
    if([[segue identifier] isEqualToString:@"ReturnInput"])
    {
        AddItemViewController *addController = [segue sourceViewController];
        if(addController.item[@"name"] != nil && ![addController.isEdit boolValue])
        {
            [self insertNewItem:addController.item];
        }
        [self.tableView reloadData];
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
    else if ([[segue identifier] isEqualToString:@"ReturnBudget"])
    {
        EditBudgetViewController *budgetController = [segue sourceViewController];
        _budget = budgetController.budget;
        [self.tableView reloadData];
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
}

- (IBAction)cancel:(UIStoryboardSegue *)segue
{
    if([[segue identifier] isEqualToString:@"CancelInput"])
    {
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewItem:(NSMutableDictionary *)item
{
    if(!_objects)
    {
        _objects = [[NSMutableArray alloc] init];
    }
    [_objects insertObject:item atIndex:[_objects count]];
    //NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[_objects count]-1 inSection:0];
    //[self.tableView reloadData];
    //[self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Table View


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self rowForTotal]+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    NSNumber *cost;
    NSNumber *quantity;
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    /*if(indexPath.row == 0)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"BudgetCell" forIndexPath:indexPath];
        cell.textLabel.text = @"Budget";
        cell.detailTextLabel.text = [formatter stringFromNumber:_budget];
        //cell.detailTextLabel.text = [NSString stringWithFormat:@"%.02f", _budget.floatValue];
    }
    else*/
    if(indexPath.row == [self rowForTotal])
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"TotalCell" forIndexPath:indexPath];
        double total = 0;
        for (NSMutableDictionary *item in _objects) {
            cost = [item objectForKey:@"cost"];
            quantity = [item objectForKey:@"quantity"];
            total += [cost doubleValue]*[quantity doubleValue];
        }
        total += [self getTax];
       
        
        if(displayTotal)
        {
            cell.textLabel.text = @"Total";
            cell.detailTextLabel.text = [formatter stringFromNumber:[NSNumber numberWithDouble:total]];
            cell.detailTextLabel.textColor = [UIColor blackColor];
            
            //cell.detailTextLabel.text = [NSString stringWithFormat:@"%.02f", total];
        }
        else
        {
            cell.textLabel.text = @"Balance";
            cell.detailTextLabel.text = [formatter stringFromNumber:[NSNumber numberWithDouble:([_budget doubleValue] -total)]];
            if(total > [_budget doubleValue])
            {
                cell.detailTextLabel.textColor = [UIColor redColor];
            }
            else
            {
                cell.detailTextLabel.textColor = [UIColor blackColor];
            }
            //cell.detailTextLabel.text = [NSString stringWithFormat:@"%.02f", _budget.floatValue - total];
        }
        

    }
    else if(indexPath.row == [self rowForTax])
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"TaxCell" forIndexPath:indexPath];
        cell.textLabel.text = @"Tax";
        cell.detailTextLabel.text = [formatter stringFromNumber:[NSNumber numberWithDouble:[self getTax]]];
        //cell.detailTextLabel.text = [NSString stringWithFormat:@"%.02f",[self getTax] ];
    }
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"ItemCell" forIndexPath:indexPath];
        NSMutableDictionary *item = _objects[indexPath.row];
        cost = [item objectForKey:@"cost"];
        quantity = [item objectForKey:@"quantity"];
        cell.textLabel.text = [item objectForKey:@"name"];
        if (quantity != 0 && cost != 0) {
            cell.detailTextLabel.text = [formatter stringFromNumber:[NSNumber numberWithDouble:([cost doubleValue]*[quantity doubleValue])]];
            //cell.detailTextLabel.text = [NSString stringWithFormat:@"%.02f",[cost doubleValue]*[quantity doubleValue] ];
        }
        else
        {
            cell.detailTextLabel.text = @"";
        }
    }
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    if(indexPath.row == [self rowForTotal]|| indexPath.row == [self rowForTax])
    {
        return NO;
    }
    else
    {
        return YES;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if([self getTax] !=0)
        {
            NSIndexPath *taxPath = [NSIndexPath indexPathForRow:[self rowForTax] inSection:0];
            [_objects removeObjectAtIndex:[self objectIndexForPath:indexPath]];
            if([self getTax] == 0)
            {
                [tableView deleteRowsAtIndexPaths:@[indexPath, taxPath] withRowAnimation:UITableViewRowAnimationFade];
            }
            else
            {
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                taxPath = [NSIndexPath indexPathForRow:[self rowForTax] inSection:0];
                [tableView reloadRowsAtIndexPaths:@[taxPath] withRowAnimation:UITableViewRowAnimationFade];
            }
        }
        else
        {
            [_objects removeObjectAtIndex:[self objectIndexForPath:indexPath]];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
        NSIndexPath *totalPath = [NSIndexPath indexPathForRow:[self rowForTotal] inSection:0];
        [tableView reloadRowsAtIndexPaths:@[totalPath] withRowAnimation:UITableViewRowAnimationFade];
        
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDate *object = _objects[indexPath.row];
        [[segue destinationViewController] setDetailItem:object];
    }
    else if([[segue identifier] isEqualToString:@"SetBudget"])
    {
        EditBudgetViewController *editBudget = [segue destinationViewController];
        editBudget.budget = _budget;
    }
    else if([[segue identifier] isEqualToString:@"EditItem"])
    {
        AddItemViewController *editItem = [segue destinationViewController];
        NSMutableDictionary *item = _objects[[self.tableView indexPathForSelectedRow].row];
        editItem.item = item;
        editItem.isEdit = [NSNumber numberWithBool:true];
        /*
        editItem.itemNameInput = [item objectForKey:@"name"];
        editItem.itemCostInput = [item objectForKey:@"cost"];
        editItem.itemQuantityInput = [item objectForKey:@"quantity"];
        editItem.itemTaxedInput = [item objectForKey:@"taxed"];
        editItem.rowIfEdit = [NSNumber numberWithInteger:[self.tableView indexPathForSelectedRow].row];
         */
        
    }
}

- (int)rowForTax
{
    if([self getTax] == 0)
    {
        return -1;
    }
    else
    {
        return [self rowForTotal] - 1;
    }
}

- (int)rowForTotal
{
    if([self getTax] == 0)
    {
        return [_objects count];
    }
    else
    {
        return [_objects count] +  1;
    }
    
}

- (int)objectIndexForPath:(NSIndexPath *)myPath
{
    return myPath.row;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == [self rowForTotal])
    {
        displayTotal = !displayTotal;
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (double)getTax
{
    double total = 0;
    double cost;
    double quantity;
    bool taxed;
    for (NSMutableDictionary *item in _objects) {
        taxed = [[item objectForKey:@"taxed"] boolValue];
        if(taxed)
        {
            cost = [[item objectForKey:@"cost"] doubleValue];
            quantity = [[item objectForKey:@"quantity"] doubleValue];
            total += cost*quantity*[_taxRate doubleValue];
        }
    }
    return total;
}

- (void)applicationDidEnterBackground:(NSNotification *)notification {
    NSLog(@"Entering Background");
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:@"data.plist"];
    NSMutableArray *storageBox = [[NSMutableArray alloc] initWithObjects:_objects,_budget, nil];
    
    [NSKeyedArchiver archiveRootObject:storageBox toFile:plistPath];
    
    //[[NSDictionary dictionaryWithObjectsAndKeys: _objects,@"task", nil] writeToFile:plistPath atomically:YES];
}
@end
