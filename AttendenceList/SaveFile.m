//
//  ArchiveFile.m
//  PersonChecklist
//
//  Created by Jones Sagabaen on 9/3/15.
//  Copyright (c) 2015 Jones Sagabaen. All rights reserved.
//

#import "SaveFile.h"

@implementation SaveFile

#pragma mark - NSCoding support

- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        self.dateCreated = [decoder decodeObjectForKey:@"dateCreated"];
        self.personsList = [decoder decodeObjectForKey:@"personsArchive"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.dateCreated forKey:@"dateCreated"];
    [encoder encodeObject:self.personsList forKey:@"personsArchive"];
}

@end
