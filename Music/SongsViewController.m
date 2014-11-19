//
//  SongsViewController.m
//  Music
//
//  Created by 石田 勝嗣 on 2014/11/10.
//  Copyright (c) 2014年 石田 勝嗣. All rights reserved.
//

#import "SongsViewController.h"

@interface SongsViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)share:(id)sender;

@end

@implementation SongsViewController

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

- (void)viewWillAppear:(BOOL)animated
{
    // deselect selected cell
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self.tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    MPMediaQuery *songsQuery = [MPMediaQuery songsQuery];
    NSArray *songs = [songsQuery items];
    
    return [songs count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
 
    // Configure the cell...
 
    MPMediaQuery *songsQuery = [MPMediaQuery songsQuery];
    NSArray *songs = [songsQuery items];
 
    MPMediaItem *rowItem = [songs objectAtIndex:indexPath.row];
 
    cell.textLabel.text = [rowItem valueForProperty:MPMediaItemPropertyTitle];
    cell.detailTextLabel.text = [rowItem valueForProperty:MPMediaItemPropertyArtist];
 
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //NSLog(@"didSelect");
    // retrive cell selected
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    // set Check accesorry type to selected cell
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    //NSLog(@"didDeselect");

    // retrive cell deselected
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    // unset check accesorry type to deselected cell
    cell.accessoryType = UITableViewCellAccessoryNone;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)share:(id)sender {
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];

    if (indexPath == nil) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Share" message:@"Select a music to share." preferredStyle:UIAlertControllerStyleAlert];
        
        // add confirm button
        [alertController addAction:[UIAlertAction actionWithTitle:@"Confirm" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            // just simply dismiss
            return;
        }]];
        
        
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    
    MPMediaQuery *songsQuery = [MPMediaQuery songsQuery];
    NSArray *songs = [songsQuery items];
    
    MPMediaItem *rowItem = [songs objectAtIndex:indexPath.row];
    
    NSURL *url = [rowItem valueForProperty:MPMediaItemPropertyAssetURL];
    
    NSLog(@"url = %@", url);

    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:url options:nil];
    AVAssetExportSession *exportSession = [[AVAssetExportSession alloc]
                                           initWithAsset:urlAsset
                                           presetName:AVAssetExportPresetPassthrough];
    exportSession.outputFileType = [[exportSession supportedFileTypes] objectAtIndex:0];
    
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [[docDir stringByAppendingPathComponent:[rowItem valueForProperty:MPMediaItemPropertyTitle]] stringByAppendingPathExtension:@"m4a"];
    exportSession.outputURL = [NSURL fileURLWithPath:filePath];
    
    [exportSession exportAsynchronouslyWithCompletionHandler:^{
        
        if (exportSession.status == AVAssetExportSessionStatusCompleted) {
            NSLog(@"export session completed");
            
            NSArray *objectsToShare = @[exportSession.outputURL];
            
            UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
            
            controller.completionWithItemsHandler = ^(NSString *activityType, BOOL completed, NSArray *returnedItems, NSError *activityError) {
                NSLog(@"completionWithItemsHandler");
                
                // remove music file being created for AirDrop
                NSFileManager* manager = [NSFileManager defaultManager];
                [manager removeItemAtURL:exportSession.outputURL error:NULL];
                
                // deselect music being AirDropped
                [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
                [self.tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
            };
            
            
            
            
            // Present the controller
            [self presentViewController:controller animated:YES completion:nil];

        } else {
            NSLog(@"export session error");
        }

    }];

}
@end
