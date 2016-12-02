//
//  EmployeeDetails.h
//  CoreDataSimple
//
//  Created by Krishana on 9/3/16.
//  Copyright © 2016 Konstant Info Solutions Pvt. Ltd. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <Foundation/Foundation.h>

@class SalaryDetails;

@interface EmployeeDetails : NSManagedObject

@property (nonatomic, retain) NSString * post;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * eid;
@property (nonatomic, retain) SalaryDetails *salinfo;


@end
