//
//  MemberAddViewController.h
//  Test
//
//  Created by Robert Little on 11-06-20.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MemberAddViewController;

@protocol MemberAddViewControllerDelegate <NSObject>
- (void)addMemberViewController:(MemberAddViewController *)controller didFinish:(NSDictionary *)userInfo;
@end

@interface MemberAddViewController : UIViewController
{
    id delegate;
    IBOutlet UITextField *firstName;
    IBOutlet UITextField *lastName;
}

-(IBAction)save:(id)sender;
-(IBAction)cancel:(id)sender;
@property (nonatomic, assign) id<MemberAddViewControllerDelegate> delegate;

@end
