//
//  Person.h
//  Test
//
//  Created by Robert Little on 11-06-13.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Person : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * firstname;
@property (nonatomic, retain) NSString * lastname;

@end
