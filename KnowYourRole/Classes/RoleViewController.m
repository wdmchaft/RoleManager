//
//  RoleViewController.m
//  Test
//
//  Created by Rob Little on 11-05-14.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RoleViewController.h"
#import "TestAppDelegate.h"

@implementation RoleViewController

@synthesize delegate;
@synthesize fetchRequest;

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = @"Roles";
	
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.

    // use the available "edit" button
    self.editButtonItem.title = @"Clear Roles";
    self.navigationItem.rightBarButtonItem = self.editButtonItem;

	roles = [self fetchAllRoles];
}

/*
 - (void)viewWillAppear:(BOOL)animated {
 [super viewWillAppear:animated];
 }
 */
/*
 - (void)viewDidAppear:(BOOL)animated {
 [super viewDidAppear:animated];
 }
 */
/*
 - (void)viewWillDisappear:(BOOL)animated {
 [super viewWillDisappear:animated];
 }
 */
/*
 - (void)viewDidDisappear:(BOOL)animated {
 [super viewDidDisappear:animated];
 }
 */

/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations.
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

- (void)tableView:(UITableView *)aTableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    TestAppDelegate *appDelegate = (TestAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = appDelegate.managedObjectContext;
    
    // handle delete event - UNSETS assignments, doesn't delete the Role!!!
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        // Delete the managed object at the given index path.
        Role *roleEventToUnassign = [roles objectAtIndex:indexPath.row];
        NSLog(@"roleEventToUnassign B4: %@", roleEventToUnassign);
        [roleEventToUnassign setPersons:nil];	
        
        // Commit the change.
        if (![context save:&error]) {
            NSLog(@"Whoops, couldn't delete: %@", [error localizedDescription]);
        }
        roles = [self fetchAllRoles];
        
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView setNeedsDisplay];
        [self viewDidLoad];
        NSLog(@"roleEventToUnassign after: %@", roleEventToUnassign);
    }
//TODO BUG cell reloadRowsAtIndexPaths 2nd click, cycles the previously deleted name back in, but only for the view (data model is right).
    // wrapping in begin/endUpdates didn't work either.  
    
    // HOW THE FUCK DO I OVERRIDE THE 'DELETE' BUTTON TEXT TO SAY 'UN-ASSIGN'
}

- (void) setEditing:(BOOL)editing animated:(BOOL)animated {
    //Do super before, it will change the name of the editing button
    [super setEditing:editing animated:animated];
    
    if (editing) {
        self.editButtonItem.title = @"Done";
        self.navigationItem.rightBarButtonItem.style = UIBarButtonItemStyleDone;
    }
    else {
        self.editButtonItem.title = @"Clear Roles";
    }
}

#pragma mark -
#pragma mark Table view data source

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return roles.count;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }

    // get Role object
	Role *info = [roles objectAtIndex:indexPath.row];
    
    // get current assignee's name for cell detail 
    NSString *currentAssigneeName = nil;
    NSEnumerator *enumerator = [info.persons objectEnumerator];
    Person *currentAssignee;
    while ((currentAssignee = [enumerator nextObject])) 
    {
        currentAssigneeName = [NSString stringWithFormat:@"%@%@%@", currentAssignee.firstname, @" ", currentAssignee.lastname];
    }
    
    // set cell label and detail
	cell.textLabel.text = info.rolename;
    if(currentAssigneeName != nil)
    {
        cell.detailTextLabel.text = currentAssigneeName;
    }
    return cell;
}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */


/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source.
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
 }   
 }
 */


/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */


/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
	
	MemberViewController *detailViewController = [[MemberViewController alloc] initWithNibName:@"MemberViewController" bundle:nil];
	// ...
	// Pass the selected object to the new view controller.

    Role *selectedRole = [roles objectAtIndex:indexPath.row];
    detailViewController.title = selectedRole.rolename;
	detailViewController.selectionDelegate = self;
	[self.navigationController pushViewController:detailViewController animated:YES];
	[detailViewController release];
}


#pragma mark -
- (void)memberViewController:(MemberViewController *)vc didSelectMember:(Person *)aPerson
{
    NSIndexPath  *indexPath = [self.tableView indexPathForSelectedRow];
    
    if(aPerson != nil) {
        [self.navigationController popViewControllerAnimated:YES];
        
        Role *selectedRole = [roles objectAtIndex:indexPath.row];
        
        // clear out the old person relation
        NSMutableSet *rolePersons = [selectedRole mutableSetValueForKey:@"persons"];
        NSAutoreleasePool *pool =  [[NSAutoreleasePool alloc] init];
        [rolePersons removeAllObjects];
        [pool release];
        
        // and then set the new, as role:person is n:1
        [selectedRole addPersonsObject:aPerson];
    }

    // set up the get for a managedObject represented by the aPerson object
    TestAppDelegate *appDelegate = (TestAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = appDelegate.managedObjectContext;
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    
    NSEntityDescription *entity =
    [NSEntityDescription entityForName:@"Person"
                inManagedObjectContext:context];
    [request setEntity:entity];
    
    // set predicate and refer to aPerson Object to aquire 
    NSPredicate *predicate =
    [NSPredicate predicateWithFormat:@"self == %@", aPerson];
    [request setPredicate:predicate];
    
    // perform get
    NSArray *array = [context executeFetchRequest:request error:&error];
    if (array != nil) {
        NSUInteger count = [array count];
        if (count == 1) 
        {
            // save data
            if (![context save:&error]) {
                NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
            }
        }
        else
        {
            //handle error
            NSLog(@"Whoops, more than one Person Object: %@", [error localizedDescription]);
        }
    }
    else
    {
        //handle error
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
    
    // update table view with data   
    [self.tableView reloadData];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}



#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
	roles = nil;
    fetchRequest = nil;
    error = nil;
}

- (NSMutableArray *)fetchAllRoles
{
    TestAppDelegate *appDelegate = (TestAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = appDelegate.managedObjectContext;
    
    fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *roleDesc = [NSEntityDescription 
                                     entityForName:@"Role" inManagedObjectContext:context];
    [fetchRequest setEntity:roleDesc];
    NSMutableArray *fetchedObjects = [[context executeFetchRequest:fetchRequest error:&error] mutableCopy];
    
    return fetchedObjects;
}

- (void)dealloc {
    NSLog(@"Say bye to %@, kids!", self);
    [super dealloc];
}

#pragma mark - 
#pragma mark Shake Event 
-(BOOL)canBecomeFirstResponder {
    return YES;
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self resignFirstResponder];
    [super viewWillDisappear:animated];
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (motion == UIEventSubtypeMotionShake)
    {
        // your code
        NSLog(@"Shake Win");
    }
}

@end

