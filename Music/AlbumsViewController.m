//
//  AlbumsViewController.m
//  Music
//
//  Created by 石田 勝嗣 on 2014/11/10.
//  Copyright (c) 2014年 石田 勝嗣. All rights reserved.
//

#import "AlbumsViewController.h"
#import "AlbumViewController.h"


@interface AlbumsViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation AlbumsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    MPMediaQuery *albumsQuery = [MPMediaQuery albumsQuery];
    NSArray *albums = [albumsQuery collections];
    
    return [albums count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    MPMediaQuery *albumsQuery = [MPMediaQuery albumsQuery];
    NSArray *albums = [albumsQuery collections];
    
    MPMediaItem *rowItem = [[albums objectAtIndex:indexPath.row] representativeItem];
    
    cell.textLabel.text = [rowItem valueForProperty:MPMediaItemPropertyAlbumTitle];
    cell.detailTextLabel.text = [rowItem valueForProperty:MPMediaItemPropertyAlbumArtist];
    
    MPMediaItemArtwork *artwork = [rowItem valueForProperty:MPMediaItemPropertyArtwork];
    
    UIImage *artworkImage = [artwork imageWithSize: CGSizeMake (44, 44)];
    
    if (artworkImage) {
        cell.imageView.image = artworkImage;
    } else {
        cell.imageView.image = [UIImage imageNamed:@"No-artwork-albums.png"];
    }
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    AlbumViewController *detailViewController = [segue destinationViewController];
 
    MPMediaQuery *albumsQuery = [MPMediaQuery albumsQuery];
    NSArray *albums = [albumsQuery collections];
 
    int selectedIndex = [[self.tableView indexPathForSelectedRow] row];
    MPMediaItem *selectedItem = [[albums objectAtIndex:selectedIndex] representativeItem];
    NSString *albumTitle = [selectedItem valueForProperty:MPMediaItemPropertyAlbumTitle];
    MPMediaItemArtwork *artwork = [selectedItem valueForProperty:MPMediaItemPropertyArtwork];
 
    [detailViewController setAlbumTitle:albumTitle];
    [detailViewController setArtWork:artwork];

}


@end
