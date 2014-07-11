//
//  CollectionItemViewController.m
//  TiledSheet
//
//  Created by juhana on 24/06/14.
//  Copyright (c) 2014 juhana. All rights reserved.
//

#import "CollectionItemViewController.h"
#import "ImageItem.h"
#import "CollectionItemView.h"

@interface CollectionItemViewController ()

@end

@implementation CollectionItemViewController
@synthesize target;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)setSelected:(BOOL)flag {
    [super setSelected: flag];
    [(CollectionItemView*)[self view]setSelected:flag];
    [(CollectionItemView*)[self view]setNeedsDisplay:YES];

}

@end
