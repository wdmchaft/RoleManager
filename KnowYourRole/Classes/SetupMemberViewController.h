//
//  SetupMemberViewController.h
//
//  Created by Robert Little on 11-06-14.
//  Copyright 2011 littlelogic.ca All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Person.h"
#import "MemberAddViewController.h"
#import "TestAppDelegate.h"

@interface SetupMemberViewController : UITableViewController<MemberAddViewControllerDelegate>{
    
    NSMutableArray *peopleArray;
    UIBarButtonItem *button;
    NSFetchRequest *fetchRequest;
    NSError *error;
    TestAppDelegate *appDelegate;
    NSManagedObjectContext *context;
}

- (void)addEvent;
- (NSMutableArray *)fetchAllPeople;
- (void)addPerson:(NSDictionary*)userInfo;

- (void)addMemberViewController:(MemberAddViewController *)controller didFinish:(NSDictionary *)userInfo;

@property (nonatomic, retain) UIBarButtonItem *button;
@property (nonatomic, retain) NSMutableArray *peopleArray;
@property (nonatomic, retain) NSFetchRequest *fetchRequest;

@end
