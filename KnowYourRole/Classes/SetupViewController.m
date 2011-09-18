//
//  SetupViewController.m
//  Test
//
//  Created by Robert Little on 11-06-13.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SetupViewController.h"
#import "SetupMemberViewController.h"
#import "SetupRoleViewController.h"

@implementation SetupViewController

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
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark IBActions
-(IBAction)loadScreenOne:(id)sender
{
	SetupMemberViewController *setupMemberViewController = [[SetupMemberViewController alloc] initWithNibName:@"SetupMemberViewController" bundle:nil];
	// Pass the selected object to the new view controller.
	setupMemberViewController.title = @"Member Setup";
	[self.navigationController pushViewController:setupMemberViewController animated:YES];
	
	[setupMemberViewController release];   
}


-(IBAction)loadScreenTwo:(id)sender
{
	SetupRoleViewController *setupRoleViewController = [[SetupRoleViewController alloc] initWithNibName:@"SetupRoleViewController" bundle:nil];
	// Pass the selected object to the new view controller.
	setupRoleViewController.title = @"Role Setup";
	[self.navigationController pushViewController:setupRoleViewController animated:YES];
	
	[setupRoleViewController release];
}

@end
