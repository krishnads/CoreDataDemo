//
//  ViewController.m
//  CoreDataSimple
//
//  Created by Krishana on 9/1/16.
//  Copyright © 2016 Konstant Info Solutions Pvt. Ltd. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "EmployeeDetails.h"
#import "SalaryDetails.h"
#import "EditEmpDetailsVC.h"
#import "EmpSearchVC.h"



@interface ViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, NSFetchedResultsControllerDelegate> {
    NSMutableArray *nameArray;
    AppDelegate *appDelegate;
    NSManagedObjectContext *moc;
}

@property (weak, nonatomic) IBOutlet UITableView *listTableView;

- (IBAction)addItemButtonAction:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];

    moc = appDelegate.managedObjectContext;
    
    [super viewDidLoad];
    nameArray = [[NSMutableArray alloc] init];
    NSError *error;
    if (![[self fetchedResultsController] performFetch:&error]) {
        // Update to handle the error appropriately.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        exit(-1);  // Fail
    }
    
    NSLog(@"object->%@", self.fetchedResultsController);
    self.title = @"List View";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(showSearch)];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addBank)];
    

    // Do any additional setup after loading the view, typically from a nib.
}

#pragma mark - Actions

- (void) addBank {
    EmployeeDetails *empDetails = (EmployeeDetails *)[NSEntityDescription insertNewObjectForEntityForName:@"EmployeeDetails"
                                                                                     inManagedObjectContext:moc];
    empDetails.name = @"Krishna";
    empDetails.eid = @"KIPL1376";
    empDetails.post = @"iOS Developer";
    
    SalaryDetails *salaryDetails = [NSEntityDescription insertNewObjectForEntityForName:@"SalaryDetails"
                                                                         inManagedObjectContext:moc];
    salaryDetails.eid = @"KIPL1376";
    salaryDetails.salary = @"Rs. 20000";
    salaryDetails.empinfo = empDetails;
    
    empDetails.salinfo = salaryDetails;
    
    NSError *error = nil;
    if (![moc save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

- (void) showSearch {
    [self performSegueWithIdentifier:@"PRESENT_SEARCH" sender:moc];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    self.fetchedResultsController = nil;
    moc = nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //return nameArray.count;
    id  sectionInfo = [[_fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    // If row is deleted, remove it from the list.
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObject *managedObject = [self.fetchedResultsController objectAtIndexPath:indexPath];
        [moc deleteObject:managedObject];
        [moc save:nil];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    EmployeeDetails *empDetails = [_fetchedResultsController objectAtIndexPath:indexPath];
    [self performSegueWithIdentifier:@"LIST_TO_EDIT" sender:empDetails];
    empDetails = nil;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    EmployeeDetails *emp = [_fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ (%@)", emp.name, emp.post] ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)deleteNameFromCoreDataAtIndexPath:(NSIndexPath *)indexPath {
    NSManagedObject *name = (NSManagedObject *)[nameArray objectAtIndex:indexPath.row];
    [moc deleteObject:name];
    NSError *deleteError = nil;
    if (![name.managedObjectContext save:&deleteError]) {
        NSLog(@"Unable to save managed object context.");
        NSLog(@"%@, %@", deleteError, deleteError.localizedDescription);
    }
    else {
        UITableView *tableView = self.listTableView;
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [nameArray removeObjectAtIndex:indexPath.row];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return [textField resignFirstResponder];
}

- (NSFetchedResultsController *)fetchedResultsController {
    
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"EmployeeDetails" inManagedObjectContext:moc];
    [fetchRequest setEntity:entity];
    

    /**
     *  Set SortDescriptop to blank array if don't want to use sorting
     */
    [fetchRequest setSortDescriptors:@[]];
    
//    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
//    [fetchRequest setSortDescriptors:@[sort]];
    [fetchRequest setFetchBatchSize:20];
    
    NSFetchedResultsController *theFetchedResultsController =
    [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                        managedObjectContext:moc
                                          sectionNameKeyPath:nil
                                                   cacheName:nil];
    self.fetchedResultsController = theFetchedResultsController;
    _fetchedResultsController.delegate = self;
    
    return _fetchedResultsController;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller is about to start sending change notifications, so prepare the table view for updates.
    [self.listTableView beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = self.listTableView;
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray
                                               arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray
                                               arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id )sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [self.listTableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.listTableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeMove:
            break;
        
        case NSFetchedResultsChangeUpdate:
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller has sent all current change notifications, so tell the table view to process all updates.
    [self.listTableView endUpdates];
}




 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     if ([[segue destinationViewController] isKindOfClass:[EditEmpDetailsVC class]] ) {
         EditEmpDetailsVC *editVC = (EditEmpDetailsVC *)[segue destinationViewController];
         editVC.empDetails = (EmployeeDetails *) sender;
     }
     else if ([[segue destinationViewController] isKindOfClass:[EmpSearchVC class]] ) {
         EmpSearchVC *editVC = (EmpSearchVC *)[segue destinationViewController];
         editVC.managedObjectContext = (NSManagedObjectContext *) sender;
     }
 }


@end
