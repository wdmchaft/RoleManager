//
//  SetupMemberViewController.h
//  Test
//
//  Created by Robert Little on 11-06-14.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Person.h"

@interface SetupMemberViewController : UIViewController{
    
    NSMutableArray *peopleArray;
    UIBarButtonItem *addButton;
}

- (void)addEvent;

@property (nonatomic, retain) UIBarButtonItem *addButton;
@property (nonatomic, retain) NSMutableArray *peopleArray;

@end
