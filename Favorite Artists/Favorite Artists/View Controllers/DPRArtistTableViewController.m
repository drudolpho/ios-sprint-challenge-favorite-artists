//
//  DPRArtistTableViewController.m
//  Favorite Artists
//
//  Created by Dennis Rudolph on 1/24/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

#import "DPRArtistTableViewController.h"
#import "DPRSearchViewController.h"
#import "DPRArtistController.h"
#import "DPRDetailViewController.h"

@interface DPRArtistTableViewController ()

@end

@implementation DPRArtistTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.artistController = [[DPRArtistController alloc] init];
    [self.artistController loadArtists];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.artistController.artists.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ArtistCell" forIndexPath:indexPath];
    
    DPRArtist *artist = [self.artistController.artists objectAtIndex:indexPath.row];
    
    cell.textLabel.text = artist.name;
    NSInteger valid = artist.yearFormed;
    if (valid == 0) {
        cell.detailTextLabel.text = @"Formed in: ?";
    } else {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"Formed in %li", (long)artist.yearFormed];
    }
    
    return cell;
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"SearchSegue"]) {
        DPRSearchViewController *searchVC = segue.destinationViewController;
        searchVC.artistController = self.artistController;
    } else if ([segue.identifier isEqualToString:@"DetailSegue"]) {
        DPRDetailViewController *detailVC = segue.destinationViewController;
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        detailVC.artist = [self.artistController.artists objectAtIndex:indexPath.row];
    }
}

@end
