//
//  PersonListViewController.m
//  PersonChecklist
//
//  Created by Jones Sagabaen on 8/20/15.
//  Copyright (c) 2015 Jones Sagabaen. All rights reserved.
//

#import "PersonListViewController.h"
#import "Person.h"

@interface PersonListViewController ()

@property UITextField *alertTextField;

@end

@implementation PersonListViewController

@synthesize currentGroupNum;

#pragma mark - Helper methods

- (void)viewDidLoad {
    [super viewDidLoad];
    // Initialize Group array
    self.groupsArray = [[NSMutableArray alloc] init];
    [self loadData];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.navigationItem.leftBarButtonItem = nil;
    
    // Workaround to hide empty table cells
    self.tableView.tableFooterView = [UIView new];
    
//    // Have view load with action cells hidden
//    self.automaticallyAdjustsScrollViewInsets = NO;
}

// DEBUG: Still needs works
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
    NSData *groupData = [NSKeyedArchiver archivedDataWithRootObject:self.groupsArray];
    [[NSUserDefaults standardUserDefaults] setObject:groupData forKey:@"groups"];
    [[NSUserDefaults standardUserDefaults] synchronize];
//    NSLog(@"Data saved");
}

// Load data
- (void)loadData {
    // Load saved data
    NSData *groupsData = [[NSUserDefaults standardUserDefaults] objectForKey:@"groups"];
    self.groupsArray = [NSKeyedUnarchiver unarchiveObjectWithData:groupsData];
    //    NSLog(@"Data loaded");
    
    // Prompt to populate list since no data is found in this list
    if([self.groupsArray count] <= 1) {
        [self addButtonAction:self];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    NSMutableArray *currentGroup = [self.groupsArray objectAtIndex:self.currentGroupNum];
    return [currentGroup count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UncheckAllCell"];
        cell.accessoryType = UITableViewCellAccessoryNone;
        return cell;
    }
    else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PersonListPrototypeCell" forIndexPath:indexPath];
        // Disable row selection highlight during row touch
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        // Get group array element and set text label
        NSMutableArray *currentGroup = [self.groupsArray objectAtIndex:self.currentGroupNum];
        Person *person = [currentGroup objectAtIndex:(indexPath.row - 1)];
        cell.textLabel.text = person.personName;
        
        // Toggle person has been checked
        if (person.checked) {
            // Set checkmark
            UIImageView *accessoryImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"placeholderCheck"]];
            accessoryImage.frame = CGRectMake(cell.accessoryView.frame.origin.x, cell.accessoryView.frame.origin.y, 20, 20);
            cell.accessoryView = accessoryImage;
            
            // Get user preference
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            int settingsColorInt = (int) [defaults integerForKey:@"highlightColor"];
            
            // Set highlight color and text combination
            switch (settingsColorInt) {
                case 1:
                    cell.backgroundColor = [UIColor greenColor];
                    cell.textLabel.textColor = [UIColor grayColor];
                    break;
                case 2:
                    cell.backgroundColor = [UIColor blueColor];
                    cell.textLabel.textColor = [UIColor whiteColor];
                    break;
                case 3:
                    cell.backgroundColor = [UIColor cyanColor];
                    cell.textLabel.textColor = [UIColor grayColor];
                    break;
                case 4:
                    cell.backgroundColor = [UIColor yellowColor];
                    cell.textLabel.textColor = [UIColor blackColor];
                    break;
                case 5:
                    cell.backgroundColor = [UIColor magentaColor];
                    cell.textLabel.textColor = [UIColor whiteColor];
                    break;
                case 6:
                    cell.backgroundColor = [UIColor orangeColor];
                    cell.textLabel.textColor = [UIColor whiteColor];
                    break;
                case 7:
                    cell.backgroundColor = [UIColor purpleColor];
                    cell.textLabel.textColor = [UIColor whiteColor];
                    break;
                case 8:
                    cell.backgroundColor = [UIColor brownColor];
                    cell.textLabel.textColor = [UIColor whiteColor];
                    break;
                    
                default:
                    //cell.backgroundColor = [UIColor colorWithRed:(253/255.0) green:(188/255.0) blue:(180/255.0) alpha:1];
                    cell.backgroundColor = [UIColor whiteColor];
                    cell.textLabel.textColor = [UIColor blackColor];
                    break;
            }
        } else {
            // Set uncheckmark
            UIImageView *accessoryImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"placeholderUncheck"]];
            accessoryImage.frame = CGRectMake(cell.accessoryView.frame.origin.x, cell.accessoryView.frame.origin.y, 20, 20);
            cell.accessoryView = accessoryImage;
            
            // Assure row highlight disappears
            cell.backgroundColor = [UIColor whiteColor];
            cell.textLabel.textColor = [UIColor blackColor];
        }
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
        // Delete the row from the data source
        NSMutableArray *currentGroup = [self.groupsArray objectAtIndex:self.currentGroupNum];
        [currentGroup removeObjectAtIndex:(indexPath.row - 1)];
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
        // Exclude Uncheck Group cell
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
        [self.navigationItem setLeftBarButtonItem:self.addButton];
        
