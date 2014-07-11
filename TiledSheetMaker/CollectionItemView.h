//
//  CollectionItemView.h
//  TiledSheet
//
//  Created by juhana on 28/06/14.
//  Copyright (c) 2014 juhana. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ImageItem.h"

@interface CollectionItemView : NSView{
    IBOutlet NSButton* DeleteButton;
}

@property (nonatomic) BOOL Selected;

@end
