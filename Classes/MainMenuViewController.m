//
//  MainMenuViewController.m
//  Test
//
//  Created by Rob Little on 11-05-17.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MainMenuViewController.h"
#import "RoleViewController.h"


@implementation MainMenuViewController

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
	self.title =@"fuckya";
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
}

#pragma mark -
#pragma mark IBActions
-(IBAction)loadScreenOne:(id)sender
{
	
}


-(IBAction)loadScreenTwo:(id)sender
{
	NSLog(@"Roles button Pressed - start of event");
	RoleViewController *roleViewController = [[RoleViewController alloc] initWithNibName:@"RoleViewController" bundle:nil];
	// Pass the selected object to the new view controller.
	roleViewController.title = @"Available Roles";
	[self.navigationController pushViewController:roleViewController animated:YES];
	
	[roleViewController release];
	NSLog(@"Roles button Pressed - end of event");	
}


@end
