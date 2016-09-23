//
//  ArchiveReaderViewController.m
//  PersonChecklist
//
//  Created by Jones Sagabaen on 9/3/15.
//  Copyright (c) 2015 Jones Sagabaen. All rights reserved.
//

#import "SaveReaderViewController.h"

@interface SaveReaderViewController ()

@end

@implementation SaveReaderViewController

@synthesize mainTextView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set the text received from segue
    [mainTextView setText:self.segueText];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
