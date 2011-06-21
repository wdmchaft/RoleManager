//
//  MemberAddViewController.m
//  Test
//
//  Created by Robert Little on 11-06-20.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MemberAddViewController.h"

@implementation MemberAddViewController

@synthesize delegate;

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

#pragma mark IBActions
-(IBAction)save:(id)sender
{
    //TODO-RL implement validation on firstname/lastname - not null
    
    // set results for parent controller to use
    NSDictionary *results = [NSDictionary dictionaryWithObjectsAndKeys:firstName.text, @"firstName",
                             lastName.text, @"lastName", nil];
    [self.delegate addMemberViewController:self didFinish:results];
}

@end
