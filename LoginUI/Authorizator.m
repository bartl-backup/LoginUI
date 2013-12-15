//
//  Authorizator.m
//  photomovie
//
//  Created by Evgeny Rusanov on 15.12.13.
//  Copyright (c) 2013 Macsoftex. All rights reserved.
//

#import "Authorizator.h"

@implementation Authorizator

-(UIImage*)image
{
    return nil;
}

-(NSString*)title
{
    return nil;
}

-(void)authorize:(void (^)(NSDictionary* userData, NSError* error))block
{
    [self doesNotRecognizeSelector:_cmd];
}

@end
