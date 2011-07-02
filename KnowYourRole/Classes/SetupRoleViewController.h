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

@interface SetupRoleViewController : UITableViewController<RoleAddViewControllerDelegate>
{
 
    NSMutableArray *roleArray;
    UIBarButtonItem *button;
    NSFetchRequest *fetchRequest;
    NSError *error;
    
}

- (void)addEvent;
- (NSMutableArray *)fetchAllRoles;
- (void)addRole:(NSDictionary*)userInfo;

- (void)addRoleViewController:(RoleAddViewController *)controller didFinish:(NSDictionary *)userInfo;

@property (nonatomic, retain) UIBarButtonItem *button;
@property (nonatomic, retain) NSMutableArray *roleArray;
@property (nonatomic, retain) NSFetchRequest *fetchRequest;

@end
