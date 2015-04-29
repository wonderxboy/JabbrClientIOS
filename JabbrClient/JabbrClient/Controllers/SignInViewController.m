//
//  SignInViewController.m
//  JabbrClient
//
//  Created by Sean on 06/04/15.
//  Copyright (c) 2015 Colla. All rights reserved.
//

#import "SignInViewController.h"
#import "AuthManager.h"
#import "UIViewController+ECSlidingViewController.h"
#import "Constants.h"
#import "SlidingViewController.h"
#import "CLANotificationHandler.h"
#import "CLASignUpViewController.h"
#import "CRToast.h"

@interface SignInViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *signInButton;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;

@end

@implementation SignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setButtonBorder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    CLANotificationHandler *notificationHandler = [[CLANotificationHandler alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:notificationHandler selector:@selector(keyboardWillShow:withView:) name:UIKeyboardWillShowNotification object:self.view];
    [[NSNotificationCenter defaultCenter] addObserver:notificationHandler selector:@selector(keyboardWillHide:withView:) name:UIKeyboardWillHideNotification object:self.view];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark -
#pragma mark - Set Button

- (void)setButtonBorder {
    [[self.signInButton layer] setCornerRadius:5.0f];
    [[self.signInButton layer] setMasksToBounds:YES];
    [[self.signInButton layer] setBorderWidth:1.0f];
    [[self.signInButton layer] setBorderColor:[UIColor whiteColor].CGColor];
    
    [[self.signUpButton layer] setCornerRadius:5.0f];
    [[self.signUpButton layer] setMasksToBounds:YES];
    [[self.signUpButton layer] setBorderWidth:1.0f];
    [[self.signUpButton layer] setBorderColor:[UIColor whiteColor].CGColor];

}

#pragma mark -
#pragma mark - Event Handler
- (IBAction)signInClicked:(id)sender {
    //TOOD: check user name and password
    NSMutableDictionary *toasOptions = [Constants toasOptions].mutableCopy;
    toasOptions[kCRToastImageKey] = [Constants infoIconImage];
    
    NSString *username = [self.usernameTextField text];
    NSString *password = [self.passwordTextField text];
    
    if (username == nil || username.length == 0) {
        
        [toasOptions setObject:@"Did you forget your username?" forKey:kCRToastTextKey];
        [CRToastManager showNotificationWithOptions:toasOptions
                                    completionBlock:nil];
        
        return;
    }
    
    if (password == nil || password.length == 0) {
        
        [toasOptions setObject:@"OK, that password won't work." forKey:kCRToastTextKey];
        [CRToastManager showNotificationWithOptions:toasOptions
                                    completionBlock:nil];
        
        return;
    }
    
    [[AuthManager sharedInstance]signInWithUsername:username
                                           password:password
                                         completion:^(NSError *error){
        [self processSignInResult:error];
    }];
    
}

- (IBAction)signUpClicked:(id)sender {
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    
    CLASignUpViewController *signUpViewController = [storyBoard instantiateViewControllerWithIdentifier:kSignUpController];
    [self presentViewController:signUpViewController animated:TRUE completion:nil];
}


- (void)processSignInResult: (NSError *)error {
    if (!error) {
        [self switchToMainView];
    }
    else {
        //TODO: show error on UI
        NSLog(@"Sign in error, error domain: %@, error code: %ld", error.domain, (long)error.code);
    }
}

- (void)switchToMainView {
    [((SlidingViewController *)self.navigationController.slidingViewController) switchToMainView];
}

@end
