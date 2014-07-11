//
//  ImageCollectionView.m
//  TiledSheet
//
//  Created by juhana on 22/06/14.
//  Copyright (c) 2014 juhana. All rights reserved.
//

#import "ImageCollectionView.h"
#import "ImageItem.h"

@implementation ImageCollectionView

@synthesize Checkbox128,Checkbox32,Checkbox64;

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self){
        [self registerForDraggedTypes:[NSArray arrayWithObjects:NSFilenamesPboardType,nil]];
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
        }
    }
    return YES;
}


@end
