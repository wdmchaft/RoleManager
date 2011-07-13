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
    Person *currentAssignee = [info.persons anyObject];
    if(currentAssignee != nil) {
        currentAssigneeName = [NSString stringWithFormat:@"%@%@%@", currentAssignee.firstname, @" ", currentAssignee.lastname];
    }
    
    // set cell label and detail
	cell.textLabel.text = info.rolename;
    cell.detailTextLabel.text = currentAssigneeName;
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"Unassign";
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
            // handle error
            NSLog(@"Whoops, more than one Person Object: %@", [error localizedDescription]);
        }
    }
    else
    {
        // handle error
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
        // for every Role without an Assignee... assign a person. 
        TestAppDelegate *appDelegate = (TestAppDelegate *)[[UIApplication sharedApplication] delegate];
        NSManagedObjectContext *context = appDelegate.managedObjectContext;
        NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
        
        NSEntityDescription *roleEntity =
        [NSEntityDescription entityForName:@"Role"
                    inManagedObjectContext:context];
        [request setEntity:roleEntity];
        
        // set predicate on roles without assignees 
        NSPredicate *unassignedRolePredicate = [NSPredicate predicateWithFormat:@"persons.@count == 0"];
        [request setPredicate:unassignedRolePredicate];
        
        // perform get
        NSMutableArray *unassignedRoles = [[context executeFetchRequest:request error:&error] mutableCopy];
        if (unassignedRoles != nil) 
        {
            //TODO-RL pass in a variable here
            NSMutableArray *peopleWithXRoles = [self fetchPeopleWithXRoles];
            
            int peopleWithXRolesCount = [peopleWithXRoles count];
            int unassignedRoleCount = [unassignedRoles count];
            
            // will record previously used random values to avoid duplicates
            NSMutableIndexSet *randomRoleIndexes = [NSMutableIndexSet indexSet];
            NSMutableIndexSet *randomPersonIndexes = [NSMutableIndexSet indexSet];
            
            NSLog(@"unassignedRoleCount is: %@", [NSNumber numberWithInt:unassignedRoleCount]);
            NSLog(@"people with 0 roles is: %@", [NSNumber numberWithInt:peopleWithXRolesCount]);
            
            // loop on # of people with x roles count, but TODO-RL put this in function, and call with passed in var iterably
            for (int i = 0; i < peopleWithXRolesCount; i++) {   //unassignedRoleCount
                
                NSLog(@"***********LOOP ITERATION %@", [NSNumber numberWithInt:i]);
                
                // get random index, from 0 - unassignedRoleCount -1
                int newRandomRoleIndex = arc4random() % (unassignedRoleCount);
                int newRandomPersonIndex = arc4random() % (peopleWithXRolesCount);

                NSLog(@"this randomRoleIndex is: %@", [NSNumber numberWithInt:newRandomRoleIndex]);
                NSLog(@"this randomPersonIndex is: %@", [NSNumber numberWithInt:newRandomPersonIndex]);
                // tracing that all new indeces are unique
                while ([randomRoleIndexes containsIndex:newRandomRoleIndex]) 
                {
                    newRandomRoleIndex = arc4random() % (unassignedRoleCount);
                    NSLog(@"*looping* this randomRoleIndex is: %@", [NSNumber numberWithInt:newRandomRoleIndex]);
                }
                
                while ([randomPersonIndexes containsIndex:newRandomPersonIndex]) 
                {
                    newRandomPersonIndex = arc4random() % (peopleWithXRolesCount);
                    NSLog(@"*looping* this randomPersonIndex is: %@", [NSNumber numberWithInt:newRandomPersonIndex]);
                }

                // record this random indexes
                [randomRoleIndexes addIndex:newRandomRoleIndex];
                [randomPersonIndexes addIndex:newRandomPersonIndex];
                
                // get role and person objects using these random indexes
                Role *role = [unassignedRoles objectAtIndex:newRandomRoleIndex];
                Person *person = [peopleWithXRoles objectAtIndex:newRandomPersonIndex];
                role.persons = [NSSet setWithObject:person];
                
                NSEntityDescription *entity =
                [NSEntityDescription entityForName:@"Role"
                            inManagedObjectContext:context];
                [request setEntity:entity];
                 
                // set predicate and refer to role Object to aquire 
                NSPredicate *predicate =
                [NSPredicate predicateWithFormat:@"self == %@", role];
                [request setPredicate:predicate];
                
                //TODO-RL ask B if you can save stuff as a batch?
                
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
                        // handle error
                        NSLog(@"Whoops, more than one Person Object: %@", [error localizedDescription]);
                    }
                }
                else
                {
                    // handle error
                    NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
                }
            }

            //TODO-RL call logic again when unassignedRoles exist, and peopleWithXRolesCount is > 0.  Do this until ready to be done.
            // double check everything
            [request setEntity:roleEntity];
            [request setPredicate:unassignedRolePredicate];
            unassignedRoles = [[context executeFetchRequest:request error:&error] mutableCopy];
            if (unassignedRoles != nil) 
            {
                NSLog(@"more to do!");
            }      
        }
        else
        {
            // handle error
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }
        
        // update table view with data   
        [self.tableView reloadData];
    }
}

- (NSMutableArray *)fetchPeopleWithXRoles
{
    //for every Role without an Assignee... assign a person. 
    TestAppDelegate *appDelegate = (TestAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = appDelegate.managedObjectContext;
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    
    NSEntityDescription *entity =
    [NSEntityDescription entityForName:@"Person"
                inManagedObjectContext:context];
    [request setEntity:entity];
    
    // var arg - TODO-RL change this or make it more flexible for more complex logic.
    NSNumber *numRoles= [NSNumber numberWithInteger:0];
    
    // set predicate on roles without assignees 
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"roles.@count == %@", numRoles];
    [request setPredicate:predicate];
    
    // perform get
    NSMutableArray *filteredArray = [[context executeFetchRequest:request error:&error] mutableCopy];
    return filteredArray;
}

@end

