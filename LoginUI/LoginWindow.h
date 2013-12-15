//
//  LoginWindowViewController.h
//  photomovie
//
//  Created by Evgeny Rusanov on 30.10.12.
//  Copyright (c) 2012 Macsoftex. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginWindow : NSObject

@property (nonatomic,copy) void (^loginBlock)(NSDictionary*,void(^)(BOOL logged));
@property (nonatomic,copy) void (^registerBlock)(NSDictionary*,void(^)(BOOL registered));
@property (nonatomic,copy) void (^cancelLoginBlock)(void);
@property (nonatomic,copy) void (^cancelRegisterBlock)(void);

@property (nonatomic,copy) void (^forgotPassword)(NSString *email);

@property (nonatomic,copy) void (^authorizeWith)(NSDictionary *userData,void(^)(BOOL logged));

@property (nonatomic,copy) void (^endLoginBlock)(NSError*);

@property (nonatomic,strong) NSArray *authorizators;

-(void)show;
-(void)dismiss;

@end