//        // Hide Uncheck Group cell text
//        NSMutableArray *currentGroup = [self.groupsArray objectAtIndex:self.currentGroupNum];
//        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[currentGroup count] inSection:0];
//        UITableViewCell *currentCell = [self.tableView cellForRowAtIndexPath:indexPath];
//        //currentCell.backgroundColor = [UIColor whiteColor];
//        currentCell.textLabel.textColor = [UIColor lightGrayColor];
    }
    // Exited editing mode
    else {
        self.navigationItem.leftBarButtonItem = nil;
        
//        // Unhide Uncheck Group cell
//        NSMutableArray *currentGroup = [self.groupsArray objectAtIndex:self.currentGroupNum];
//        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[currentGroup count] inSection:0];
//        UITableViewCell *currentCell = [self.tableView cellForRowAtIndexPath:indexPath];
//        currentCell.backgroundColor = [UIColor lightGrayColor];
//        currentCell.textLabel.textColor = [UIColor whiteColor];
    }
}

#pragma mark - Custom table rearranging

// Support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    // Rearrange cells and save changes to data model
    NSMutableArray *currentGroup = [self.groupsArray objectAtIndex:self.currentGroupNum];
    NSString *stringToMove = [currentGroup objectAtIndex:(fromIndexPath.row - 1)];
    [currentGroup removeObjectAtIndex:(fromIndexPath.row - 1)];
    [currentGroup insertObject:stringToMove atIndex:(toIndexPath.row - 1)];
    [self saveData];
}

// Set rows that are reaarangable
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) // Don't move the Uncheck Group row
        return NO;
    else
        return YES;
}

// Allows rearranging of table cells excluding the last Uncheck Group cell
- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath {
    // Test whether destination is allowed
    NSMutableArray *currentGroup = [self.groupsArray objectAtIndex:self.currentGroupNum];
    if (proposedDestinationIndexPath.row > 1 && proposedDestinationIndexPath.row < [currentGroup count] + 1) {
        return proposedDestinationIndexPath;    // If allowed move to proposed destination
    }
    else {
        return sourceIndexPath;                 // Else, send back to where it came from!
    }
}

#pragma mark - Button actions

// Action for editing mode's add button
- (IBAction)addButtonAction:(id)sender {
    UIAlertView *createPersonPrompt = [[UIAlertView alloc] initWithTitle:@"Create Person" message:@"Enter the person's name to add to this group" delegate:self cancelButtonTitle:@"Submit" otherButtonTitles:nil];
    createPersonPrompt.tag = 100;
    createPersonPrompt.alertViewStyle = UIAlertViewStylePlainTextInput;
    self.alertTextField = [createPersonPrompt textFieldAtIndex:0];
    self.alertTextField.keyboardType = UIKeyboardTypeDefault;
    self.alertTextField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    self.alertTextField.placeholder = @"Full name";
    [createPersonPrompt show];
}

// Action for the various Alert prompts
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    // Action for Add button
    if (alertView.tag == 100) {
        if ([self.alertTextField.text length] <= 0){
            return;     //If cancel or 0 length string the string doesn't matter
        }
        else {
            // Add to the persons array
            Person *newPerson = [[Person alloc] init];
            newPerson.personName = self.alertTextField.text;
            NSMutableArray *currentGroup = [self.groupsArray objectAtIndex:self.currentGroupNum];
            [currentGroup addObject:newPerson];
            [self saveData];
            [self.tableView reloadData];        }
    }
    // Action for the Uncheck Group cell
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
            for (Person *person in [groupsArray objectAtIndex:self.currentGroupNum]) {
                // NSLog(@"%@ %d", person.personName, person.checked);
                person.checked = NO;
            }
            // Save groups array
            NSData *archiveGroupsData = [NSKeyedArchiver archivedDataWithRootObject:groupsArray];
            [[NSUserDefaults standardUserDefaults] setObject:archiveGroupsData forKey:@"groups"];
            [[NSUserDefaults standardUserDefaults] synchronize];

            // Prompt that Uncheck Group action has occurred
            UIAlertView *successPrompt = [[UIAlertView alloc] initWithTitle:@"Cleared" message:@"All checkboxes have been unchecked for this group" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [successPrompt show];
            
            // Refresh table by backing out of current view
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Action for selecting the Uncheck Group cell
    if(indexPath.row == 0) {
        // Confirm action
        UIAlertView *confirmationPrompt = [[UIAlertView alloc] initWithTitle:@"Confirm" message:@"Are you sure you would like to uncheck all boxes for this group?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
        confirmationPrompt.tag = 200;
        [confirmationPrompt show];
    }
    // Action for person highlight
    else {
        [tableView deselectRowAtIndexPath:indexPath animated:NO];                                       //Deselect cell after selected
        NSMutableArray *currentGroup = [self.groupsArray objectAtIndex:self.currentGroupNum];
        Person *person = [currentGroup objectAtIndex:(indexPath.row - 1)];                              //Communicate with corresponding array item
        person.checked = !person.checked;                                                               //Toggle the state of the selected row
        [self saveData];
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];   //Refresh row
    }
}

@end
