//
//  PersonListViewController.h
//  PersonChecklist
//
//  Created by Jones Sagabaen on 8/20/15.
//  Copyright (c) 2015 Jones Sagabaen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonListViewController : UITableViewController

@property (readwrite) NSUInteger currentGroupNum;

@property (readwrite) NSMutableArray *groupsArray;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *addButton;

- (IBAction)addButtonAction:(id)sender;

@end
