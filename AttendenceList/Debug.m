//
//  Debug.m
//  PersonChecklist
//
//  Created by Jones Sagabaen on 9/24/15.
//  Copyright © 2015 Jones Sagabaen. All rights reserved.
//

#import "Debug.h"
#import "Group.h"
#import "Person.h"
#import "SaveFile.h"

@implementation Debug

// Static method to load placeholder data
// Enable the use of method in the AppDeletegate.m class
+ (void)loadPlaceholderData {
    /////////////////////////////////////////////////////////////////////////////////
    // Populate GroupsTableViewController data
    /////////////////////////////////////////////////////////////////////////////////
    NSMutableArray *groupsList = [[NSMutableArray alloc] init];
    
    Group *group1 = [[Group alloc] init];
    group1.groupName = @"Group A-E";
    group1.personListArrayIndex = 0;
    [groupsList addObject:group1];
    Group *group2 = [[Group alloc] init];
    group2.groupName = @"Group F-I";
    group2.personListArrayIndex = 1;
    [groupsList addObject:group2];
    Group *group3 = [[Group alloc] init];
    group3.groupName = @"Group J-M";
    group3.personListArrayIndex = 2;
    [groupsList addObject:group3];
    Group *group4 = [[Group alloc] init];
    group4.groupName = @"Group N-Q";
    group4.personListArrayIndex = 3;
    [groupsList addObject:group4];
    Group *group5 = [[Group alloc] init];
    group5.groupName = @"Group R-U";
    group5.personListArrayIndex = 4;
    [groupsList addObject:group5];
    
    NSData *groupListData = [NSKeyedArchiver archivedDataWithRootObject:groupsList];
    [[NSUserDefaults standardUserDefaults] setObject:groupListData forKey:@"groupsList"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSLog(@"GroupsTableViewController: Placeholder data has been loaded");
    
    /////////////////////////////////////////////////////////////////////////////////
    // Populate PersonListViewController data
    /////////////////////////////////////////////////////////////////////////////////
    NSMutableArray *groupsArray = [[NSMutableArray alloc] init];
    
    //Group 1
    NSMutableArray *personsArray1 = [[NSMutableArray alloc] init];
    // Populate persons array with placeholder items
    Person *person1 = [[Person alloc] init];
    person1.personName = @"Adam Arlington";
    [personsArray1 addObject:person1];
    Person *person2 = [[Person alloc] init];
    person2.personName = @"Brenda Burton";
    [personsArray1 addObject:person2];
    Person *person3 = [[Person alloc] init];
    person3.personName = @"Claire Conner";
    [personsArray1 addObject:person3];
    Person *person4 = [[Person alloc] init];
    person4.personName = @"Duke Dunbar";
    [personsArray1 addObject:person4];
    Person *person5 = [[Person alloc] init];
    person5.personName = @"Ellen Eisenberg";
    [personsArray1 addObject:person5];
    [groupsArray addObject:personsArray1];
    
    //Group 2
    NSMutableArray *personsArray2 = [[NSMutableArray alloc] init];
    // Populate persons array with placeholder items
    Person *person6 = [[Person alloc] init];
    person6.personName = @"Fredric Founder";
    [personsArray2 addObject:person6];
    Person *person7 = [[Person alloc] init];
    person7.personName = @"George Grant";
    [personsArray2 addObject:person7];
    Person *person8 = [[Person alloc] init];
    person8.personName = @"Harley Hearst";
    [personsArray2 addObject:person8];
    Person *person9 = [[Person alloc] init];
    person9.personName = @"Ishmael Ishimaru";
    [personsArray2 addObject:person9];
    [groupsArray addObject:personsArray2];
    
    //Group 3
    NSMutableArray *personsArray3 = [[NSMutableArray alloc] init];
    // Populate persons array with placeholder items
    Person *person10 = [[Person alloc] init];
    person10.personName = @"James Johnson";
    [personsArray3 addObject:person10];
    Person *person11 = [[Person alloc] init];
    person11.personName = @"Kurtis Keiser";
    [personsArray3 addObject:person11];
    Person *person12 = [[Person alloc] init];
    person12.personName = @"Linda Long";
    [personsArray3 addObject:person12];
    Person *person13 = [[Person alloc] init];
    person13.personName = @"Marshal Morningside";
    [personsArray3 addObject:person13];
    [groupsArray addObject:personsArray3];
    
    //Group 4
    NSMutableArray *personsArray4 = [[NSMutableArray alloc] init];
    // Populate persons array with placeholder items
    Person *person14 = [[Person alloc] init];
    person14.personName = @"Nancy Nielson";
    [personsArray4 addObject:person14];
    Person *person15 = [[Person alloc] init];
    person15.personName = @"Olivia Olum";
    [personsArray4 addObject:person15];
    Person *person16 = [[Person alloc] init];
    person16.personName = @"Peter Parker";
    [personsArray4 addObject:person16];
    Person *person17 = [[Person alloc] init];
    person17.personName = @"Quentin Quest";
    [personsArray4 addObject:person17];
    [groupsArray addObject:personsArray4];
    
    //Group 5
    NSMutableArray *personsArray5 = [[NSMutableArray alloc] init];
    // Populate persons array with placeholder items
    Person *person18 = [[Person alloc] init];
    person18.personName = @"Rudy Rudd";
    [personsArray5 addObject:person18];
    Person *person19 = [[Person alloc] init];
    person19.personName = @"Stacy Stanis";
    [personsArray5 addObject:person19];
    Person *person20 = [[Person alloc] init];
    person20.personName = @"Todd Tucker";
    [personsArray5 addObject:person20];
    Person *person21 = [[Person alloc] init];
    person21.personName = @"Ulysses Umbra";
    [personsArray5 addObject:person21];
    [groupsArray addObject:personsArray5];
    
    NSData *groupData = [NSKeyedArchiver archivedDataWithRootObject:groupsArray];
    [[NSUserDefaults standardUserDefaults] setObject:groupData forKey:@"groups"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSLog(@"PersonListViewController: Placeholder data has been loaded");
    
    /////////////////////////////////////////////////////////////////////////////////
    // Populate HistoryTableViewController data
    /////////////////////////////////////////////////////////////////////////////////
    NSMutableArray *saveArray = [[NSMutableArray alloc] init];
    
    NSDate *currentDate = [NSDate date];
    NSString *personsString1 = @"Welcome\n\nAll saved attendance lists can be viewed at this History view.  To add a new entry to this list, select the Save button found at the Attendance view.";
    SaveFile *saveFile1 = [[SaveFile alloc] init];
    saveFile1.dateCreated = currentDate;
    saveFile1.personsList = personsString1;
    [saveArray insertObject:saveFile1 atIndex:0];
    
    NSData *saveData = [NSKeyedArchiver archivedDataWithRootObject:saveArray];
    [[NSUserDefaults standardUserDefaults] setObject:saveData forKey:@"saveFiles"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSLog(@"HistoryTableViewController: Placeholder data has been loaded");
}

@end
