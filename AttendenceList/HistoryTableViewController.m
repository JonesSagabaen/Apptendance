//
//  ArchivesTableViewController.m
//  PersonChecklist
//
//  Created by Jones Sagabaen on 9/1/15.
//  Copyright (c) 2015 Jones Sagabaen. All rights reserved.
//

#import "HistoryTableViewController.h"
#import "SaveReaderViewController.h"
#import "SaveFile.h"

@interface HistoryTableViewController ()

@end

@implementation HistoryTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Initialize Group array
    self.saveArray = [[NSMutableArray alloc] init];
    [self loadData];
    // Load theme set in Settings
    [self loadTheme];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Save/load data

// Save data
- (void)saveData {
    NSData *saveData = [NSKeyedArchiver archivedDataWithRootObject:self.saveArray];
    [[NSUserDefaults standardUserDefaults] setObject:saveData forKey:@"saveFiles"];
    [[NSUserDefaults standardUserDefaults] synchronize];
//    NSLog(@"Data saved");
}

// Load data
- (void)loadData {
    // Load saved data
    NSData *saveData = [[NSUserDefaults standardUserDefaults] objectForKey:@"saveFiles"];
    self.saveArray = [NSKeyedUnarchiver unarchiveObjectWithData:saveData];
//    NSLog(@"Data loaded");
}

// Display a custom theme for the header of the app
- (void)loadTheme {
    // Set tab bar theme
    [self.tabBarController.tabBar setTintColor:[UIColor darkGrayColor]];
    //[self.tabBarController.tabBar setBarTintColor:[UIColor colorWithRed:(160/255.0) green:(255/255.0) blue:(170/255.0) alpha:1]];
    
    // Set navigation bar theme based on iOS
    NSArray *ver = [[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."];
    // iOS 7.0 or later
    if ([[ver objectAtIndex:0] intValue] >= 7) {
        // Change background color
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:(160/255.0) green:(255/255.0) blue:(170/255.0) alpha:1];
        self.navigationController.navigationBar.translucent = NO;
        
        // Change status bar icons color
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        // Change title text color
        self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor grayColor]};
        // Change bar button color
        [self.navigationController.navigationBar setTintColor:[UIColor grayColor]];
    }
    // iOS 6.1 or earlier
    else {
        self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:(160/255.0) green:(255/255.0) blue:(170/255.0) alpha:1];
    }
}

#pragma mark - Table view data source

- (IBAction)refreshTable:(id)sender {
    // Load data
    [self loadData];
    
    // Reload the table data with the new data
    [self.tableView reloadData];
}

- (IBAction)pullToRefresh:(id)sender {
    // Load data
    [self loadData];
    
    // Reload the table data with the new data
    [self.tableView reloadData];
    
    // Restore the view to normal
    [sender endRefreshing];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.saveArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HistoryPrototypeCell" forIndexPath:indexPath];
    
    // Get current Save file
    SaveFile *currentSaveFile = [self.saveArray objectAtIndex:indexPath.row];
    NSDate *currentDate = currentSaveFile.dateCreated;
    NSDateFormatter *formatterDate = [[NSDateFormatter alloc] init];
    // Format date text
    [formatterDate setDateFormat:@"MMMM dd, yyyy"];
    NSString *dateString = [formatterDate stringFromDate:currentDate];
    cell.textLabel.text = dateString;
    // Format time text
    [formatterDate setDateFormat:@"hh:mm:ss a zzz"];
    NSString *timeString = [formatterDate stringFromDate:currentDate];
    cell.detailTextLabel.text = timeString;
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"SegueViewArchive"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        SaveFile *currentSaveFile = [self.saveArray objectAtIndex:indexPath.row];

        SaveReaderViewController *destViewController = segue.destinationViewController;
        destViewController.segueText = currentSaveFile.personsList;
    }
}

@end
