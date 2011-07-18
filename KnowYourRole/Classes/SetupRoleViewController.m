//
//  SetupRoleViewController.m
//  Test
//
//  Created by Robert Little on 11-06-14.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SetupRoleViewController.h"
#import "Role.h"
#import "TestAppDelegate.h"
#import "RoleAddViewController.h"

@implementation SetupRoleViewController

@synthesize button;
@synthesize roleArray;
@synthesize fetchRequest;
@synthesize date;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


- (void)tableView:(UITableView *)aTableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // handle delete event
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        // Delete the managed object at the given index path.
        NSManagedObject *eventToDelete = [roleArray objectAtIndex:indexPath.row];
        [context deleteObject:eventToDelete];
        
        // Update the array and table view.
        [roleArray removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
        
        // Commit the change.
        if (![context save:&error]) {
            NSLog(@"Whoops, couldn't delete: %@", [error localizedDescription]);
        }
    }
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Role Setup";
    
    // set up single delegate and context for core data access
    appDelegate = (TestAppDelegate *)[[UIApplication sharedApplication] delegate];
    context = appDelegate.managedObjectContext;
    
    // Set up the buttons.
    // create a toolbar to have two buttons in the right
    UIToolbar* tools = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 96, 44.01)];
    
    // create the array to hold the buttons, which then gets added to the toolbar
    NSMutableArray* buttons = [[NSMutableArray alloc] initWithCapacity:3];
    
    // create a standard "add" button
    button = [[UIBarButtonItem alloc]
              initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addEvent)];
    button.style = UIBarButtonItemStyleBordered;
    [buttons addObject:button];
    [button release];
    
    // create a spacer
    button = [[UIBarButtonItem alloc]
              initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    [buttons addObject:button];
    [button release];
    
    // use the available "edit" button
    self.editButtonItem.title = @"Edit";
    UIBarButtonItem *editButton = self.editButtonItem;
    [buttons addObject:editButton];
    [editButton release];
    
    // stick the buttons in the toolbar
    [tools setItems:buttons animated:NO];
    
    [buttons release];
    
    // and put the toolbar in the nav bar on right hand side
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:tools];
    [tools release];

}

- (void)viewWillAppear:(BOOL)animated {
    roleArray = [self fetchAllRoles];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView 
 numberOfRowsInSection:(NSInteger)section {
    return [roleArray count];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.button = nil;
    self.roleArray = nil;
    self.fetchRequest = nil;
    [appDelegate release];
    [context release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (UITableViewCell *)tableView:(UITableView *)tableView 
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = 
    [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle 
                                       reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Set up the cell...
    Role *info = [roleArray objectAtIndex:indexPath.row];
    cell.textLabel.text = info.rolename;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@, %@", 
                                 info.rolename, info.info];
    
    return cell;
}

- (void)dealloc 
{
    [roleArray release];
    [button release];
    [fetchRequest release];
    [super dealloc];
    [date release];
}

- (void)addEvent 
{
    RoleAddViewController *addController = [[RoleAddViewController alloc]
                                              initWithNibName:@"RoleAddViewController" bundle:nil];
    // register delegate; so control can be returned after child controllers save event
    addController.delegate = self;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:addController];
    [self presentModalViewController:navigationController animated:YES];
    [navigationController release];
}

#pragma mark - Data Access
- (void)addRole:(NSDictionary *)userInfo
{
    NSManagedObject *role = (Role *)[NSEntityDescription
                                         insertNewObjectForEntityForName:@"Role" 
                                         inManagedObjectContext:context];
    // set values
    [role setValue:[userInfo valueForKey:@"roleName"] forKey:@"rolename"];
    [role setValue:[userInfo valueForKey:@"info"] forKey:@"info"];
    
    [role setValue:date forKey:@"date"];
    
    // save data
    if (![context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
    
    // update table view with data
    [roleArray insertObject:role atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                          withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (NSMutableArray *)fetchAllRoles
{
    fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *roleDesc = [NSEntityDescription 
                                       entityForName:@"Role" inManagedObjectContext:context];
    [fetchRequest setEntity:roleDesc];
    NSMutableArray *fetchedObjects = [[context executeFetchRequest:fetchRequest error:&error] mutableCopy];
    
    return fetchedObjects;
}

#pragma mark - RoleAddViewControllerDelegate
- (void)addRoleViewController:(RoleAddViewController *)controller didFinish:(NSDictionary *)userInfo
{
    if (userInfo == nil) 
    {
        [self dismissModalViewControllerAnimated:YES];
    }
    else
    {
        [self addRole:userInfo];
        [self dismissModalViewControllerAnimated:YES];

    }
}

@end
