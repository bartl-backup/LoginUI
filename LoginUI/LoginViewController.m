//
//  LoginViewController.m
//  photomovie
//
//  Created by Evgeny Rusanov on 30.10.12.
//  Copyright (c) 2012 Macsoftex. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"

#import "LoginWindow.h"
#import "TDTextFieldCell.h"

#import "MBProgressHUD.h"

@implementation LoginViewController
{
    __weak LoginWindow *loginWindow;
}

-(id)initWithLoginWindow:(LoginWindow*)lWindow
{
    TDRoot *root = [[TDRoot alloc] initWithTitle:NSLocalizedString(@"Login",@"")];
    self = [super initWithRoot:root tableViewStyle:UITableViewStyleGrouped];
    if (self) {
        TDSection *userCredentials = [TDSection sectionWithTitle:@""];
        
        [userCredentials addElement:[TDTextFieldElement textFieldElementWithPlaceholder:NSLocalizedString(@"Email", @"")
                                                                               andValue:@""
                                                                                 andKey:@"login"]];
        TDTextFieldElement *passwordElement = [TDTextFieldElement textFieldElementWithPlaceholder:NSLocalizedString(@"Password",@"")
                                                                                         andValue:@""
                                                                                           andKey:@"password"];
        passwordElement.isSecure = YES;
        [userCredentials addElement:passwordElement];
        [root addSection:userCredentials];
        
        
        TDSection *buttonsSection = [TDSection sectionWithTitle:@""];
        TDButtonElement *loginButton = [TDButtonElement buttonElementWithTitle:NSLocalizedString(@"Login", @"")];
        loginButton.didSelectHandler = ^(TDElement *element){
            [MBProgressHUD showHUDAddedTo:self.view animated:NO];
            [self.view endEditing:YES];
            self.tableView.scrollEnabled = NO;
            
            [self.navigationItem setRightBarButtonItem:nil animated:YES];
            
            if (!loginWindow.loginBlock) return;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                loginWindow.loginBlock([self.root elementsValues],
                                       ^(BOOL logged)
                                       {
                                           self.tableView.scrollEnabled = YES;
                                           [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                           
                                           if (logged)
                                           {
                                               if (loginWindow.endLoginBlock)
                                                   loginWindow.endLoginBlock(nil);
                                               [loginWindow dismiss];
                                           }
                                           else
                                               [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Register", @"")
                                                                                                                           style:UIBarButtonItemStyleDone
                                                                                                                          target:self
                                                                                                                          action:@selector(registerClick)]
                                                                                 animated:YES];
                                       });
            });
        };
        [buttonsSection addElement:loginButton];
        [root addSection:buttonsSection];
        
        loginWindow = lWindow;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                          target:self
                                                                                          action:@selector(cancelClick)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Register", @"")
                                                                              style:UIBarButtonItemStyleDone
                                                                             target:self
                                                                             action:@selector(registerClick)];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    TDSection *section = [[self.root sections] objectAtIndex:0];
    TDTextFieldElement *login = [[section elements] objectAtIndex:0];
    TDTextFieldElement *passw = [[section elements] objectAtIndex:1];
    
    TDTextFieldCell *cell;
    
    if (login.value.length==0)
        cell = (TDTextFieldCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    else if (passw.value.length == 0)
        cell = (TDTextFieldCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    else
        cell = (TDTextFieldCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    [cell setInputFocus];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

-(void)cancelClick
{
    if (loginWindow.cancelLoginBlock)
        loginWindow.cancelLoginBlock();
    
    [loginWindow dismiss];
}

-(void)registerClick
{
    RegisterViewController *registerViewController = [[RegisterViewController alloc] initWithLoginWindow:loginWindow];
    [self.navigationController pushViewController:registerViewController animated:YES];
}

@end
