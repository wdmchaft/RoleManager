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
    //self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
	roles = [self fetchAllRoles];
    //TODO-RL have this load up Roles as main title per cell, but with person for the data as the info if its set
    //TODO-RL this will have to use a delegate, similar to how the save data screens pass info back
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
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
	// Configure the cell.
	Role *info = [roles objectAtIndex:indexPath.row];
    
    // Get current Assignee's name for cell detail 
    NSString *currentAssigneeName = nil;
    NSEnumerator *enumerator = [info.persons objectEnumerator];
    Person *currentAssignee;
    while ((currentAssignee = [enumerator nextObject])) {
        currentAssigneeName = [NSString stringWithFormat:@"%@%@%@", currentAssignee.firstname, @" ", currentAssignee.lastname];
    }
    
    if(currentAssigneeName != nil)
    {
        cell.textLabel.text = [NSString stringWithFormat:@"%@%@%@", info.rolename, @" - ", currentAssigneeName];
        return cell;
    }
    
    //TODO-RL figure out why this isn't acting as expected, but i want it to display role info
//    cell.detailTextLabel.text = info.info;
	cell.textLabel.text = info.rolename;
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
        
        // clear out the old person relation, and then set the new, as role:person is n:1
        int arrayCount = [selectedRole.persons count];
        NSAutoreleasePool *pool =  [[NSAutoreleasePool alloc] init];
        for (int i = 0; i < arrayCount; i++) {
            [[selectedRole.persons objectAtIndex:i] removeObject:(i)];
        }
        [pool release];
        
        [selectedRole addPersonsObject:aPerson];
    }
    
    /// debug only
    NSLog(@"Member selected %@" , aPerson);
    
    // set up the get for a managedObject represented by the aPerson object
    TestAppDelegate *appDelegate = (TestAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = appDelegate.managedObjectContext;
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    
    NSEntityDescription *entity =
    [NSEntityDescription entityForName:@"Person"
                inManagedObjectContext:context];
    [request setEntity:entity];
    
    NSPredicate *predicate =
    [NSPredicate predicateWithFormat:@"self == %@", aPerson];
    [request setPredicate:predicate];
    
    // perform get, and set the 
    NSArray *array = [context executeFetchRequest:request error:&error];
    if (array != nil) {
        NSUInteger count = [array count];
        if (count == 1) 
        {
            //TODO-RL i want to re-save the same object...
            // save data
            if (![context save:&error]) {
                NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
            }
        }
        //TODO-RL handle count !=1, or is that not really possible???
    }
    else
    {
        //handle error
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
    
         
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
    [super dealloc];
}


@end

