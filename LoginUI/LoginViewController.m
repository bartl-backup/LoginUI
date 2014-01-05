//
//  LoginViewController.m
//  photomovie
//
//  Created by Evgeny Rusanov on 30.10.12.
//  Copyright (c) 2012 Macsoftex. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"

#import "Authorizator.h"

#import "BlockAlertView.h"
#import "ErrorAlertView.h"

#import "LoginWindow.h"
#import "TDTextFieldCell.h"

#import "MBProgressHUD.h"

@implementation LoginViewController
{
    __weak LoginWindow *_loginWindow;
}

-(LoginWindow*)loginWindow
{
    return _loginWindow;
}

-(id)initWithLoginWindow:(LoginWindow*)lWindow
{
    TDRoot *root = [[TDRoot alloc] initWithTitle:NSLocalizedString(@"Login",@"")];
    self = [super initWithRoot:root tableViewStyle:UITableViewStyleGrouped];
    if (self) {
        _loginWindow = lWindow;
    }
    return self;
}

-(void)addFields:(TDRoot*)root
{
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
}

-(void)addButtons:(TDRoot*)root
{
    TDSection *buttonsSection = [TDSection sectionWithTitle:@""];
    
    __weak typeof(self) pself = self;
    
    TDButtonElement *loginButton = [TDButtonElement buttonElementWithTitle:NSLocalizedString(@"Login", @"")];
    loginButton.didSelectHandler = ^(TDElement *element){
        MBProgressHUD *hud = [pself showHud];
        
        if (!pself.loginWindow.loginBlock) return;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            pself.loginWindow.loginBlock([pself.root elementsValues],
                                         ^(BOOL logged)
                                         {
                                             [pself hideHud:hud];
                                             
                                             if (logged)
                                             {
                                                 [pself loginComplete];
                                             }
                                         });
        });
    };
    [buttonsSection addElement:loginButton];
    
    TDButtonElement *forgotPassword = [TDButtonElement buttonElementWithTitle:NSLocalizedString(@"Forgot password", @"")];
    forgotPassword.didSelectHandler = ^(TDElement *element)
    {
        BlockAlertView *alert = [[BlockAlertView alloc] initWithTitle:NSLocalizedString(@"Enter email", @"")
                                                              message:nil];
        alert.style = UIAlertViewStylePlainTextInput;
        [alert addButton:NSLocalizedString(@"Cancel", @"") withBlock:nil];
        [alert addButton:NSLocalizedString(@"Ok", @"") withBlock:^(BlockAlertView *alert) {
            NSString *email = [alert textFieldAtIndex:0].text;
            if (pself.loginWindow.forgotPassword)
                pself.loginWindow.forgotPassword(email);
            double delayInSeconds = 0.1;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [[[UIAlertView alloc] initWithTitle:nil
                                            message:NSLocalizedString(@"Your password will be send to specified email", @"")
                                           delegate:nil
                                  cancelButtonTitle:NSLocalizedString(@"Ok", @"")
                                  otherButtonTitles:nil] show];
            });
        }];
        alert.cancelButtonIndex = 0;
        [alert show];
    };
    [buttonsSection addElement:forgotPassword];
    
    [root addSection:buttonsSection];
}

-(void)addAuthorizators:(TDRoot*)root
{
    if (self.loginWindow.authorizators.count)
    {
        TDSection *loginWithSection = [TDSection sectionWithTitle:NSLocalizedString(@"Login with", @"")];
        for (Authorizator *authorizator in self.loginWindow.authorizators)
        {
            [self addAuthorizator:authorizator to:loginWithSection];
        }
        [root addSection:loginWithSection];
    }
}

-(void)addAuthorizator:(Authorizator*)authorizator to:(TDSection*)section
{
    __weak typeof(self) pself = self;
    
    TDImageElement *imageElement = [TDImageElement imageElementWithText:[authorizator title]
                                                               andValue:nil
                                                               andImage:[authorizator image]];
    imageElement.didSelectHandler = ^(TDElement* element)
    {
        MBProgressHUD *hud = [pself showHud];
        [authorizator authorize:^(NSDictionary *userData, NSError *error) {
            if (!error)
            {
                if (pself.loginWindow.authorizeWith)
                    pself.loginWindow.authorizeWith(userData, ^(BOOL logged){
                        [pself hideHud:hud];
                        
                        if (logged)
                            [pself loginComplete];
                    });
            }
            else
            {
                [ErrorAlertView showError:error realError:YES];
                [pself hideHud:hud];
            }
        }];
    };
    
    [section addElement:imageElement];
}

-(MBProgressHUD*)showHud
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    [self.navigationItem setRightBarButtonItem:nil animated:YES];
    [self.view endEditing:YES];
    self.tableView.scrollEnabled = NO;
    return hud;
}

-(void)hideHud:(MBProgressHUD*)hud
{
    [hud hide:YES];
    self.tableView.scrollEnabled = YES;
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Register", @"")
                                                                                style:UIBarButtonItemStyleDone
                                                                               target:self
                                                                               action:@selector(registerClick)]
                                      animated:YES];
}

-(void)loginComplete
{
    if (self.loginWindow.endLoginBlock)
        self.loginWindow.endLoginBlock(nil);
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
    
    [self addFields:self.root];
    [self addButtons:self.root];
    [self addAuthorizators:self.root];
    
    [self.tableView reloadData];
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
    if (self.loginWindow.cancelLoginBlock)
        self.loginWindow.cancelLoginBlock();
}

-(void)registerClick
{
    RegisterViewController *registerViewController = [[RegisterViewController alloc] initWithLoginWindow:self.loginWindow];
    [self.navigationController pushViewController:registerViewController animated:YES];
}

@end
