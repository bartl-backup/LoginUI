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

@implementation LoginWindow
{
    id context;
    
    UINavigationController *navController;
    UIViewController *parentController;
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
    parentController = [[UIApplication sharedApplication].delegate.window.rootViewController findTopViewController];
    [parentController presentViewController:navController
                                   animated:YES
                                 completion:nil];
}

-(void)dismiss
{
    [parentController dismissViewControllerAnimated:YES
                             completion:nil];
    
    context = nil;
}

@end
