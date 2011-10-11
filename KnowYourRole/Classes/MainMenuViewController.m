//
//  MainMenuViewController.m
//
//  Created by Rob Little on 11-05-17.
//  Copyright 2011 littlelogic.ca All rights reserved.
//

#import "MainMenuViewController.h"
#import "RoleViewController.h"
#import "SetupViewController.h"

@implementation MainMenuViewController

@synthesize assignRolesButton;
@synthesize fetchRequest;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    // set up single delegate and context for core data access
    appDelegate = (TestAppDelegate *)[[UIApplication sharedApplication] delegate];
    context = appDelegate.managedObjectContext;
    
    // block access to role assign function unless setup is complete
    if([self isSetupComplete] == YES)
    {
        [assignRolesButton setEnabled:YES];
        [assignRolesButton setTitle:@"Assign Roles" forState:UIControlStateNormal];
    }
    else
    {
        [assignRolesButton setEnabled:NO];
        [assignRolesButton setTitle:@"Setup First" forState:UIControlStateNormal];
    }
    
	self.title =@"Main Menu";
}

- (void)viewWillAppear:(BOOL)animated {
    [self viewDidLoad];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc {
    [super dealloc];
    [assignRolesButton release];
    [fetchRequest release];
}

#pragma mark -
#pragma mark IBActions
-(IBAction)loadScreenOne:(id)sender
{
	SetupViewController *setupViewController = [[SetupViewController alloc] initWithNibName:@"SetupViewController" bundle:nil];
	// Pass the selected object to the new view controller.
	setupViewController.title = @"Setup";
	[self.navigationController pushViewController:setupViewController animated:YES];
	
	[setupViewController release];  
}


-(IBAction)loadScreenTwo:(id)sender
{
	RoleViewController *roleViewController = [[RoleViewController alloc] initWithNibName:@"RoleViewController" bundle:nil];
	// Pass the selected object to the new view controller.
	roleViewController.title = @"Available Roles";
	[self.navigationController pushViewController:roleViewController animated:YES];
	
	[roleViewController release];
}

- (BOOL)isSetupComplete
{
    //obtain counts of people/roles set up, return false only if both lists empty
    fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *roleDesc = [NSEntityDescription 
                                     entityForName:@"Role" inManagedObjectContext:context];
    [fetchRequest setEntity:roleDesc];
    NSMutableArray *fetchedObjects = [[context executeFetchRequest:fetchRequest error:&error] mutableCopy];
    
    Boolean rolesFound = true;
    if([fetchedObjects count] == 0)
    {
        //return early, no need to set boolean, only double true returns true
        return NO;
    }
    
    fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *personDesc = [NSEntityDescription 
                                     entityForName:@"Person" inManagedObjectContext:context];
    [fetchRequest setEntity:personDesc];
    NSMutableArray *fetchedObjects2 = [[context executeFetchRequest:fetchRequest error:&error] mutableCopy];
    
    Boolean personsFound = true;
    if([fetchedObjects2 count] == 0)
    {
        //return early, no need to set boolean, only double true returns true
        return NO;
    }
    
    if(personsFound && rolesFound)
    {
        return YES;
    }
    return NO;
}

@end
