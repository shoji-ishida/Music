//
//  SongURLContainer.m
//  Music
//
//  Created by 石田 勝嗣 on 2014/11/21.
//  Copyright (c) 2014年 石田 勝嗣. All rights reserved.
//

#import "SongURLContainer.h"

@implementation SongURLContainer

- (instancetype)initWithURL:(NSURL *)url mediaItem:(MPMediaItem *) item
{
    if (self = [super init]) {
        _url = url;
        _item = item;
    }
    
    return self;
}

#pragma mark - UIActivityItemSource

- (id)activityViewControllerPlaceholderItem:(UIActivityViewController *)activityViewController
{
    //Because the URL is already set it can be the placeholder. The API will use this to determine that an object of class type NSURL will be sent.
    return self.url;
}

- (id)activityViewController:(UIActivityViewController *)activityViewController itemForActivityType:(NSString *)activityType
{
    //Return the URL being used. This URL has a custom scheme (see ReadMe.txt and Info.plist for more information about registering a custom URL scheme).
    return self.url;
}

- (UIImage *)activityViewController:(UIActivityViewController *)activityViewController thumbnailImageForActivityType:(NSString *)activityType suggestedSize:(CGSize)size
{
    //Add image to improve the look of the alert received on the other side, make sure it is scaled to the suggested size.
    MPMediaItemArtwork *artwork = [_item valueForProperty:MPMediaItemPropertyArtwork];
    UIImage *artWorkImage = [artwork imageWithSize:artwork.bounds.size];
    return artWorkImage;
}

@end
