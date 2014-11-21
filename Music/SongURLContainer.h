//
//  SongURLContainer.h
//  Music
//
//  Created by 石田 勝嗣 on 2014/11/21.
//  Copyright (c) 2014年 石田 勝嗣. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface SongURLContainer : NSObject <UIActivityItemSource>

@property (strong, nonatomic) NSURL *url;
@property (strong, nonatomic) MPMediaItem *item;
- (instancetype)initWithURL:(NSURL *)url mediaItem:(MPMediaItem *) item;

@end