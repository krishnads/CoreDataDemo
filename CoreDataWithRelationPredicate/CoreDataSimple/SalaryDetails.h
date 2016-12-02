//
//  SalaryDetails.h
//  CoreDataSimple
//
//  Created by Krishana on 9/3/16.
//  Copyright © 2016 Konstant Info Solutions Pvt. Ltd. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <Foundation/Foundation.h>

@class EmployeeDetails;

@interface SalaryDetails : NSManagedObject

@property (nonatomic, retain) NSString * salary;
@property (nonatomic, retain) NSString * eid;
@property (nonatomic, retain) EmployeeDetails *empinfo;

@end
