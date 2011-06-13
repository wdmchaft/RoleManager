//
//  MemberViewController.h
//  Test
//
//  Created by Rob Little on 11-05-14.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MemberViewController : UITableViewController {
	
	NSArray *members;
	id delegate;
}

@property (nonatomic, assign) id delegate;

@end
