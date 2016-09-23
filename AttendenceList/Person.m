//
//  Person.m
//  PersonChecklist
//
//  Created by Jones Sagabaen on 8/21/15.
//  Copyright (c) 2015 Jones Sagabaen. All rights reserved.
//

#import "Person.h"

@implementation Person

#pragma mark - NSCoding support

- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        self.personName = [decoder decodeObjectForKey:@"personName"];
        self.checked = [decoder decodeBoolForKey:@"checked"];
        self.creationDate = [decoder decodeObjectForKey:@"creationDate"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.personName forKey:@"personName"];
    [encoder encodeBool:self.checked forKey:@"checked"];
    [encoder encodeObject:_creationDate forKey:@"creationDate"];
}

@end
