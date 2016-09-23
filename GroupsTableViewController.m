//
//  GroupsTableViewController.m
//  AttendenceList
//
//  Created by Jones Sagabaen on 8/19/15.
//  Copyright (c) 2015 Jones Sagabaen. All rights reserved.
//

#import "GroupsTableViewController.h"
#import "PersonListViewController.h"
#import "Group.h"
#import "Person.h"
#import "SaveFile.h"

@interface GroupsTableViewController ()

@property UITextField *alertTextField;

@end

@implementation GroupsTableViewController

#pragma mark - Helper methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Initialize Group array
    self.groupsList = [[NSMutableArray alloc] init];
    [self loadData];
    // Load theme set in Settings
    [self loadTheme];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
//    UIImage *editImage = [UIImage imageNamed:@"placeholderEdit"];
//    UIButton *editButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    editButton.bounds = CGRectMake(0, 0, 20, 20);
//    [editButton setImage:editImage forState:UIControlStateNormal];
//    UIBarButtonItem *editBarButton = [[UIBarButtonItem alloc] initWithCustomView:editButton];
//    [editButton addTarget:self action:@selector() forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.rightBarButtonItem = editBarButton;
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    UIImage *saveImage = [UIImage imageNamed:@"placeholderSave"];
    UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    saveButton.bounds = CGRectMake(0, 0, 20, 20);
    [saveButton setImage:saveImage forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
    self.saveBarButton = [[UIBarButtonItem alloc] initWithCustomView:saveButton];
    self.navigationItem.leftBarButtonItem = self.saveBarButton;
    
    // Workaround to hide empty table cells
    self.tableView.tableFooterView = [UIView new];
    
//    // Have view load with action cells hidden
//    self.automaticallyAdjustsScrollViewInsets = NO;
}

//// Hide action cells by offsetting the table view
//- (void) viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    [self.tableView setContentOffset:CGPointMake(0, 44) animated:NO];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Save/load data

// Save data
- (void)saveData {
    NSData *groupListData = [NSKeyedArchiver archivedDataWithRootObject:self.groupsList];
    [[NSUserDefaults standardUserDefaults] setObject:groupListData forKey:@"groupsList"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    //NSLog(@"Data saved");
}

// Load data
- (void)loadData {
    // Load saved data
    NSData *groupListData = [[NSUserDefaults standardUserDefaults] objectForKey:@"groupsList"];
    self.groupsList = [NSKeyedUnarchiver unarchiveObjectWithData:groupListData];
    //NSLog(@"Data loaded");
    
    // Create a new Groups list when no previously saved data is found
    if(!self.groupsList) {
        self.groupsList = [[NSMutableArray alloc] init];
        NSData *groupListData = [NSKeyedArchiver archivedDataWithRootObject:self.groupsList];
        [[NSUserDefaults standardUserDefaults] setObject:groupListData forKey:@"groupsList"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSLog(@"GroupsTableViewController: Groups list has been initialized");
        
        NSMutableArray *groupsArray = [[NSMutableArray alloc] init];
        NSData *groupData = [NSKeyedArchiver archivedDataWithRootObject:groupsArray];
        [[NSUserDefaults standardUserDefaults] setObject:groupData forKey:@"groups"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSLog(@"GroupsTableViewController: Persons list has been initialized");
        
        NSMutableArray *saveArray = [[NSMutableArray alloc] init];
        NSData *saveData = [NSKeyedArchiver archivedDataWithRootObject:saveArray];
        [[NSUserDefaults standardUserDefaults] setObject:saveData forKey:@"saveFiles"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSLog(@"GroupsTableViewController: History list has been initialized");
        
        // Prompt user to create a new list
        [self addButtonAction:self];
    }
}

// Display a custom theme for the header of the app
- (void)loadTheme {
    // Display custom image for the navigation bar
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"placeholderLogo"]];
    
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.groupsList count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UncheckAllGroupsCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GroupListPrototypeCell" forIndexPath:indexPath];
        
        // Get group array element and set text label
        Group *currentGroup = [self.groupsList objectAtIndex:(indexPath.row - 1)];
        cell.textLabel.text = currentGroup.groupName;
        return cell;
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
 */

# pragma mark - Editing mode functions

// Support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Load groups array
        NSMutableArray *groupsArray = [[NSMutableArray alloc] init];
        NSData *unarchiveGroupsData = [[NSUserDefaults standardUserDefaults] objectForKey:@"groups"];
        groupsArray = [NSKeyedUnarchiver unarchiveObjectWithData:unarchiveGroupsData];
        // Delete groups array object
        Group *groupToDelete = [self.groupsList objectAtIndex:(indexPath.row - 1)];
        //NSLog(@"Group to delete: %@", groupToDelete.groupName);
        [groupsArray removeObjectAtIndex:groupToDelete.personListArrayIndex];
        // Save groups array
        NSData *archiveGroupsData = [NSKeyedArchiver archivedDataWithRootObject:groupsArray];
        [[NSUserDefaults standardUserDefaults] setObject:archiveGroupsData forKey:@"groups"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        // Delete groups list object
        [self.groupsList removeObjectAtIndex:(indexPath.row - 1)];
        // Adjust grouplist pointers
        for (NSUInteger i = 0; i < [self.groupsList count]; i++) {
            Group *iterGroup = [self.groupsList objectAtIndex:i];
            //NSLog(@"Group: %@", iterGroup.groupName);
            if (iterGroup.personListArrayIndex >= groupToDelete.personListArrayIndex) {
                iterGroup.personListArrayIndex--;
            }
        }
        // Save groups list
        [self saveData];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

// Disables swiping row to enter editing mode
- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return the style for each row of the list
    if (self.tableView.editing) {
        // Exclude Uncheck All Groups cell
        if (indexPath.row > 0) {
            return UITableViewCellEditingStyleDelete;
        }
    }
    return UITableViewCellEditingStyleNone;
}

// Custom actions for entering and exiting editing mode
- (void)setEditing:(BOOL)flag animated:(BOOL)animated
{
    [super setEditing:flag animated:animated];
    // Entered editing mode
    if (flag == YES){
        // Change views to edit mode
        self.navigationItem.leftBarButtonItem = self.addButton;
        
//        // Hide Save cell text
//        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//        UITableViewCell *currentCell = [self.tableView cellForRowAtIndexPath:indexPath];
//        currentCell.textLabel.textColor = [UIColor whiteColor];
//        // Hide Uncheck All Groups cell text
//        indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
//        currentCell = [self.tableView cellForRowAtIndexPath:indexPath];
//        //currentCell.backgroundColor = [UIColor whiteColor];
//        currentCell.textLabel.textColor = [UIColor lightGrayColor];
    }
    // Exited editing mode
    else {
        // Save the changes if needed and change the views to noneditable.
//        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.leftBarButtonItem = self.saveBarButton;
        
//        // Hide Save cell text
//        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//        UITableViewCell *currentCell = [self.tableView cellForRowAtIndexPath:indexPath];
//        currentCell.textLabel.textColor = self.view.tintColor;
//        // Unhide Uncheck All Groups cell
//        indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
//        currentCell = [self.tableView cellForRowAtIndexPath:indexPath];
//        currentCell.backgroundColor = [UIColor lightGrayColor];
//        currentCell.textLabel.textColor = [UIColor whiteColor];
    }
}

#pragma mark - Custom table rearranging

// Support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    NSString *stringToMove = [self.groupsList objectAtIndex:(fromIndexPath.row - 1)];
    [self.groupsList removeObjectAtIndex:(fromIndexPath.row - 1)];
    [self.groupsList insertObject:stringToMove atIndex:(toIndexPath.row - 1)];
    [self saveData];
}

// Set rows that are reaarangable
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) // Don't move the Uncheck All Groups row
        return NO;
    else
        return YES;
}

