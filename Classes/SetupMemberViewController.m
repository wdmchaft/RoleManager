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
    // Do any additional setup after loading the view from its nib.
    
    
    self.title = @"Member Setup";
    
    // Set up the buttons.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                              target:self action:@selector(addEvent)];
    addButton.enabled = YES;
    self.navigationItem.rightBarButtonItem = addButton;
    
//    if (managedObjectContext == nil) 
//    { 
//        //TODO- move all this to delegate, and then use it.  change this to delegate
//        managedObjectContext = [(TestAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext]; 
//        NSLog(@"After managedObjectContext: %@",  managedObjectContext);
//    }
    
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

- (void)addEvent 
{
    TestAppDelegate *appDelegate = (TestAppDelegate *)[[UIApplication sharedApplication] delegate];

    NSManagedObjectContext *context = appDelegate.managedObjectContext;
    
    NSManagedObject *person = (Person *)[NSEntityDescription
                                       insertNewObjectForEntityForName:@"Person" 
                                       inManagedObjectContext:context];
    //TODO-Rl implement capturing this data from 2 fields 
    
    [person setValue:@"Test first name" forKey:@"firstname"];
    [person setValue:@"Test last name" forKey:@"lastname"];
    
    //****ATTEMPT AT LOGGING SOME DATA*****
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *personDesc = [NSEntityDescription 
                                   entityForName:@"Person" inManagedObjectContext:context];
    [fetchRequest setEntity:personDesc];
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    for (NSManagedObject *info in fetchedObjects) {
        NSLog(@"FirstName: %@", [info valueForKey:@"firstname"]);
        NSLog(@"LastName: %@", [info valueForKey:@"lastname"]);
    }        
    [fetchRequest release];
    
    //TODO write data to view table, and make sure view loads data on first load
}

- (void)dealloc 
{
//    [managedObjectContext release];
    [peopleArray release];
    [addButton release];
    [super dealloc];
}

@end
