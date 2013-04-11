//
//  ItemListViewController.m
//  OnBudget
//
//  Created by KEVIN SCHIROO on 3/12/13.
//  Copyright (c) 2013 KEVIN SCHIROO. All rights reserved.
//

#import "ItemListViewController.h"

@interface ItemListViewController ()
@end

@implementation ItemListViewController

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
    
    if(!self.selectedList)
    {
        self.selectedList = [[NSMutableArray alloc] init];
    }
    
    UIApplication *app = [UIApplication sharedApplication];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:app];
/*
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:@"itemLibrary.plist"];


    if([fileManager fileExistsAtPath:plistPath] == YES)
    {
        _objects = [NSKeyedUnarchiver unarchiveObjectWithFile:plistPath];
        [self.tableView reloadData];
    }
    else
    {
        
        //Items from list at
        //http://www.jacksonfoodpantry.com/foodnonfooditemlist.htm
        _objects = [[NSMutableArray alloc] init];
        
        [_objects insertObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"Vegetables", @"Item", [NSNumber numberWithBool:NO], @"Selected", nil] atIndex:0];
        [_objects insertObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"Tuna", @"Item", [NSNumber numberWithBool:NO], @"Selected", nil] atIndex:0];
        [_objects insertObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"Toothpaste", @"Item", [NSNumber numberWithBool:NO], @"Selected", nil] atIndex:0];
        [_objects insertObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"Toothbrushes", @"Item", [NSNumber numberWithBool:NO], @"Selected", nil] atIndex:0];
        [_objects insertObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"Tomatoes", @"Item", [NSNumber numberWithBool:NO], @"Selected", nil] atIndex:0];
        [_objects insertObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"Toilet Paper", @"Item", [NSNumber numberWithBool:NO], @"Selected", nil] atIndex:0];
        [_objects insertObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"Tea", @"Item", [NSNumber numberWithBool:NO], @"Selected", nil] atIndex:0];
        [_objects insertObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"Syrup", @"Item", [NSNumber numberWithBool:NO], @"Selected", nil] atIndex:0];
        [_objects insertObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"Stuffing Mix", @"Item", [NSNumber numberWithBool:NO], @"Selected", nil] atIndex:0];
        [_objects insertObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"Spam", @"Item", [NSNumber numberWithBool:NO], @"Selected", nil] atIndex:0];
        [_objects insertObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"Soups", @"Item", [NSNumber numberWithBool:NO], @"Selected", nil] atIndex:0];
        [_objects insertObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"Shampoo", @"Item", [NSNumber numberWithBool:NO], @"Selected", nil] atIndex:0];
        [_objects insertObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"Rice", @"Item", [NSNumber numberWithBool:NO], @"Selected", nil] atIndex:0];
        [_objects insertObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"Powered Milk", @"Item", [NSNumber numberWithBool:NO], @"Selected", nil] atIndex:0];
        [_objects insertObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"Pop Tarts", @"Item", [NSNumber numberWithBool:NO], @"Selected", nil] atIndex:0];
        [_objects insertObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"Peanut Butter", @"Item", [NSNumber numberWithBool:NO], @"Selected", nil] atIndex:0];
        [_objects insertObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"Pastas", @"Item", [NSNumber numberWithBool:NO], @"Selected", nil] atIndex:0];
        [_objects insertObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"Pasta Sauce", @"Item", [NSNumber numberWithBool:NO], @"Selected", nil] atIndex:0];
        [_objects insertObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"Paper Towels", @"Item", [NSNumber numberWithBool:NO], @"Selected", nil] atIndex:0];
        [_objects insertObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"Pancake Mix", @"Item", [NSNumber numberWithBool:NO], @"Selected", nil] atIndex:0];
        [_objects insertObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"Mustard", @"Item", [NSNumber numberWithBool:NO], @"Selected", nil] atIndex:0];
        [_objects insertObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"Mayonnaise", @"Item", [NSNumber numberWithBool:NO], @"Selected", nil] atIndex:0];
        [_objects insertObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"Mashed Potatoes", @"Item", [NSNumber numberWithBool:NO], @"Selected", nil] atIndex:0];
        [_objects insertObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"Macaroni & Cheese", @"Item", [NSNumber numberWithBool:NO], @"Selected", nil] atIndex:0];
        [_objects insertObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"Laundry Supplies", @"Item", [NSNumber numberWithBool:NO], @"Selected", nil] atIndex:0];
        [_objects insertObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"Ketchup", @"Item", [NSNumber numberWithBool:NO], @"Selected", nil] atIndex:0];
        [_objects insertObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"Juice Boxes", @"Item", [NSNumber numberWithBool:NO], @"Selected", nil] atIndex:0];
        [_objects insertObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"Jelly", @"Item", [NSNumber numberWithBool:NO], @"Selected", nil] atIndex:0];
        [_objects insertObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"Hot Chocolate", @"Item", [NSNumber numberWithBool:NO], @"Selected", nil] atIndex:0];
        [_objects insertObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"Hamburger Helper", @"Item", [NSNumber numberWithBool:NO], @"Selected", nil] atIndex:0];
        [_objects insertObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"Gravy", @"Item", [NSNumber numberWithBool:NO], @"Selected", nil] atIndex:0];
        [_objects insertObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"Fruits", @"Item", [NSNumber numberWithBool:NO], @"Selected", nil] atIndex:0];
        [_objects insertObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"Deodorant", @"Item", [NSNumber numberWithBool:NO], @"Selected", nil] atIndex:0];
        [_objects insertObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"Coffee", @"Item", [NSNumber numberWithBool:NO], @"Selected", nil] atIndex:0];
        [_objects insertObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"Cleaning supplies", @"Item", [NSNumber numberWithBool:NO], @"Selected", nil] atIndex:0];
        [_objects insertObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"Chili", @"Item", [NSNumber numberWithBool:NO], @"Selected", nil] atIndex:0];
        [_objects insertObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"Chicken", @"Item", [NSNumber numberWithBool:NO], @"Selected", nil] atIndex:0];
        [_objects insertObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"Cereal", @"Item", [NSNumber numberWithBool:NO], @"Selected", nil] atIndex:0];
        [_objects insertObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"Bottled Water", @"Item", [NSNumber numberWithBool:NO], @"Selected", nil] atIndex:0];
        [_objects insertObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"Beef Stew", @"Item", [NSNumber numberWithBool:NO], @"Selected", nil] atIndex:0];
        [_objects insertObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"Bath Soap", @"Item", [NSNumber numberWithBool:NO], @"Selected", nil] atIndex:0];
        [_objects insertObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"Baby Items", @"Item", [NSNumber numberWithBool:NO], @"Selected", nil] atIndex:0];
        [_objects insertObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"Applesauce", @"Item", [NSNumber numberWithBool:NO], @"Selected", nil] atIndex:0];
    }
 */
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    return [self.allItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ItemCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSMutableDictionary *object;
    NSNumber *isSelected = [self.allItems[indexPath.row] objectForKey:@"Selected"];
    object = self.allItems[indexPath.row];
    cell.textLabel.text = [object objectForKey: @"name"];
    if( [isSelected boolValue])
    {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }else
    {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    
    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [self.allItems removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSNumber *isSelected = [self.allItems[indexPath.row] objectForKey:@"Selected"];
    if([isSelected boolValue])
    {
        [self.allItems[indexPath.row] setValue:[NSNumber numberWithBool:NO] forKey:@"Selected"];
    }
    else
    {
        [self.allItems[indexPath.row] setValue:[NSNumber numberWithBool:YES] forKey:@"Selected"];
    }
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"ReturnList"])
    {
        NSNumber *selectedItem;
        NSString *itemName;
        NSMutableArray *costs;
        for( NSMutableDictionary *d in self.allItems)
        {
            selectedItem = [d objectForKey:@"Selected"];
            if([selectedItem boolValue] == YES)
            {
                itemName = [d objectForKey:@"name"];
                costs = [[NSMutableArray alloc] init];
                int i = 0;
                for(NSMutableDictionary *c in [d objectForKey:@"cost"])
                {
                    [costs insertObject:[NSMutableDictionary dictionaryWithDictionary:c] atIndex:i];
                    i++;
                }
                [self.selectedList insertObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:itemName, @"name",costs, @"cost", nil] atIndex:[self.selectedList count]];
                [d setValue:[NSNumber numberWithBool:NO] forKey:@"Selected"];
            }
        }
        
        /*
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:@"itemLibrary.plist"];
        
        [NSKeyedArchiver archiveRootObject:self.allItems toFile:plistPath];
         */
        
    }
}

- (void)applicationDidEnterBackground:(NSNotification *)notification {
    
    NSLog(@"Entering Background in list");
    
}

@end
