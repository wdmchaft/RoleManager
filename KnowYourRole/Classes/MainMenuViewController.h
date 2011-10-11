//
//  MainMenuViewController.h
//
//  Created by Rob Little on 11-05-17.
//  Copyright 2011 littlelogic.ca All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "TestAppDelegate.h"

@interface MainMenuViewController : UIViewController 
{
    NSManagedObjectContext *context;
    NSFetchRequest *fetchRequest;
    NSError *error;
    TestAppDelegate *appDelegate;
}

-(IBAction)loadScreenOne:(id)sender;
-(IBAction)loadScreenTwo:(id)sender;
-(BOOL)isSetupComplete;
@property(retain) IBOutlet UIButton *assignRolesButton;
@property (nonatomic, retain) NSFetchRequest *fetchRequest;

@end
