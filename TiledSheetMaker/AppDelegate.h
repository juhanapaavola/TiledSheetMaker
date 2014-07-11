//
//  AppDelegate.h
//  TiledSheetMaker
//
//  Created by juhana on 08/07/14.
//  Copyright (c) 2014 juhanapaavola. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (nonatomic) NSMutableArray* SheetItemModel;

@end
