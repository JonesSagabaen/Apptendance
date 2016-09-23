//
//  ArchivesTableViewController.h
//  PersonChecklist
//
//  Created by Jones Sagabaen on 9/1/15.
//  Copyright (c) 2015 Jones Sagabaen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryTableViewController : UITableViewController

@property (readwrite) NSMutableArray *saveArray;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *refreshBarButton;

@end
