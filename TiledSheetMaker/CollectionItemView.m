//
//  CollectionItemView.m
//  TiledSheet
//
//  Created by juhana on 28/06/14.
//  Copyright (c) 2014 juhana. All rights reserved.
//

#import "CollectionItemView.h"

@implementation CollectionItemView

@synthesize Selected = _Selected;

-(void)awakeFromNib
{
    [DeleteButton setHidden:![self Selected]];
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    if([self Selected]){
        [[NSColor blueColor]set];
        NSRectFill([self bounds]);
    }
    // Drawing code here.
}

-(BOOL)Selected
{
    return _Selected;
}

-(void)setSelected:(BOOL)Selected
{
    _Selected = Selected;
    for(id obj in self.subviews){
        if([obj isKindOfClass:[NSButton class]]){
            NSButton* b = (NSButton*)obj;
            [b setHidden:!_Selected];
        }
    }
}
@end
