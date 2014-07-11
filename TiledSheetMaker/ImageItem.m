//
//  ImageItem.m
//  TiledSheet
//
//  Created by juhana on 22/06/14.
//  Copyright (c) 2014 juhana. All rights reserved.
//

#import "ImageItem.h"

@implementation ImageItem

@synthesize Image,Name;

-(id)init
{
    self = [super init];
    if(self){
        Image = nil;
        Name = @"no name";
    }
    return self;
}
@end