// Allows rearranging of table cells excluding the last Uncheck All Groups cell
- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath {
    // Test whether destination is allowed
    if (proposedDestinationIndexPath.row > 0 && proposedDestinationIndexPath.row < [self.groupsList count] + 1) {
        return proposedDestinationIndexPath;    // If allowed move to proposed destination
    }
    else {
        return sourceIndexPath;                 // Else, send back to where it came from!
    }
}

#pragma mark - Button actions

// Action for editing mode's add button
- (IBAction)addButtonAction:(id)sender {
    UIAlertView *createGroupPrompt = [[UIAlertView alloc] initWithTitle:@"Create Group" message:@"Enter the name of the group to be created" delegate:self cancelButtonTitle:@"Submit" otherButtonTitles:nil];
    createGroupPrompt.tag = 100;
    createGroupPrompt.alertViewStyle = UIAlertViewStylePlainTextInput;
    self.alertTextField = [createGroupPrompt textFieldAtIndex:0];
    self.alertTextField.keyboardType = UIKeyboardTypeDefault;
    self.alertTextField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    self.alertTextField.placeholder = @"Group name";
    [createGroupPrompt show];
}

// Action for selecting the added custom cells
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == 0) {
        [self uncheckAllGroupsAction];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

// Action for selecting the Uncheck All Groups cell
- (void)uncheckAllGroupsAction {
    // Confirm action
    UIAlertView *confirmationPrompt = [[UIAlertView alloc] initWithTitle:@"Confirm" message:@"Are you sure you would like to uncheck boxes for all groups?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    confirmationPrompt.tag = 200;
    [confirmationPrompt show];
}

// Action for selecting the Save cell
- (void)saveAction {
    // Confirm action
    UIAlertView *confirmationPrompt = [[UIAlertView alloc] initWithTitle:@"Confirm" message:@"Are you sure you would like to save current attendance?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    confirmationPrompt.tag = 300;
    [confirmationPrompt show];
}

// Action for the various Alert prompts
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    // Action for Add button
    if (alertView.tag == 100) {
        if ([self.alertTextField.text length] <= 0){
            return;     //If cancel or 0 length string the string doesn't matter
        }
        else {
            // Add to the group list array
            Group *newGroup = [[Group alloc] init];
            newGroup.groupName = self.alertTextField.text;
            newGroup.personListArrayIndex = [self.groupsList count];
            [self.groupsList addObject:newGroup];
            [self saveData];
            
            // Load groups array, add a new group and save data
            NSMutableArray *groupsArray = [[NSMutableArray alloc] init];
            NSData *unarchiveGroupsData = [[NSUserDefaults standardUserDefaults] objectForKey:@"groups"];
            groupsArray = [NSKeyedUnarchiver unarchiveObjectWithData:unarchiveGroupsData];
            [groupsArray addObject:[[NSMutableArray alloc] init]];
            NSData *archiveGroupData = [NSKeyedArchiver archivedDataWithRootObject:groupsArray];
            [[NSUserDefaults standardUserDefaults] setObject:archiveGroupData forKey:@"groups"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [self.tableView reloadData];
        }
    }
    // Action for the Uncheck All Groups cell
    else if (alertView.tag == 200) {
        if (buttonIndex == 0) {
            // Cancel button selected
        }
        else if (buttonIndex == 1) {
            // Load groups array
            NSMutableArray *groupsArray = [[NSMutableArray alloc] init];
            NSData *unarchiveGroupsData = [[NSUserDefaults standardUserDefaults] objectForKey:@"groups"];
            groupsArray = [NSKeyedUnarchiver unarchiveObjectWithData:unarchiveGroupsData];
            // Load persons array from the group array
            for (NSMutableArray __strong *personList in groupsArray) {
                // Access each person from the persons array and change data
                for (Person *person in personList) {
                    //NSLog(@"%@ %d", person.personName, person.checked);
                    person.checked = NO;
                }
            }
            // Save groups array
            NSData *archiveGroupsData = [NSKeyedArchiver archivedDataWithRootObject:groupsArray];
            [[NSUserDefaults standardUserDefaults] setObject:archiveGroupsData forKey:@"groups"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            // Prompt that Uncheck All Groups action occurred
            UIAlertView *successPrompt = [[UIAlertView alloc] initWithTitle:@"Cleared" message:@"All checkboxes have been unchecked for all groups" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [successPrompt show];
        }
    }
    // Action for the Save cell
    else if (alertView.tag == 300) {
        if (buttonIndex == 0) {
            // Cancel button selected
        }
        else if (buttonIndex == 1) {
            // Load saved data
            NSMutableArray *archiveArray = [[NSMutableArray alloc] init];
            NSData *unarchiveArchivesData = [[NSUserDefaults standardUserDefaults] objectForKey:@"saveFiles"];
            archiveArray = [NSKeyedUnarchiver unarchiveObjectWithData:unarchiveArchivesData];
            
            // Create new save file and add it to the array
            NSMutableString *personsString = [NSMutableString string];
            NSDate *currentDate = [NSDate date];
            NSDateFormatter *formatterDate = [[NSDateFormatter alloc] init];
            [formatterDate setDateFormat:@"MMMM dd, yyyy"];
            NSString *dateString = [formatterDate stringFromDate:currentDate];
            [personsString appendFormat:@"%@\n", dateString];
            [formatterDate setDateFormat:@"hh:mm:ss a zzz"];
            dateString = [formatterDate stringFromDate:currentDate];
            [personsString appendFormat:@"%@\n\n", dateString];
            
            // Generate String to represent the state of the checklist
            NSData *unarchiveGroupsData = [[NSUserDefaults standardUserDefaults] objectForKey:@"groups"];
            NSArray *personsArray = [NSKeyedUnarchiver unarchiveObjectWithData:unarchiveGroupsData];
            for (Group *group in self.groupsList) {
                [personsString appendFormat:@"%@: \n", group.groupName];
                NSArray *currentGroup = [personsArray objectAtIndex:group.personListArrayIndex];
                for (Person *currentPerson in currentGroup) {
                    if(currentPerson.checked)
                        [personsString appendFormat:@"   %@ \n", currentPerson.personName];
                }
                [personsString appendFormat:@"\n"];
            }
            
            SaveFile *saveFile = [[SaveFile alloc] init];
            saveFile.dateCreated = currentDate;
            saveFile.personsList = personsString;
            [archiveArray insertObject:saveFile atIndex:0];
            // Save data
            NSData *archiveArchivesData = [NSKeyedArchiver archivedDataWithRootObject:archiveArray];
            [[NSUserDefaults standardUserDefaults] setObject:archiveArchivesData forKey:@"saveFiles"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            // Prompt that Save action occurred
            UIAlertView *successPrompt = [[UIAlertView alloc] initWithTitle:@"Saved" message:@"Attendance has been saved" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [successPrompt show];
        }
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"SegueGroupSelected"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        PersonListViewController *destViewController = segue.destinationViewController;
        Group *selectedGroup = [self.groupsList objectAtIndex:(indexPath.row - 1)];
        destViewController.currentGroupNum = selectedGroup.personListArrayIndex;
        //NSLog(@"%@ pointer %lul", selectedGroup.groupName, selectedGroup.personListArrayIndex);
    }
}

@end
