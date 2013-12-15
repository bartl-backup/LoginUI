//
//  Authorizator.h
//  photomovie
//
//  Created by Evgeny Rusanov on 15.12.13.
//  Copyright (c) 2013 Macsoftex. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Authorizator : NSObject

-(UIImage*)image;
-(NSString*)title;

-(void)authorize:(void (^)(NSDictionary* userData, NSError* error))block;

@end
