//
//  ImageCollectionView.h
//  TiledSheet
//
//  Created by juhana on 22/06/14.
//  Copyright (c) 2014 juhana. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ImageCollectionView : NSCollectionView<NSCollectionViewDelegate>

@property (nonatomic,retain) IBOutlet id target;
@property (nonatomic,retain) NSString* actionSelectorString;

@end
