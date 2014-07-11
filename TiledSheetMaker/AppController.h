//
//  AppController.h
//  TiledSheet
//
//  Created by juhana on 22/06/14.
//  Copyright (c) 2014 juhana. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppController : NSObject{
    IBOutlet NSArrayController* arrayController;
    NSMutableArray* itemArray;
    IBOutlet NSButton* SelectCreate32;
    IBOutlet NSButton* SelectCreate64;
    IBOutlet NSButton* SelectCreate128;
}

@property (nonatomic) IBOutlet NSImageView* ImageView;

-(void)createSheet:(NSNotification*)object;

-(IBAction)selectScale32:(id)sender;
-(IBAction)selectScale64:(id)sender;
-(IBAction)selectScale128:(id)sender;

@end
