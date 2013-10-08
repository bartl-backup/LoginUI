//
//  RegisterViewController.m
//  photomovie
//
//  Created by Evgeny Rusanov on 02.11.12.
//  Copyright (c) 2012 Macsoftex. All rights reserved.
//

#import "RegisterViewController.h"
#import "LoginWindow.h"

#import "TDTextFieldCell.h"

#import "MBProgressHUD.h"

@implementation RegisterViewController
{
    LoginWindow *loginWindow;
    
    TDTextFieldElement *passw1;
    TDTextFieldElement *passw2;
    TDTextFieldElement *login;
}

-(id)initWithLoginWindow:(LoginWindow*)lWindow
{
    TDRoot *root = [[TDRoot alloc] initWithTitle:NSLocalizedString(@"Register",@"")];
    self = [super initWithRoot:root tableViewStyle:UITableViewStyleGrouped];
    if (self)
    {
        TDSection *loginSection = [TDSection sectionWithTitle:@""];
        login = [TDTextFieldElement textFieldElementWithPlaceholder:NSLocalizedString(@"Email", @"")
                                                           andValue:@"" andKey:@"login"];
        [loginSection addElement:login];
        [root addSection:loginSection];
        
        TDSection *passwordSection = [TDSection sectionWithTitle:@""];
        passw1 = [TDTextFieldElement textFieldElementWithPlaceholder:NSLocalizedString(@"Password",@"") andValue:@"" andKey:@"password"];
        passw2 = [TDTextFieldElement textFieldElementWithPlaceholder:NSLocalizedString(@"Confirm",@"") andValue:@""];
        passw1.isSecure = YES;
        passw2.isSecure = YES;
        [passwordSection addElement:passw1];
        [passwordSection addElement:passw2];
        [root addSection:passwordSection];
        
        loginWindow = lWindow;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                          target:self
                                                                                          action:@selector(cancelClick)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                           target:self
                                                                                           action:@selector(registerClick)];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
       
    TDTextFieldCell *cell;
    cell = (TDTextFieldCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [cell setInputFocus];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (void)registerClick
{
    if (login.value.length == 0)
    {
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Enter email", @"")
                                    message:nil
                                   delegate:nil
                          cancelButtonTitle:NSLocalizedString(@"Ok", @"")
                          otherButtonTitles:nil] show];
        TDTextFieldCell *cell;
        cell = (TDTextFieldCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        [cell setInputFocus];
        return;
    }
    
    if (passw1.value.length == 0)
    {
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Enter password", @"")
                                    message:nil
                                   delegate:nil
                          cancelButtonTitle:NSLocalizedString(@"Ok", @"")
                          otherButtonTitles:nil] show];
        TDTextFieldCell *cell;
        cell = (TDTextFieldCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        [cell setInputFocus];
        return;
    }
    
    if (![passw2.value isEqualToString:passw1.value])
    {
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Passwords don't match", @"")
                                   message:nil
                                  delegate:nil
                         cancelButtonTitle:NSLocalizedString(@"Ok", @"")
                         otherButtonTitles:nil] show];
        TDTextFieldCell *cell;
        cell = (TDTextFieldCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
        [cell setInputFocus];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    self.tableView.scrollEnabled = NO;
    
    if (!loginWindow.registerBlock) return;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        loginWindow.registerBlock(self.root.elementsValues,
                                  ^(BOOL registered)
                                  {
                                      [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                      self.tableView.scrollEnabled = YES;
                                      
                                      [self.navigationItem setRightBarButtonItem:nil animated:YES];
                                      
                                      if (registered)
                                      {
                                          [loginWindow dismiss];
                                          if (loginWindow.endLoginBlock)
                                              loginWindow.endLoginBlock(nil);
                                      }
                                      else
                                          [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Register", @"")
                                                                                                                      style:UIBarButtonItemStyleDone
                                                                                                                     target:self
                                                                                                                     action:@selector(registerClick)]
                                                                            animated:YES];
                                  });
    });
}

- (void)cancelClick
{
    if (loginWindow.cancelRegisterBlock)
        loginWindow.cancelRegisterBlock();
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
