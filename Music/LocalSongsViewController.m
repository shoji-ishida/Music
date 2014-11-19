//
//  LocalSongsViewController.m
//  Music
//
//  Created by 石田 勝嗣 on 2014/11/17.
//  Copyright (c) 2014年 石田 勝嗣. All rights reserved.
//

#import "LocalSongsViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "AppDelegate.h"

@interface LocalSongsViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray* songs;
@property (strong, nonatomic) AVPlayer *player;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *pauseButton;
@end

@implementation LocalSongsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.songs = [NSMutableArray array];

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSURL *directoryURL = [NSURL fileURLWithPath:[paths objectAtIndex:0]];
    
    [self searchDirectory:directoryURL];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    //Register for notifications about received content
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadFile) name:SavedAudioURLNotification object:nil];
    // set EditButton to edit
    [self setEditing:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SavedAudioURLNotification object:nil];
}

// slector for NSNotification to update songs Mutable array.
- (void)reloadFile {
    [self.songs removeAllObjects];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSURL *directoryURL = [NSURL fileURLWithPath:[paths objectAtIndex:0]];
    
    [self searchDirectory:directoryURL];
    [self.tableView reloadData];
}

- (void)searchDirectory: (NSURL *)directoryURL {
    NSArray *keys = [NSArray arrayWithObjects:
                     NSURLIsDirectoryKey, NSURLIsRegularFileKey, NSURLLocalizedNameKey, nil];
    
    NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager] enumeratorAtURL:directoryURL
                                                             includingPropertiesForKeys:keys
                                                                                options:(NSDirectoryEnumerationSkipsPackageDescendants |
                                                                                         NSDirectoryEnumerationSkipsHiddenFiles)
                                                                           errorHandler:^(NSURL *url, NSError *error) {
                                                                               // Handle the error.
                                                                               // Return YES if the enumeration should
                                                                               return YES;
                                                                           }];
    for (NSURL *url in enumerator) {
        NSNumber *isDirectory = nil;
        NSString *localizedName = nil;
        [url getResourceValue:&localizedName forKey:NSURLLocalizedNameKey
                        error:NULL];
        [url getResourceValue:&isDirectory forKey:NSURLIsDirectoryKey error:NULL];
        if ([isDirectory boolValue]) {
            //NSLog(@"Directory at %@", localizedName);
            //[self searchDirectory:url];
        } else {
            NSNumber *isRegularFile = nil;
            [url getResourceValue:&isRegularFile forKey:NSURLIsRegularFileKey error:NULL];
            //NSLog(@"File %@", localizedName);
            [self.songs addObject:url];
        }
    }
}

- (IBAction)pause:(id)sender {
    [self.pauseButton setEnabled:FALSE];
    [self.player pause];
    //[self.navigationItem.rightBarButtonItem setEnabled:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.songs count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
 
    NSURL *url = [self.songs objectAtIndex:indexPath.row];
    
    NSString *localizedName = nil;
    [url getResourceValue:&localizedName forKey:NSURLLocalizedNameKey
                    error:NULL];
    cell.textLabel.text = localizedName;
 
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSURL *url = [self.songs objectAtIndex:indexPath.row];
    self.player = [[AVPlayer alloc]initWithURL:url];
    [self.player play];
    [self.pauseButton setEnabled:YES];
    //[self.navigationItem.rightBarButtonItem setEnabled:NO];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        NSFileManager* manager = [NSFileManager defaultManager];
        NSURL* url = [self.songs objectAtIndex:indexPath.row];
        [manager removeItemAtURL:url error:NULL];
        [self.songs removeObject:url];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


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

@end
