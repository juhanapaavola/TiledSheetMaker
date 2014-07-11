//
//  AppDelegate.m
//  TiledSheetMaker
//
//  Created by juhana on 08/07/14.
//  Copyright (c) 2014 juhanapaavola. All rights reserved.
//

#import "AppDelegate.h"
#import "ImageItem.h"

@implementation AppDelegate

@synthesize SheetItemModel;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    SheetItemModel = [[NSMutableArray alloc]init];
    ImageItem* item = [[ImageItem alloc]init];
    [item setName:@"name"];
    [SheetItemModel addObject:item];
}

-(void)insertObject:(ImageItem *)p inSheetItemModelArrayAtIndex:(NSUInteger)index {
    [SheetItemModel insertObject:p atIndex:index];
}

-(void)removeObjectFromSheetItemModelArrayAtIndex:(NSUInteger)index {
    [SheetItemModel removeObjectAtIndex:index];
}

-(void)setSheetItemModelArray:(NSMutableArray *)a {
    SheetItemModel = a;
}

-(NSArray*)SheetItemModel {
    return SheetItemModel;
}
@end
