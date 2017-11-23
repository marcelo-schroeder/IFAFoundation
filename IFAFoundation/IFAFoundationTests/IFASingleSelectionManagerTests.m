//
//  IFACoreUI - IFASingleSelectionManagerTests.m
//  Copyright 2015 InfoAccent Pty Ltd. All rights reserved.
//
//  Created by: Marcelo Schroeder
//

@import XCTest;
@import IFAFoundation;

@interface IFASingleSelectionManagerTests : XCTestCase <IFASelectionManagerDataSource>
@property(nonatomic, strong) IFASingleSelectionManager *selectionManager;
@property(nonatomic, strong) NSArray *objects;
@end

@implementation IFASingleSelectionManagerTests{
}


- (void)testSelection {
    // given
    NSUInteger indexToSelect = 2;
    NSIndexPath *indexPathToSelect = [NSIndexPath indexPathForRow:indexToSelect
                                                        inSection:0];
    id objectToSelect = self.objects[indexToSelect];
    // when
    [self.selectionManager handleSelectionForIndexPath:indexPathToSelect];
    // then
    XCTAssertEqualObjects(self.selectionManager.selectedObject, objectToSelect);
    XCTAssertEqualObjects(self.selectionManager.selectedIndexPath, indexPathToSelect);
}

- (void)testSelectionViaConstructor {
    // given
    NSUInteger indexToSelect = 2;
    NSIndexPath *indexPathToSelect = [NSIndexPath indexPathForRow:indexToSelect
                                                        inSection:0];
    id objectToSelect = self.objects[indexToSelect];
    // when
    IFASingleSelectionManager *selectionManager = [[IFASingleSelectionManager alloc] initWithSelectionManagerDataSource:self
                                                                                                         selectedObject:objectToSelect];
    // then
    XCTAssertEqualObjects(selectionManager.selectedObject, objectToSelect);
    XCTAssertEqualObjects(selectionManager.selectedIndexPath, indexPathToSelect);
}

- (void)testDeselection {
    // given
    NSUInteger indexToDeselect = 2;
    NSIndexPath *indexPathToDeselect = [NSIndexPath indexPathForRow:indexToDeselect
                                                          inSection:0];
    [self.selectionManager handleSelectionForIndexPath:indexPathToDeselect];
    // when
    [self.selectionManager handleSelectionForIndexPath:indexPathToDeselect];
    // then
    XCTAssertEqual(self.selectionManager.selectedObjects.count, 0);
    XCTAssertEqual(self.selectionManager.selectedIndexPaths.count, 0);
}

#pragma mark - Overrides

- (void)setUp {
    [super setUp];
    self.objects = @[
                     [NSObject new],
                     [NSObject new],
                     [NSObject new],
                     [NSObject new],
                     [NSObject new],
                     ];
    self.selectionManager = [[IFASingleSelectionManager alloc] initWithSelectionManagerDataSource:self];
}

#pragma mark - IFASelectionManagerDataSource

- (NSObject *)selectionManager:(IFASelectionManager *)a_selectionManager
             objectAtIndexPath:(NSIndexPath *)a_indexPath {
    return self.objects[(NSUInteger) a_indexPath.row];
}

- (NSIndexPath *)selectionManager:(IFASelectionManager *)a_selectionManager
               indexPathForObject:(NSObject *)a_object {
    return [NSIndexPath indexPathForRow:[self.objects indexOfObject:a_object]
                              inSection:0];
}

@end
