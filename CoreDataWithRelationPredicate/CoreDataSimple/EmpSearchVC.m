
//
//  EmpSearchVC.m
//  CoreDataSimple
//
//  Created by Krishana on 9/3/16.
//  Copyright (c) 2016 Konstant Info Solutions Pvt. Ltd. All rights reserved.
//
 
#import "EmpSearchVC.h"
#import <CoreData/CoreData.h>
#import "EmployeeDetails.h"

@interface EmpSearchVC ()<UITableViewDelegate, UITableViewDataSource,NSFetchedResultsControllerDelegate, UISearchBarDelegate>


@property (nonatomic,retain) NSFetchedResultsController *fetchedResultsController;

@property (nonatomic, strong) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) IBOutlet UITableView *tView;

@property (nonatomic, strong) UILabel *noResultsLabel;

- (IBAction)closeSearch;
 

@end
 
@implementation EmpSearchVC
 
 
@synthesize managedObjectContext;
@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize searchBar,tView;
@synthesize noResultsLabel;

- (IBAction)closeSearch {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.searchBar.delegate = self;
    self.tView.delegate = self;
    self.tView.dataSource = self;
    
    noResultsLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 90, 200, 30)];
    [self.view addSubview:noResultsLabel];
    noResultsLabel.text = @"No Results";
    [noResultsLabel setHidden:YES];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.searchBar becomeFirstResponder];
}

#pragma mark - Search bar delegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSError *error;
    if (![[self fetchedResultsController] performFetch:&error]) {
        NSLog(@"Error in search %@, %@", error, [error userInfo]);
    }
    else {
        [self.tView reloadData];
        [self.searchBar resignFirstResponder];
        [noResultsLabel setHidden:_fetchedResultsController.fetchedObjects.count > 0];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id  sectionInfo =
    [[_fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    EmployeeDetails *info = [_fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = info.name;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
} 

#pragma mark - fetchedResultsController

- (NSFetchedResultsController *)fetchedResultsController {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"EmployeeDetails" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    NSSortDescriptor *sort = [[NSSortDescriptor alloc]
                              initWithKey:@"name" ascending:NO];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    [fetchRequest setFetchBatchSize:20];
    NSLog(@"search is %@", self.searchBar.text);
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"name CONTAINS[c] %@", self.searchBar.text];
    [fetchRequest setPredicate:pred];
    NSFetchedResultsController *theFetchedResultsController =
    [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                        managedObjectContext:managedObjectContext sectionNameKeyPath:nil
                                                   cacheName:nil]; // better to not use cache
    self.fetchedResultsController = theFetchedResultsController;
    _fetchedResultsController.delegate = self;
    return _fetchedResultsController;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/ 
 
@end