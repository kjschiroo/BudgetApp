//
//  OnBudgetMasterViewController.m
//  OnBudget
//
//  Created by KEVIN SCHIROO on 3/21/13.
//  Copyright (c) 2013 KEVIN SCHIROO. All rights reserved.
//

#import "OnBudgetMasterViewController.h"
#import "AddCartViewController.h"
#import "OnBudgetCartViewController.h"

@interface OnBudgetMasterViewController (){
    NSMutableArray *_carts;
    NSMutableArray *_items;
}
@end

@implementation OnBudgetMasterViewController

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

    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    UIApplication *app = [UIApplication sharedApplication];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:app];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:@"carts.plist"];
    
    
    
    if([fileManager fileExistsAtPath:plistPath] == YES)
    {
        _carts = [NSKeyedUnarchiver unarchiveObjectWithFile:plistPath];
    }
    if(!_carts)
    {
        _carts = [[NSMutableArray alloc] init];
    }
    
    
    plistPath = [documentsDirectory stringByAppendingPathComponent:@"items.plist"];
    
    
    if([fileManager fileExistsAtPath:plistPath] == YES)
    {
        _items = [NSKeyedUnarchiver unarchiveObjectWithFile:plistPath];
    }
    if(!_items)
    {
        _items = [[NSMutableArray alloc] init];
    }
    [self.tableView reloadData];
     
     
     
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [_carts removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [_carts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"budgetCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.textLabel.text = _carts[indexPath.row][@"name"];
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    cell.detailTextLabel.text = [formatter stringFromNumber:_carts[indexPath.row][@"budget"]];
    
    return cell;
}

- (void)insertNewItem:(NSMutableDictionary *)item
{
    if(!_carts)
    {
        _carts = [[NSMutableArray alloc] init];
    }
    for (NSMutableDictionary * pItem in _carts) {
        if([[pItem objectForKey:@"name"] isEqualToString:[item objectForKey:@"name"]])
        {
            return;
        }
    }
    [_carts insertObject:item atIndex:[_carts count]];
    //NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[_objects count]-1 inSection:0];
    [self.tableView reloadData];
    //[self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void) viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"EditCart"])
    {
        OnBudgetCartViewController *editCart = [segue destinationViewController];
        NSMutableDictionary *cart = _carts[[self.tableView indexPathForSelectedRow].row];
        editCart.cart = cart;
        editCart.allItems = _items;
        
        
    }
}

- (IBAction)done:(UIStoryboardSegue *)segue
{
    NSLog(@"Some stuff is done");
    if([[segue identifier] isEqualToString:@"ReturnCart"])
    {
        AddCartViewController *addController = [segue sourceViewController];
        if(addController.cart[@"name"] != nil)
        {
            [self insertNewItem:addController.cart];
        }
        [self.tableView reloadData];
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
    if([[segue identifier] isEqualToString:@"ReturnEditCart"])
    {
        [self.tableView reloadData];
    }
}

- (IBAction)cancel:(UIStoryboardSegue *)segue
{
    if([[segue identifier] isEqualToString:@"CancelInput"])
    {
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
}


// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    NSMutableDictionary *temp = _carts[fromIndexPath.row];
    [ _carts removeObjectAtIndex:fromIndexPath.row];
    [ _carts insertObject:temp atIndex:toIndexPath.row];
}



// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

- (void)applicationDidEnterBackground:(NSNotification *)notification {
    NSLog(@"Entering Background");
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:@"carts.plist"];
    
    [NSKeyedArchiver archiveRootObject:_carts toFile:plistPath];
    
    plistPath = [documentsDirectory stringByAppendingPathComponent:@"items.plist"];
    
    [NSKeyedArchiver archiveRootObject:_items toFile:plistPath];
    
    //[[NSDictionary dictionaryWithObjectsAndKeys: _objects,@"task", nil] writeToFile:plistPath atomically:YES];
}

@end
