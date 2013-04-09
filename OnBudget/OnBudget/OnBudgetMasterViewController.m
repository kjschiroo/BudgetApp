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
    NSMutableArray *_objects;
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
        _objects = [NSKeyedUnarchiver unarchiveObjectWithFile:plistPath];
        [self.tableView reloadData];
    }
     
    
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
        
        [_objects removeObjectAtIndex:indexPath.row];
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
    return [_objects count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"budgetCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.textLabel.text = _objects[indexPath.row][@"name"];
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    cell.detailTextLabel.text = [formatter stringFromNumber:_objects[indexPath.row][@"budget"]];
    
    return cell;
}

- (void)insertNewItem:(NSMutableDictionary *)item
{
    if(!_objects)
    {
        _objects = [[NSMutableArray alloc] init];
    }
    for (NSMutableDictionary * pItem in _objects) {
        if([[pItem objectForKey:@"name"] isEqualToString:[item objectForKey:@"name"]])
        {
            return;
        }
    }
    [_objects insertObject:item atIndex:[_objects count]];
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
        NSMutableDictionary *cart = _objects[[self.tableView indexPathForSelectedRow].row];
        editCart.cart = cart;
        
        
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
    NSMutableDictionary *temp = _objects[fromIndexPath.row];
    [ _objects removeObjectAtIndex:fromIndexPath.row];
    [ _objects insertObject:temp atIndex:toIndexPath.row];
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
    
    [NSKeyedArchiver archiveRootObject:_objects toFile:plistPath];
    
    //[[NSDictionary dictionaryWithObjectsAndKeys: _objects,@"task", nil] writeToFile:plistPath atomically:YES];
}

@end
