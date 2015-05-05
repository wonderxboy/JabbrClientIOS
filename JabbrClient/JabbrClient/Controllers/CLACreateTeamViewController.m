//
//  CLACreateTeamViewController.m
//  Collara
//
//  Created by Sean on 05/05/15.
//  Copyright (c) 2015 Collara. All rights reserved.
//

#import "CLACreateTeamViewController.h"
#import "Constants.h"
#import "CLAToastManager.h"
@interface CLACreateTeamViewController ()

@property (nonatomic, strong) NSMutableDictionary *toasOptions;

@property (weak, nonatomic) IBOutlet UITextField *teamNameTextField;

@end

@implementation CLACreateTeamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupNavBar {
    
    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), kStatusBarHeight)];
    navBar.barTintColor = [Constants mainThemeColor];
    navBar.translucent = NO;
    navBar.titleTextAttributes = @{ NSForegroundColorAttributeName : [UIColor whiteColor] };
    
    UINavigationItem *navItem = [[UINavigationItem alloc] init];
    navItem.title = @"Create Your Team";
    [navBar setItems:@[navItem]];
    
    [self.view addSubview:navBar];
}

- (IBAction)createTeamClicked:(id)sender {
    
    if (self.teamNameTextField.text == nil || self.teamNameTextField.text.length == 0) {
        
        [CLAToastManager showDefaultInfoToastWithText:@"Oh, an empty name. That will not work." completionBlock:nil];
    }
    else if (self.teamNameTextField.text.length > kTeamNameMaxLength) {
        
        [CLAToastManager showDefaultInfoToastWithText:[NSString stringWithFormat:@"Awww, do you really need more than %d characters for your team name?", kTeamNameMaxLength ]completionBlock:nil];
    }
    else {
        
        [self.messagClient createTeam:(NSString *)@"" completionBlock: ^(NSError *error){
            
            if (error == nil) {
                
                [self dismissViewControllerAnimated:YES completion: ^{
                    [self.messagClient invokeGetTeam];
                }];
                
            }
            else {
                
                //TODO: define error code
                [CLAToastManager showDefaultInfoToastWithText: [NSString stringWithFormat:@"Oh, \"%@\" is taken. Try you luck with a new name.", self.teamNameTextField.text] completionBlock:nil];
            }
        
        }];
    }
    
}

@end
