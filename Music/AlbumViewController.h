//
//  AlbumViewController.h
//  Music
//
//  Created by 石田 勝嗣 on 2014/11/10.
//  Copyright (c) 2014年 石田 勝嗣. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface AlbumViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>
@property NSString *albumTitle;
@property MPMediaItemArtwork *artWork;
@end
