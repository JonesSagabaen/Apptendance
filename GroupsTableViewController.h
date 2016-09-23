//
//  GroupsTableViewController.h
//  AttendenceList
//
//  Created by Jones Sagabaen on 8/19/15.
//  Copyright (c) 2015 Jones Sagabaen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GroupsTableViewController : UITableViewController

@property (readwrite) NSMutableArray *groupsList;

@property UIBarButtonItem *saveBarButton;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *addButton;

- (IBAction)addButtonAction:(id)sender;

@end
