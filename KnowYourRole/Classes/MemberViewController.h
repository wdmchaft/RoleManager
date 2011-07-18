//
//  MemberViewController.h
//  Test
//
//  Created by Rob Little on 11-05-14.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Person.h"
#import "Role.h"
#import "TestAppDelegate.h"

@protocol MemberViewControllerDelegate;

@interface MemberViewController : UITableViewController 
{
	NSMutableArray *members;
    // delegate we're actually using
	id selectionDelegate;
    // WORKAROUND - wierd shit happened when id delegate wasn't declared, even though it wasn't used
    id delegate;
    NSFetchRequest *fetchRequest;
    NSError *error;
    TestAppDelegate *appDelegate;
    NSManagedObjectContext *context;
}

- (NSMutableArray *)fetchAllPeople;

@property (nonatomic, assign) id delegate;
@property (nonatomic, assign) id<MemberViewControllerDelegate> selectionDelegate;
@property (nonatomic, retain) NSFetchRequest *fetchRequest;

@end

@protocol MemberViewControllerDelegate <NSObject>
@required
- (void)memberViewController:(MemberViewController *)vc didSelectMember:(Person *)aPerson;
@end

