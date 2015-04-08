//
//  RightMenuViewController.hViewController
//  JabbrClient
//
//  Created by Sean on 31/03/15.
//  Copyright (c) 2015 Colla. All rights reserved.
//

#import "RightMenuViewController.h"
#import "UIViewController+ECSlidingViewController.h"
#import "DocumentViewController.h"
#import "DemoData.h"
#import "DocumentThread+Category.h"
#import "Constants.h"
#import "SlidingViewController.h"

static NSString * const kDoc = @"doc";

@interface RightMenuViewController ()
@property (nonatomic, strong) NSArray *documentThreads;
@property (nonatomic, strong) NSMutableDictionary *controllers;
@end

@implementation RightMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.controllers = [NSMutableDictionary dictionaryWithCapacity:self.documentThreads.count];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

#pragma mark - Properties

- (NSArray *)documentThreads {
    return[DemoData sharedDemoData].documentThreads;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.documentThreads.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"MenuCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    DocumentThread *documentThread = self.documentThreads[indexPath.row];
    
    cell.textLabel.text = [documentThread getDisplayTitle] ;
    [cell setBackgroundColor:[UIColor clearColor]];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UINavigationController *navController = [((SlidingViewController *)self.slidingViewController) setTopNavigationControllerWithKeyIdentifier: kDocumentNavigationController];
    
    DocumentViewController *documentViewController = [navController.viewControllers objectAtIndex:0];
    
    if (documentViewController != nil) {
        [documentViewController loadDocumentThread:self.documentThreads[indexPath.row]];
    }
    
    [navController.view addGestureRecognizer:self.slidingViewController.panGesture];
    [self.slidingViewController resetTopViewAnimated:YES];
}

@end
