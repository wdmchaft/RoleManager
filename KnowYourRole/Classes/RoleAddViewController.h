//
//  RoleAddViewController.h
//
//  Created by Robert Little on 11-06-25.
//  Copyright 2011 littlelogic.ca All rights reserved.
//

#import <UIKit/UIKit.h>

@class RoleAddViewController;

@protocol RoleAddViewControllerDelegate <NSObject>

- (void)addRoleViewController:(RoleAddViewController *)controller didFinish:(NSDictionary *)roleInfo;

@end

@interface RoleAddViewController : UIViewController
{
    id delegate;
    IBOutlet UITextField *roleName;
    IBOutlet UITextField *info;
}

-(IBAction)save:(id)sender;
-(IBAction)cancel:(id)sender;
@property (nonatomic, assign) id<RoleAddViewControllerDelegate> delegate;

@end
