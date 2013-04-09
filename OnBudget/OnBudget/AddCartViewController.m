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
    
    //location = [[CLLocationManager alloc] init];
    //location.distanceFilter = kCLDistanceFilterNone;
    //location.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    
    //[location startUpdatingLocation];

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
    if([[segue identifier] isEqualToString:@"ReturnCart"])
    {
        if(![self.nameInput.text isEqualToString:@""])
        {
            NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
            [f setNumberStyle:NSNumberFormatterDecimalStyle];
            self.cart[@"name"] = self.nameInput.text;
            
            if([ f numberFromString:self.budgetInput.text] != nil)
            {
                self.cart[@"budget"] = [ f numberFromString:self.budgetInput.text];
            }
            self.cart[@"tax"] = [NSNumber numberWithDouble:0.065];
            self.cart[@"objects"] = [[NSMutableArray alloc] init];
        }
        
    }
}

/*
-(double) taxRateFromLocation
{

    NSString *state;
    CLGeocoder *rGeocoder = [[CLGeocoder alloc] init];
    CLGeocoder *geocoder = [[[CLGeocoder alloc] init] autorelease];
    
    CLLocationCoordinate2D coord = (_selectedRow == 0) ? kSanFranciscoCoordinate : _currentUserCoordinate;
    CLLocation *location = [[[CLLocation alloc] initWithLatitude:coord.latitude longitude:coord.longitude] autorelease];
    if(rGeocoder)
    {
        [rGeocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
            NSLog(@"reverseGeocodeLocation:completionHandler: Completion Handler called!");
            if (error){
                NSLog(@"Geocode failed with error: %@", error);
                return;
            }
            NSLog(@"Received placemarks: %@", placemarks);
            //[self displayPlacemarks:placemarks];
        }];
    }
    return 0;
}
 */

@end
