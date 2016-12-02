//
//  CoreDataSimpleUITests.m
//  CoreDataSimpleUITests
//
//  Created by Krishana on 9/1/16.
//  Copyright © 2016 Konstant Info Solutions Pvt. Ltd. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface CoreDataSimpleUITests : XCTestCase

@end

@implementation CoreDataSimpleUITests

- (void)setUp {
    [super setUp];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;
    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    [[[XCUIApplication alloc] init] launch];
    
    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // Use recording to get started writing UI tests.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
    
    XCUIApplication *app = app;
    XCUIElement *listViewNavigationBar = app.navigationBars[@"List View"];
    [listViewNavigationBar.buttons[@"Add"] tap];
    [listViewNavigationBar.buttons[@"Search"] tap];
    [app.searchFields containingType:XCUIElementTypeButton identifier:@"Clear text"].element;
    
    XCUIApplication *app2 = app;
    [app2.keyboards.buttons[@"Search"] tap];
    [app typeText:@"\n"];
    [app.toolbars.buttons[@"Close"] tap];
    [[[app.tables childrenMatchingType:XCUIElementTypeCell] elementBoundByIndex:2].staticTexts[@"Krishna (iOS Developer)"] tap];
    
    XCUIElementQuery *tablesQuery = app.tables;
    [tablesQuery.buttons[@"Delete"] tap];
    [tablesQuery.staticTexts[@"Krishna (iOS Developer)"] tap];
    
    XCUIElement *saveButton = app.navigationBars[@"Emp Details"].buttons[@"Save"];
    [saveButton tap];
    [tablesQuery.staticTexts[@"New user (MAC OS)"] tap];
    [app.textFields[@"Name"] tap];
    app.textFields[@"Name"];
    
    XCUIElement *element = [[[[app.otherElements containingType:XCUIElementTypeNavigationBar identifier:@"Emp Details"] childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element;
    [element tap];
    [saveButton tap];
    [tablesQuery.staticTexts[@"B (Android Developer)"] tap];
    [app.textFields[@"Salary"] tap];
    app.textFields[@"Salary"];;
    
    XCUIElement *postTextField = app.textFields[@"Post"];
    [postTextField tap];
    [postTextField tap];
    [element tap];
    [saveButton tap];
    
}

@end
