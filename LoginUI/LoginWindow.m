//
//  LoginWindowViewController.m
//  photomovie
//
//  Created by Evgeny Rusanov on 30.10.12.
//  Copyright (c) 2012 Macsoftex. All rights reserved.
//

#import "LoginWindow.h"
#import "LoginViewController.h"

#import "UIViewController+Helpers.h"

@interface LoginWindow ()

@end

@implementation LoginWindow
{
    id context;
    
    UINavigationController *navController;
}

- (id)init
{
    if (self = [super init])
    {
        LoginViewController *viewController = [[LoginViewController alloc] initWithLoginWindow:self];
        navController = [[UINavigationController alloc] initWithRootViewController:viewController];
        
        self.loginBlock = nil;
        self.registerBlock = nil;
        self.cancelLoginBlock = nil;
        self.cancelRegisterBlock = nil;
        self.endLoginBlock = nil;
    }
    
    return self;
}

-(void)show
{
    context = self;
    [[[UIApplication sharedApplication].delegate.window.rootViewController findTopViewController] presentViewController:navController
                                                                                                               animated:YES
                                                                                                             completion:nil];
}

-(void)dismiss
{
    [navController dismissViewControllerAnimated:YES
                             completion:nil];
    
    context = nil;
}

@end
