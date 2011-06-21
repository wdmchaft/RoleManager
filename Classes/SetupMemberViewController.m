//
//  SetupMemberViewController.m
//  Test
//
//  Created by Robert Little on 11-06-14.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SetupMemberViewController.h"
#import "Person.h"
#import "TestAppDelegate.h"
#import "MemberAddViewController.h"

@implementation SetupMemberViewController

@synthesize button;
@synthesize peopleArray;
@synthesize fetchRequest;

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
    TestAppDelegate *appDelegate = (TestAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = appDelegate.managedObjectContext;
    
    // handle delete event
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        // Delete the managed object at the given index path.
        NSManagedObject *eventToDelete = [peopleArray objectAtIndex:indexPath.row];
        [context deleteObject:eventToDelete];
        
        // Update the array and table view.
        [peopleArray removeObjectAtIndex:indexPath.row];
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
    self.title = @"Member Setup";
    
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
    peopleArray = [self fetchAllPeople];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView 
 numberOfRowsInSection:(NSInteger)section {
    return [peopleArray count];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.button = nil;
    self.peopleArray = nil;
    self.fetchRequest = nil;
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
    Person *info = [peopleArray objectAtIndex:indexPath.row];
    cell.textLabel.text = info.firstname;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@, %@", 
                                 info.firstname, info.lastname];
    
    return cell;
}

- (void)dealloc 
{
    [peopleArray release];
    [button release];
    [fetchRequest release];
    [super dealloc];
}

- (void)addEvent 
{
    MemberAddViewController *addController = [[MemberAddViewController alloc]
                                              initWithNibName:@"MemberAddViewController" bundle:nil];
    // register delegate; so control can be returned after child controllers save event
    addController.delegate = self;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:addController];
    [self presentModalViewController:navigationController animated:YES];
    [navigationController release];
}
      
#pragma mark - Data Access addPerson
- (void)addPerson:(NSDictionary *)userInfo
{
    TestAppDelegate *appDelegate = (TestAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *context = appDelegate.managedObjectContext;
    NSManagedObject *person = (Person *)[NSEntityDescription
                                         insertNewObjectForEntityForName:@"Person" 
                                         inManagedObjectContext:context];
    // set values
    [person setValue:[userInfo valueForKey:@"firstName"] forKey:@"firstname"];
    [person setValue:[userInfo valueForKey:@"lastName"] forKey:@"lastname"];
    
    // save data
    if (![context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
    
    // update table view with data
    [peopleArray insertObject:person atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                          withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

#pragma mark - Data Access fetchAllPeople
- (NSMutableArray *)fetchAllPeople
{
    TestAppDelegate *appDelegate = (TestAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *context = appDelegate.managedObjectContext;
    
    fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *personDesc = [NSEntityDescription 
                                       entityForName:@"Person" inManagedObjectContext:context];
    [fetchRequest setEntity:personDesc];
    NSMutableArray *fetchedObjects = [[context executeFetchRequest:fetchRequest error:&error] mutableCopy];
    
    return fetchedObjects;
}

#pragma mark - MemberAddViewControllerDelegate
- (void)addMemberViewController:(MemberAddViewController *)controller didFinish:(NSDictionary *)userInfo
{
    [self addPerson:userInfo];
    [self dismissModalViewControllerAnimated:YES];
}

@end
