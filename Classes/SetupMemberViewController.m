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

@implementation SetupMemberViewController

@synthesize addButton;
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

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Member Setup";
    
    // Set up the buttons.  /TODO COMMENT EDIT BACK IN AND DO REVERSE NAV SOMEHOW
    // create a toolbar to have two buttons in the right
    UIToolbar* tools = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 94, 44.01)];
    
    // create the array to hold the buttons, which then gets added to the toolbar
    NSMutableArray* buttons = [[NSMutableArray alloc] initWithCapacity:3];
    
    // create a standard "add" button
    addButton = [[UIBarButtonItem alloc]
                           initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addEvent)];
    addButton.style = UIBarButtonItemStyleBordered;
    [buttons addObject:addButton];
    [addButton release];
    
    // create a spacer
    addButton = [[UIBarButtonItem alloc]
          initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    [buttons addObject:addButton];
    [addButton release];
    
    // create a standard "edit" button
    addButton = [[UIBarButtonItem alloc]
          initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editAction:)];
    addButton.style = UIBarButtonItemStyleBordered;
    [buttons addObject:addButton];
    [addButton release];
    
    // stick the buttons in the toolbar
    [tools setItems:buttons animated:NO];
    
    [buttons release];
    
    // and put the toolbar in the nav bar
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:tools];
    [tools release];

    
}

- (void)viewWillAppear:(BOOL)animated {
    peopleArray = [self fetchAllPeople];
    self.navigationItem.leftBarButtonItem = [self editButtonItem];
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
    self.addButton = nil;
    self.peopleArray = nil;
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

- (void)addEvent 
{
    TestAppDelegate *appDelegate = (TestAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *context = appDelegate.managedObjectContext;
    NSManagedObject *person = (Person *)[NSEntityDescription
                                       insertNewObjectForEntityForName:@"Person" 
                                       inManagedObjectContext:context];
    //TODO-Rl implement capturing this data from 2 fields 

    [person setValue:@"blah name" forKey:@"firstname"];
    [person setValue:@"more blah" forKey:@"lastname"];
    
    if (![context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
//    
//    NSArray *fetchedObjects = [self fetchAllPeople];
//    
    // ******* start logging
//    for (NSManagedObject *info in fetchedObjects) {
//        NSLog(@"FirstName: %@", [info valueForKey:@"firstname"]);
//        NSLog(@"LastName: %@", [info valueForKey:@"lastname"]);
//    }
    // ******* end logging
    
    [peopleArray insertObject:person atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                          withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    
}

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

- (void)dealloc 
{
//    [managedObjectContext release];
    [peopleArray release];
    [addButton release];
    [fetchRequest release];
    [super dealloc];
}

@end
