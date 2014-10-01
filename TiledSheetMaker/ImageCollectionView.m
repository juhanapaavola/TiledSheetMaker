//
//  ImageCollectionView.m
//  TiledSheet
//
//  Created by juhana on 22/06/14.
//  Copyright (c) 2014 juhana. All rights reserved.
//

#import "ImageCollectionView.h"
#import "ImageItem.h"

@implementation ImageCollectionView{
    BOOL breakLoop;
}


-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self){
        [self registerForDraggedTypes:[NSArray arrayWithObjects:NSFilenamesPboardType,nil]];
        breakLoop = NO;
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

-(void)draggingEnded:(id<NSDraggingInfo>)sender
{
    NSLog(@"%s",__PRETTY_FUNCTION__);
}

-(NSDragOperation)draggingEntered:(id<NSDraggingInfo>)sender
{
    NSPasteboard* pboard;
    NSDragOperation sourceDragMask;
    
    sourceDragMask = [sender draggingSourceOperationMask];
    pboard = [sender draggingPasteboard];
    
    if([[pboard types]containsObject:NSFilenamesPboardType]){
        if(sourceDragMask & NSDragOperationLink ){
            return NSDragOperationLink;
        }
        if(sourceDragMask & NSDragOperationCopy){
            return NSDragOperationCopy;
        }
    }
    return NSDragOperationNone;
}

-(NSDragOperation)draggingUpdated:(id<NSDraggingInfo>)sender
{
//    NSLog(@"%s",__PRETTY_FUNCTION__);
    return [self draggingEntered:sender];
}


-(BOOL)performDragOperation:(id<NSDraggingInfo>)sender
{
    NSLog(@"%s",__PRETTY_FUNCTION__);
    NSPasteboard* pboard = [sender draggingPasteboard];
    if([[pboard types]containsObject:NSFilenamesPboardType]){
        NSArray* files = [pboard propertyListForType:NSFilenamesPboardType];
        if([files count]>0){
            [self copyFilesToImages:files];
        }
    }
    return YES;
}

- (void)copyFilesToImages:(NSArray*)files
{
    // Prepare sheet and show it...
    
    breakLoop = NO;
    
    NSRect sheetRect = NSMakeRect(0, 0, 400, 114);
    
    NSWindow *progSheet = [[NSWindow alloc] initWithContentRect:sheetRect
                                                      styleMask:NSTitledWindowMask
                                                        backing:NSBackingStoreBuffered
                                                          defer:YES];
    
    NSView *contentView = [[NSView alloc] initWithFrame:sheetRect];
    NSProgressIndicator *progInd = [[NSProgressIndicator alloc] initWithFrame:NSMakeRect(143, 74, 239, 20)];
    NSTextField *inputField = [[NSTextField alloc] initWithFrame:NSMakeRect(145, 48, 235, 22)];
    
    NSButton *cancelButton = [[NSButton alloc] initWithFrame:NSMakeRect(304, 12, 82, 32)];
    cancelButton.bezelStyle = NSRoundedBezelStyle;
    cancelButton.title = @"Cancel";
    cancelButton.action = @selector(cancelTask:);
    cancelButton.target = self;
    
    [contentView addSubview:progInd];
    [contentView addSubview:inputField];
    [contentView addSubview:cancelButton];
    
    [progSheet setContentView:contentView];
    
    
    [NSApp beginSheet:progSheet
       modalForWindow:self.window
        modalDelegate:nil
       didEndSelector:NULL
          contextInfo:NULL];
    
    [progSheet makeKeyAndOrderFront:self];
    
    [progInd setIndeterminate:NO];
    [progInd setDoubleValue:0.f];
    [progInd startAnimation:self];
    
    
    // Start computation using GCD...
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        for(NSString* file in files){
            ImageItem* item = [[ImageItem alloc]init];
            NSURL* url = [[NSURL alloc]initFileURLWithPath:file];
            NSImage* img = [[NSImage alloc]initWithContentsOfURL:url];
            NSRange slashRange = [file rangeOfString:@"/" options:NSBackwardsSearch];
            NSRange dotRange = [file rangeOfString:@"." options:NSBackwardsSearch];
            NSRange subs = NSMakeRange(slashRange.location+slashRange.length, dotRange.location-dotRange.length-slashRange.location);
            NSString* title = [file substringWithRange:subs];
            
            item.Name = title;
            item.Image = img;
            
            
            SEL action = NSSelectorFromString(@"addObject:");
            [[NSApplication sharedApplication] sendAction:action to:self.target from:item];
            
            if (breakLoop)
            {
                break;
            }
            
            // Update the progress bar which is in the sheet:
            dispatch_async(dispatch_get_main_queue(), ^{
                [progInd setDoubleValue: (double)[files indexOfObject:file]/[files count] * 100];
                [inputField setStringValue:[NSString stringWithFormat:@"file %ld/%ld",[files indexOfObject:file],[files count]]];
            });
        }
        
        // Calculation finished, remove sheet on main thread
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [progInd setIndeterminate:YES];
            
            [NSApp endSheet:progSheet];
            [progSheet orderOut:self];
            [self setNeedsDisplay:YES];
        });
    });
}

- (IBAction)cancelTask:(id)sender 
{
    NSLog(@"Cancelling");
    breakLoop = YES;
}

@end
