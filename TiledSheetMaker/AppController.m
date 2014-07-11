//
//  AppController.m
//  TiledSheet
//
//  Created by juhana on 22/06/14.
//  Copyright (c) 2014 juhana. All rights reserved.
//

#import "AppController.h"
#import "ImageItem.h"

static int Lowest = 32;

@implementation AppController{
    NSImage* Result32;
    NSImage* Result64;
    NSImage* Result128;
    NSImage* Preview;
    BOOL Create32;
    BOOL Create64;
    BOOL Create128;
}

@synthesize ImageView;


-(id)init
{
    self = [super init];
    if(self){
        itemArray = [[NSMutableArray alloc]init];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(createSheet:) name:@"addObject" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(createSheet:) name:@"remove" object:nil];
        [SelectCreate32 setState:NSOnState];
        [SelectCreate64 setState:NSOnState];
        [SelectCreate128 setState:NSOnState];
        Create128=YES;
        Create32=YES;
        Create64=YES;
    }
    return self;
}

-(IBAction)selectScale32:(id)sender
{
    if([sender isKindOfClass:[NSButton class]]){
        NSButton* b = (NSButton*)sender;
        if([b state]==NSOnState){
            Create32=YES;
        }else{
            Create32=NO;
        }
    }
}

-(IBAction)selectScale64:(id)sender
{
    if([sender isKindOfClass:[NSButton class]]){
        NSButton* b = (NSButton*)sender;
        if([b state]==NSOnState){
            Create64=YES;
        }else{
            Create64=NO;
        }
    }
}

-(IBAction)selectScale128:(id)sender
{
    if([sender isKindOfClass:[NSButton class]]){
        NSButton* b = (NSButton*)sender;
        if([b state]==NSOnState){
            Create128=YES;
        }else{
            Create128=NO;
        }
    }
}

-(void)createSheet:(NSNotification*)object
{
    int columns = 6;
    NSUInteger count = [itemArray count];
    CGFloat w;
    CGFloat h;
    
    if([itemArray count]>columns){
        w = columns*32;
        h = count/6;
        NSUInteger h2 = count-h;
        h = h*32;
        if(h2>0){
            h+=32;
        }
    }else{
        w = count*32;
        h = 32;
    }
    Preview = [[NSImage alloc]initWithSize:NSMakeSize(w, h)];
    [Preview setFlipped:YES];

    if(Create64){
        Result64 = [[NSImage alloc]initWithSize:NSMakeSize(w*2, h*2)];
        [Result64 setFlipped:YES];
    }
    if(Create128){
        Result128 = [[NSImage alloc]initWithSize:NSMakeSize(w*4, h*4)];
        [Result128 setFlipped:YES];
    }
    
    int index = 0;
    int row = 0;
    int col = 0;
    while(index<[itemArray count]){
        ImageItem* item = [itemArray objectAtIndex:index];
        [self drawItemToResult:item.Image result:Preview col:col row:row side:Lowest];

        if(Create64){
            [self drawItemToResult:item.Image result:Result64 col:col row:row side:Lowest*2];
        }
        
        if(Create128){
            [self drawItemToResult:item.Image result:Result128 col:col row:row side:Lowest*4];
        }

        index++;
        col++;
        if(col>5){
            col=0;
        }
        row = index/columns;
    }
    if(Create32){
        Result32=Preview;
    }

    [ImageView setImage:Preview];
}

-(void)drawItemToResult:(NSImage*)source result:(NSImage*)result col:(int)col row:(int)row side:(int)side
{
    [source setScalesWhenResized:YES];
    [source setSize:NSMakeSize(side, side)];
    NSRect rect = NSMakeRect(col*source.size.width, row*source.size.height, source.size.width, source.size.height);
    NSRect sourceRect = NSMakeRect(0, 0, source.size.width, source.size.height);
    [result lockFocus];
    [source drawInRect:rect fromRect:sourceRect operation:NSCompositeCopy fraction:1.0];
    [result unlockFocus];
}

-(IBAction)saveSheets:(id)sender
{
    NSOpenPanel* dialog = [NSOpenPanel openPanel];
    [dialog setCanChooseDirectories:YES];
    [dialog setCanChooseFiles:NO];
    if([dialog runModal]==NSFileHandlingPanelOKButton){
        NSURL* directory = [dialog directoryURL];
        NSString* name = [self filenameInput:@"Input basename" defaultValue:@""];
        if(name!=nil && [name length]>0){
            if(Create32){
                BOOL ret = [self writeToFile:name side:Lowest directory:directory source:Result32];
                if(!ret){
                    NSAlert* alert = [NSAlert alertWithMessageText:@"Error when saving image 32" defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:@""];
                    [alert runModal];
                }
            }
            if(Create64){
                BOOL ret = [self writeToFile:name side:Lowest*2 directory:directory source:Result64];
                if(!ret){
                    NSAlert* alert = [NSAlert alertWithMessageText:@"Error when saving image 64" defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:@""];
                    [alert runModal];
                }
            }
            if(Create128){
                BOOL ret = [self writeToFile:name side:Lowest*4 directory:directory source:Result128];
                if(!ret){
                    NSAlert* alert = [NSAlert alertWithMessageText:@"Error when saving image 128" defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:@""];
                    [alert runModal];
                }
            }
        }
        
    }
}

-(BOOL)writeToFile:(NSString*)basename side:(int)side directory:(NSURL*)url source:(NSImage*)source
{
    NSString* filename = [NSString stringWithFormat:@"%@/%@_%d.png",url.path,basename,side];
    [source lockFocus] ;
    NSBitmapImageRep *bitmapRep = [[NSBitmapImageRep alloc] initWithFocusedViewRect:NSMakeRect(0.0, 0.0, [source size].width, [source size].height)] ;
    [source unlockFocus] ;
    NSData* imageData = [bitmapRep representationUsingType:NSPNGFileType properties:nil];
    return [imageData writeToFile:filename atomically:NO];
}

-(NSString*)filenameInput:(NSString*)prompt defaultValue:(NSString*)defaultValue
{
    NSAlert* alert = [NSAlert alertWithMessageText:@"File basename" defaultButton:@"OK" alternateButton:@"Cancel" otherButton:nil informativeTextWithFormat:@""];
    NSTextField* field = [[NSTextField alloc]initWithFrame:NSMakeRect(0, 0, 200, 24)];
    [field setStringValue:defaultValue];
    [alert setAccessoryView:field];
    NSInteger button = [alert runModal];
    if(button==NSAlertDefaultReturn){
        [field validateEditing];
        return [field stringValue];
    }
    return nil;
}
@end
