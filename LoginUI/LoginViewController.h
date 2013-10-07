//
//  LoginViewController.h
//  photomovie
//
//  Created by Evgeny Rusanov on 30.10.12.
//  Copyright (c) 2012 Macsoftex. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TableDialogViewController.h"

@class LoginWindow;
@interface LoginViewController : TDViewController

-(id)initWithLoginWindow:(LoginWindow*)loginWindow;

@end
