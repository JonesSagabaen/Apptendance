//
//  Group.m
//  PersonChecklist
//
//  Created by Jones Sagabaen on 8/25/15.
//  Copyright (c) 2015 Jones Sagabaen. All rights reserved.
//

#import "Group.h"

@implementation Group

#pragma mark - NSCoding support

- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        self.groupName = [decoder decodeObjectForKey:@"groupName"];
        self.personListArrayIndex = [decoder decodeIntegerForKey:@"personListArrayIndex"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.groupName forKey:@"groupName"];
    [encoder encodeInteger:self.personListArrayIndex forKey:@"personListArrayIndex"];
}

@end
