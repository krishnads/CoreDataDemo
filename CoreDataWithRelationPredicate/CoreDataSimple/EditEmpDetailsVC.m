//
//  EditEmpDetailsVC.m
//  CoreDataSimple
//
//  Created by Krishana on 9/3/16.
//  Copyright (c) 2016 Konstant Info Solutions Pvt. Ltd. All rights reserved.
//
 
#import "EditEmpDetailsVC.h"
#import "SalaryDetails.h"

@interface EditEmpDetailsVC ()
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *idField;
@property (weak, nonatomic) IBOutlet UITextField *postField;
 
/**
 *  Used to setup context view
 */
- (void)setupView;

@end
 
@implementation EditEmpDetailsVC
 
 
#pragma mark - Super class methods

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction methods

- (void) saveBankInfo {
    
    self.empDetails.name = self.nameField.text;
    self.empDetails.salinfo.salary = self.idField.text;
    self.empDetails.post = self.postField.text;
    
    NSError *error;
    if ([self.empDetails.managedObjectContext hasChanges] && ![self.empDetails.managedObjectContext save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Instance methods

- (void)setupView {
    
    self.title = @"Emp Details";
    // setting the right button
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveBankInfo)];

    self.nameField.text = self.empDetails.name;
    self.idField.text = self.empDetails.salinfo.salary;
    self.postField.text = self.empDetails.post;
    
}

#pragma mark - TableView delegate methods

#pragma mark - Mapview / CLLocation delegate methods

#pragma mark - Textfield/textview delegate methods

#pragma mark - Scrollview delegate methods

#pragma mark - Other delegate methods

#pragma mark - API methods

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/ 
 
@end