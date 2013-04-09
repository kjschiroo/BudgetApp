//
//  OnBudgetMasterViewController.m
//  OnBudget
//
//  Created by KEVIN SCHIROO on 2/13/13.
//  Copyright (c) 2013 KEVIN SCHIROO. All rights reserved.
//

#import "OnBudgetCartViewController.h"

#import "OnBudgetDetailViewController.h"

#import "AddItemViewController.h"

#import "EditBudgetViewController.h"

#import "ItemListViewController.h"

@interface OnBudgetCartViewController () {
    
    bool displayTotal;
    __weak IBOutlet UIBarButtonItem *itemLibraryButton;
    __weak IBOutlet UINavigationItem *topBar;
    
}
@end

@implementation OnBudgetCartViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    //self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    displayTotal = NO;
    self.navigationItem.rightBarButtonItems = @[self.navigationItem.rightBarButtonItem, itemLibraryButton];
    topBar.title = _cart[@"name"];
    
    /*
    _budget =[[NSNumber alloc] initWithFloat:0.00];
    _taxRate = [[NSNumber alloc] initWithFloat:0.065];
    
    UIApplication *app = [UIApplication sharedApplication];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:app];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:@"items.plist"];
    
    
    if([fileManager fileExistsAtPath:plistPath] == YES)
    {
        NSMutableArray *storageBox = [NSKeyedUnarchiver unarchiveObjectWithFile:plistPath];
        _objects = [storageBox objectAtIndex:0];
        _budget = [storageBox objectAtIndex:1];
        [self.tableView reloadData];
    }
     */
    
}

- (IBAction)goToList:(id)sender
{
    NSLog(@"goToList");
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
        _cart[@"budget"] = budgetController.budget;
        [self.tableView reloadData];
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
    else if ([[segue identifier] isEqualToString:@"ReturnList"])
    {
        ItemListViewController *listController = [segue sourceViewController];
        for(NSMutableDictionary *d in listController.selectedList)
        {
            [self insertNewItem:d];
        }
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
    if(!_cart[@"objects"])
    {
        _cart[@"objects"] = [[NSMutableArray alloc] init];
    }
    for (NSMutableDictionary * pItem in _cart[@"objects"]) {
        if([[pItem objectForKey:@"name"] isEqualToString:[item objectForKey:@"name"]])
        {
            return;
        }
    }
    [_cart[@"objects"] insertObject:item atIndex:[_cart[@"objects"] count]];
    //NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[_objects count]-1 inSection:0];
    [self.tableView reloadData];
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
        for (NSMutableDictionary *item in _cart[@"objects"]) {
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
            if(total != 0)
            {
                cell.textLabel.text = @"Balance";
            }
            else
            {
                cell.textLabel.text = @"Budget";
            }
            cell.detailTextLabel.text = [formatter stringFromNumber:[NSNumber numberWithDouble:([_cart[@"budget"] doubleValue] -total)]];
            if(total > [_cart[@"budget"] doubleValue])
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
        NSMutableDictionary *item = _cart[@"objects"][indexPath.row];
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
            [_cart[@"objects"] removeObjectAtIndex:[self objectIndexForPath:indexPath]];
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
            [_cart[@"objects"] removeObjectAtIndex:[self objectIndexForPath:indexPath]];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
        NSIndexPath *totalPath = [NSIndexPath indexPathForRow:[self rowForTotal] inSection:0];
        [tableView reloadRowsAtIndexPaths:@[totalPath] withRowAnimation:UITableViewRowAnimationFade];
        
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}


// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}



// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    if(indexPath.row == [self rowForTotal]|| indexPath.row == [self rowForTax])
    {
        return NO;
    }
    else
    {
        return YES;
    }
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"I'm preparing for segue");
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDate *object = _cart[@"objects"][indexPath.row];
        [[segue destinationViewController] setDetailItem:object];
    }
    else if([[segue identifier] isEqualToString:@"SetBudget"])
    {
        EditBudgetViewController *editBudget = [segue destinationViewController];
        editBudget.budget =_cart[@"budget"];
    }
    else if([[segue identifier] isEqualToString:@"EditItem"])
    {
        AddItemViewController *editItem = [segue destinationViewController];
        NSMutableDictionary *item = _cart[@"objects"][[self.tableView indexPathForSelectedRow].row];
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
        return [_cart[@"objects"] count];
    }
    else
    {
        return [_cart[@"objects"] count] +  1;
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
    for (NSMutableDictionary *item in _cart[@"objects"]) {
        taxed = [[item objectForKey:@"taxed"] boolValue];
        if(taxed)
        {
            cost = [[item objectForKey:@"cost"] doubleValue];
            quantity = [[item objectForKey:@"quantity"] doubleValue];
            total += cost*quantity*[_cart[@"tax"] doubleValue];
        }
    }
    return total;
}

/*
- (void)applicationDidEnterBackground:(NSNotification *)notification {
    NSLog(@"Entering Background");
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:@"items.plist"];
    NSMutableArray *storageBox = [[NSMutableArray alloc] initWithObjects:_objects,_budget, nil];
    
    [NSKeyedArchiver archiveRootObject:storageBox toFile:plistPath];
    
    //[[NSDictionary dictionaryWithObjectsAndKeys: _objects,@"task", nil] writeToFile:plistPath atomically:YES];
}
 */
@end
