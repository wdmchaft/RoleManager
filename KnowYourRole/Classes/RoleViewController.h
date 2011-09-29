//
//  RoleViewController.h
//
//  Created by Rob Little on 11-05-15.
//  Copyright 2011 littlelogic.ca All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MemberViewController.h"
#import "Role.h"

@interface RoleViewController : UITableViewController<MemberViewControllerDelegate> {

	NSMutableArray *roles;
	id delegate;
    NSFetchRequest *fetchRequest;
    NSError *error;
    TestAppDelegate *appDelegate;
    NSManagedObjectContext *context;
}


- (NSMutableArray *)fetchAllRoles;
- (NSMutableArray *)fetchPeopleWithXRoles:(int)numUnassignedRoles;
- (void) recursiveRandomizer:(NSMutableArray *)integers count:(int)peopleWithXRolesCount;

@property (nonatomic, assign) id delegate;
@property (nonatomic, retain) NSFetchRequest *fetchRequest;


@end
