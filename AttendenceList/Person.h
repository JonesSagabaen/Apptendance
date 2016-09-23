//
//  Person.h
//  PersonChecklist
//
//  Created by Jones Sagabaen on 8/21/15.
//  Copyright (c) 2015 Jones Sagabaen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject <NSCoding>

@property NSString *personName;

@property BOOL checked;

@property NSDate *creationDate;

@end
