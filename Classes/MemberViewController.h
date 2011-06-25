//
//  MemberViewController.h
//  Test
//
//  Created by Rob Little on 11-05-14.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Person.h"

@interface MemberViewController : UITableViewController 
{
	NSMutableArray *members;
	id delegate;
    NSFetchRequest *fetchRequest;
    NSError *error;
}

- (NSMutableArray *)fetchAllPeople;

@property (nonatomic, assign) id delegate;
@property (nonatomic, retain) NSFetchRequest *fetchRequest;

@end
