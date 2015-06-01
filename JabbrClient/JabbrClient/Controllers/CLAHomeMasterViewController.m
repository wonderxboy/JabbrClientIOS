//
//  CLAHomeMasterViewController.m
//  Collara
//
//  Created by Sean on 31/05/15.
//  Copyright (c) 2015 Collara. All rights reserved.
//

#import "CLAHomeMasterViewController.h"

//Util
#import "Constants.h"

//Menu
#import "UIViewController+ECSlidingViewController.h"
#import "SlidingViewController.h"

//View Controller
#import "CLAHomeTopicViewController.h"
#import "CLAHomeMemberViewController.h"

@interface CLAHomeMasterViewController ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *menuItem;
@end

@implementation CLAHomeMasterViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.skipIntermediateViewControllers = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self subscribNotifications];
    [self initUI];
}

- (void)dealloc {
    [self unsubscribNotifications];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark -
#pragma mark Notifications
- (void)subscribNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showCreateTeamView) name:kEventNoTeam object:nil];
}

- (void)unsubscribNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)initUI {
    [self.menuItem setTitle:@""];
    [self.menuItem setWidth:30];
    [self.menuItem setImage: [Constants menuIconImage]];
}

#pragma mark -
#pragma mark - Event Handlers

- (IBAction)leftMenuClicked:(id)sender {
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
}


#pragma mark -
#pragma mark View Controller Event Handlers

- (void)showCreateTeamView {
    SlidingViewController *slidingViewController = (SlidingViewController *)self.slidingViewController;
    [slidingViewController switchToCreateTeamView];
}

#pragma mark - XLPagerTabStripViewControllerDataSource

-(NSArray *)childViewControllersForPagerTabStripViewController:(XLPagerTabStripViewController *)pagerTabStripViewController
{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:kMainStoryBoard bundle: nil];
    
    CLAHomeTopicViewController *homeTopicViewController = [storyBoard instantiateViewControllerWithIdentifier:kHomeTopicViewController];
    
    CLAHomeMemberViewController *homeMemberViewController = [storyBoard instantiateViewControllerWithIdentifier:kHomeMemberViewController];
    
    return @[homeTopicViewController, homeMemberViewController];
}

@end
