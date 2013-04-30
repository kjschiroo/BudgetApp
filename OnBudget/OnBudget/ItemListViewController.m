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
    
    //get the object
    NSMutableDictionary *object = self.allItems[indexPath.row];
    
    NSNumber *isSelected = [object objectForKey:@"Selected"];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Is the item currently selected?
    NSNumber *isSelected = [self.allItems[indexPath.row] objectForKey:@"Selected"];
    if([isSelected boolValue])
    {
        //If yes, unselect it
        [self.allItems[indexPath.row] setValue:[NSNumber numberWithBool:NO] forKey:@"Selected"];
    }
    else
    {
        //If no, select it
        [self.allItems[indexPath.row] setValue:[NSNumber numberWithBool:YES] forKey:@"Selected"];
    }
    //Reload the cell to reflect this change
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"ReturnList"])
    {
        NSNumber *selectedItem;
        NSString *itemName;
        NSMutableArray *costs;
        
        //go through all the items
        for( NSMutableDictionary *d in self.allItems)
        {
            selectedItem = [d objectForKey:@"Selected"];
            if([selectedItem boolValue] == YES)
            {
                //copy any selected item over to our selected list
                itemName = [d objectForKey:@"name"];
                costs = [[NSMutableArray alloc] init];
                int i = 0;
                for(NSMutableDictionary *c in [d objectForKey:@"cost"])
                {
                    [costs insertObject:[NSMutableDictionary dictionaryWithDictionary:c] atIndex:i];
                    i++;
                }
                [self.selectedList insertObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:itemName, @"name",costs, @"cost", nil] atIndex:[self.selectedList count]];
                
                //unselect the item
                [d setValue:[NSNumber numberWithBool:NO] forKey:@"Selected"];
            }
        }
        
        
    }
    else
    {
        //Clear all selections
        for( NSMutableDictionary *d in self.allItems)
        {
            if([[d objectForKey:@"Selected"] boolValue] == YES)
            {
                [d setValue:[NSNumber numberWithBool:NO] forKey:@"Selected"];
            }
        }
    }
}


@end
