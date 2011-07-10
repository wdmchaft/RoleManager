//
//  RoleViewController.h
//  Test
//
//  Created by Rob Little on 11-05-15.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MemberViewController.h"
#import "Role.h"

@interface RoleViewController : UITableViewController<MemberViewControllerDelegate> {

	NSMutableArray *roles;
	id delegate;
    NSFetchRequest *fetchRequest;
    NSError *error;
}


- (NSMutableArray *)fetchAllRoles;
- (NSMutableArray *)fetchPeopleWithXRoles;

@property (nonatomic, assign) id delegate;
@property (nonatomic, retain) NSFetchRequest *fetchRequest;


@end
