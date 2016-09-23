//
//  ArchiveFile.h
//  PersonChecklist
//
//  Created by Jones Sagabaen on 9/3/15.
//  Copyright (c) 2015 Jones Sagabaen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SaveFile : NSObject <NSCoding>

@property NSDate *dateCreated;

@property NSString *personsList;

@end
