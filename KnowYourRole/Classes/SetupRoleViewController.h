//
//  SetupRoleViewController.h
//  Test
//
//  Created by Robert Little on 11-06-14.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Role.h"
#import "RoleAddViewController.h"
#import "TestAppDelegate.h"

@interface SetupRoleViewController : UITableViewController<RoleAddViewControllerDelegate>
{
 
    NSMutableArray *roleArray;
    UIBarButtonItem *button;
    NSFetchRequest *fetchRequest;
    NSError *error;
    NSDate* date; 
    TestAppDelegate *appDelegate;
    NSManagedObjectContext *context;
    
}

- (void)addEvent;
- (NSMutableArray *)fetchAllRoles;
- (void)addRole:(NSDictionary*)userInfo;

- (void)addRoleViewController:(RoleAddViewController *)controller didFinish:(NSDictionary *)userInfo;

@property (nonatomic, retain) UIBarButtonItem *button;
@property (nonatomic, retain) NSMutableArray *roleArray;
@property (nonatomic, retain) NSFetchRequest *fetchRequest;
@property (nonatomic, retain) NSDate *date;


@end
