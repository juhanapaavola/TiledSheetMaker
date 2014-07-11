//
//  ItemArrayController.m
//  TiledSheet
//
//  Created by juhana on 24/06/14.
//  Copyright (c) 2014 juhana. All rights reserved.
//

#import "ItemArrayController.h"

@implementation ItemArrayController

-(IBAction)addObject:(id)object
{
    [super addObject:object];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"addObject" object:self userInfo:nil];
    
}

-(IBAction)removeObject:(id)object
{
    //[super removeSelectedObjects:[NSArray arrayWithObjects:object, nil]];
    NSUInteger ind = [self selectionIndex];
    [super removeObjectAtArrangedObjectIndex:ind];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"remove" object:self userInfo:nil];
}

@end
