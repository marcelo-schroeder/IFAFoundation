//
//  IFACoreUI - IFASelectionManagerTests.m
//  Copyright 2015 InfoAccent Pty Ltd. All rights reserved.
//
//  Created by: Marcelo Schroeder
//

@import XCTest;
@import IFAFoundation;
@import OCMock;

@interface IFASelectionManagerTests : XCTestCase <IFASelectionManagerDataSource>
@property(nonatomic, strong) IFASelectionManager *selectionManager;
@property(nonatomic, strong) NSArray *objects;
@property(nonatomic, strong) id selectionManagerDelegateMock;
@end

@implementation IFASelectionManagerTests {
}

- (void)testSingleSelectionSelectionViaIndexPath {
    [self testSingleSelectionSelectionWithObject:NO];
}

- (void)testSingleSelectionSelectionViaObject {
    [self testSingleSelectionSelectionWithObject:YES];
}

- (void)testSingleSelectionSelectionWithObject:(BOOL)a_withObject {
    // given
    NSUInteger indexToSelect = 2;
    NSIndexPath *indexPathToSelect = [NSIndexPath indexPathForRow:indexToSelect
                                                        inSection:0];
    id objectToSelect = self.objects[indexToSelect];
    NSDictionary *userInfo = @{@"key" : @"value"};
    OCMExpect([self.selectionManagerDelegateMock selectionManager:self.selectionManager
                                                 willSelectObject:objectToSelect
                                                   deselectObject:[OCMArg isNil]
                                                        indexPath:indexPathToSelect
                                                         userInfo:userInfo]);
    OCMExpect([self.selectionManagerDelegateMock selectionManager:self.selectionManager
                                                  didSelectObject:objectToSelect
                                                 deselectedObject:[OCMArg isNil]
                                                        indexPath:indexPathToSelect
                                                         userInfo:userInfo]);
    // when
    if (a_withObject) {
        [self.selectionManager handleSelectionForObject:objectToSelect
                                               userInfo:userInfo];
    } else {
        [self.selectionManager handleSelectionForIndexPath:indexPathToSelect
                                                  userInfo:userInfo];
    }
    // then
    OCMVerifyAll(self.selectionManagerDelegateMock);
    XCTAssertTrue([self.selectionManager.selectedObjects containsObject:objectToSelect]);
    XCTAssertTrue([self.selectionManager.selectedIndexPaths containsObject:indexPathToSelect]);
}

- (void)testSingleSelectionSelectionViaConstructor {
    // given
    NSUInteger indexToSelect = 2;
    NSIndexPath *indexPathToSelect = [NSIndexPath indexPathForRow:indexToSelect
                                                        inSection:0];
    id objectToSelect = self.objects[indexToSelect];
    // when
    IFASelectionManager *selectionManager = [[IFASelectionManager alloc] initWithSelectionManagerDataSource:self
                                                                                            selectedObjects:@[objectToSelect]];
    // then
    XCTAssertTrue([selectionManager.selectedObjects containsObject:objectToSelect]);
    XCTAssertTrue([selectionManager.selectedIndexPaths containsObject:indexPathToSelect]);
}

- (void)testSingleSelectionDeselectionViaIndexPath {
    [self testSingleSelectionDeselectionWithObject:NO];
}

- (void)testSingleSelectionDeselectionViaObject {
    [self testSingleSelectionDeselectionWithObject:YES];
}

- (void)testSingleSelectionDeselectionWithObject:(BOOL)a_withObject {
    // given
    NSUInteger indexToDeselect = 2;
    NSIndexPath *indexPathToDeselect = [NSIndexPath indexPathForRow:indexToDeselect
                                                          inSection:0];
    [self.selectionManager handleSelectionForIndexPath:indexPathToDeselect];
    id objectToDeselect = self.objects[indexToDeselect];
    OCMExpect([self.selectionManagerDelegateMock selectionManager:self.selectionManager
                                                 willSelectObject:[OCMArg isNil]
                                                   deselectObject:objectToDeselect
                                                        indexPath:indexPathToDeselect
                                                         userInfo:[OCMArg isNil]]);
    OCMExpect([self.selectionManagerDelegateMock selectionManager:self.selectionManager
                                                  didSelectObject:[OCMArg isNil]
                                                 deselectedObject:objectToDeselect
                                                        indexPath:indexPathToDeselect
                                                         userInfo:[OCMArg isNil]]);
    // when
    if (a_withObject) {
        [self.selectionManager handleSelectionForObject:objectToDeselect];
    } else {
        [self.selectionManager handleSelectionForIndexPath:indexPathToDeselect];
    }
    // then
    OCMVerifyAll(self.selectionManagerDelegateMock);
    XCTAssertEqual(self.selectionManager.selectedObjects.count, 0);
    XCTAssertEqual(self.selectionManager.selectedIndexPaths.count, 0);
}

- (void)testSingleSelectionDeselectionDisallowingDeselectionViaIndexPath {
    [self testSingleSelectionDeselectionDisallowingDeselectionWithObject:NO];
}

- (void)testSingleSelectionDeselectionDisallowingDeselectionViaObject {
    [self testSingleSelectionDeselectionDisallowingDeselectionWithObject:YES];
}

- (void)testSingleSelectionDeselectionDisallowingDeselectionWithObject:(BOOL)a_withObject {
    // given
    self.selectionManager.disallowDeselection = YES;
    NSUInteger indexToDeselect = 2;
    id objectToDeselect = self.objects[indexToDeselect];
    NSIndexPath *indexPathToDeselect = [NSIndexPath indexPathForRow:indexToDeselect
                                                          inSection:0];
    [self.selectionManager handleSelectionForIndexPath:indexPathToDeselect];
    OCMExpect([self.selectionManagerDelegateMock selectionManager:self.selectionManager
                                                 willSelectObject:[OCMArg isNil]
                                                   deselectObject:[OCMArg isNil]
                                                        indexPath:indexPathToDeselect
                                                         userInfo:[OCMArg isNil]]);
    OCMExpect([self.selectionManagerDelegateMock selectionManager:self.selectionManager
                                                  didSelectObject:[OCMArg isNil]
                                                 deselectedObject:[OCMArg isNil]
                                                        indexPath:indexPathToDeselect
                                                         userInfo:[OCMArg isNil]]);
    // when
    if (a_withObject) {
        [self.selectionManager handleSelectionForObject:objectToDeselect];
    } else {
        [self.selectionManager handleSelectionForIndexPath:indexPathToDeselect];
    }
    // then
    OCMVerifyAll(self.selectionManagerDelegateMock);
    XCTAssertTrue([self.selectionManager.selectedObjects containsObject:objectToDeselect]);
    XCTAssertTrue([self.selectionManager.selectedIndexPaths containsObject:indexPathToDeselect]);
}

- (void)testSingleSelectionSelectionWithPreviousSelectionViaIndexPath {
    [self testSingleSelectionSelectionWithPreviousSelectionWithObject:NO];
}

- (void)testSingleSelectionSelectionWithPreviousSelectionViaObject {
    [self testSingleSelectionSelectionWithPreviousSelectionWithObject:YES];
}

- (void)testSingleSelectionSelectionWithPreviousSelectionWithObject:(BOOL)a_withObject {
    // given
    NSUInteger previouslySelectedIndex = 4;
    NSIndexPath *previouslySelectedIndexPath = [NSIndexPath indexPathForRow:previouslySelectedIndex
                                                                  inSection:0];
    id previouslySelectedObject = self.objects[previouslySelectedIndex];
    [self.selectionManager handleSelectionForIndexPath:previouslySelectedIndexPath];
    NSUInteger indexToSelect = 2;
    NSIndexPath *indexPathToSelect = [NSIndexPath indexPathForRow:indexToSelect
                                                        inSection:0];
    id objectToSelect = self.objects[indexToSelect];
    OCMExpect([self.selectionManagerDelegateMock selectionManager:self.selectionManager
                                                 willSelectObject:objectToSelect
                                                   deselectObject:previouslySelectedObject
                                                        indexPath:indexPathToSelect
                                                         userInfo:[OCMArg isNil]]);
    OCMExpect([self.selectionManagerDelegateMock selectionManager:self.selectionManager
                                                  didSelectObject:objectToSelect
                                                 deselectedObject:previouslySelectedObject
                                                        indexPath:indexPathToSelect
                                                         userInfo:[OCMArg isNil]]);
    // when
    if (a_withObject) {
        [self.selectionManager handleSelectionForObject:objectToSelect];
    } else {
        [self.selectionManager handleSelectionForIndexPath:indexPathToSelect];
    }
    // then
    OCMVerifyAll(self.selectionManagerDelegateMock);
    XCTAssertTrue([self.selectionManager.selectedObjects containsObject:objectToSelect]);
    XCTAssertTrue([self.selectionManager.selectedIndexPaths containsObject:indexPathToSelect]);
}

- (void)testMultipleSelectionSelectionViaIndexPath {
    [self testMultipleSelectionSelectionWithObject:NO];
}

- (void)testMultipleSelectionSelectionViaObject {
    [self testMultipleSelectionSelectionWithObject:YES];
}

- (void)testMultipleSelectionSelectionWithObject:(BOOL)a_withObject {
    // given
    self.selectionManager.allowMultipleSelection = YES;
    NSUInteger indexToSelect1 = 2;
    NSIndexPath *indexPathToSelect1 = [NSIndexPath indexPathForRow:indexToSelect1
                                                         inSection:0];
    id objectToSelect1 = self.objects[indexToSelect1];
    OCMExpect([self.selectionManagerDelegateMock selectionManager:self.selectionManager
                                                 willSelectObject:objectToSelect1
                                                   deselectObject:[OCMArg isNil]
                                                        indexPath:indexPathToSelect1
                                                         userInfo:[OCMArg isNil]]);
    OCMExpect([self.selectionManagerDelegateMock selectionManager:self.selectionManager
                                                  didSelectObject:objectToSelect1
                                                 deselectedObject:[OCMArg isNil]
                                                        indexPath:indexPathToSelect1
                                                         userInfo:[OCMArg isNil]]);
    NSUInteger indexToSelect2 = 4;
    NSIndexPath *indexPathToSelect2 = [NSIndexPath indexPathForRow:indexToSelect2
                                                         inSection:0];
    id objectToSelect2 = self.objects[indexToSelect2];
    OCMExpect([self.selectionManagerDelegateMock selectionManager:self.selectionManager
                                                 willSelectObject:objectToSelect2
                                                   deselectObject:[OCMArg isNil]
                                                        indexPath:indexPathToSelect2
                                                         userInfo:[OCMArg isNil]]);
    OCMExpect([self.selectionManagerDelegateMock selectionManager:self.selectionManager
                                                  didSelectObject:objectToSelect2
                                                 deselectedObject:[OCMArg isNil]
                                                        indexPath:indexPathToSelect2
                                                         userInfo:[OCMArg isNil]]);
    // when
    if (a_withObject) {
        [self.selectionManager handleSelectionForObject:objectToSelect1];
        [self.selectionManager handleSelectionForObject:objectToSelect2];
    } else {
        [self.selectionManager handleSelectionForIndexPath:indexPathToSelect1];
        [self.selectionManager handleSelectionForIndexPath:indexPathToSelect2];
    }
    // then
    OCMVerifyAll(self.selectionManagerDelegateMock);
    XCTAssertTrue([self.selectionManager.selectedObjects containsObject:objectToSelect1]);
    XCTAssertTrue([self.selectionManager.selectedObjects containsObject:objectToSelect2]);
    XCTAssertTrue([self.selectionManager.selectedIndexPaths containsObject:indexPathToSelect1]);
    XCTAssertTrue([self.selectionManager.selectedIndexPaths containsObject:indexPathToSelect2]);
}

- (void)testMultipleSelectionSelectionViaConstructor {
    // given
    self.selectionManager.allowMultipleSelection = YES;
    NSUInteger indexToSelect1 = 2;
    NSIndexPath *indexPathToSelect1 = [NSIndexPath indexPathForRow:indexToSelect1
                                                         inSection:0];
    id objectToSelect1 = self.objects[indexToSelect1];
    NSUInteger indexToSelect2 = 4;
    NSIndexPath *indexPathToSelect2 = [NSIndexPath indexPathForRow:indexToSelect2
                                                         inSection:0];
    id objectToSelect2 = self.objects[indexToSelect2];
    // when
    IFASelectionManager *selectionManager = [[IFASelectionManager alloc] initWithSelectionManagerDataSource:self
                                                                                            selectedObjects:@[objectToSelect1, objectToSelect2]];
    // then
    XCTAssertTrue([selectionManager.selectedObjects containsObject:objectToSelect1]);
    XCTAssertTrue([selectionManager.selectedObjects containsObject:objectToSelect2]);
    XCTAssertTrue([selectionManager.selectedIndexPaths containsObject:indexPathToSelect1]);
    XCTAssertTrue([selectionManager.selectedIndexPaths containsObject:indexPathToSelect2]);
}

- (void)testMultipleSelectionDeselectionViaIndexPath {
    [self testMultipleSelectionDeselectionWithObject:NO];
}

- (void)testMultipleSelectionDeselectionViaObject {
    [self testMultipleSelectionDeselectionWithObject:YES];
}

- (void)testMultipleSelectionDeselectionWithObject:(BOOL)a_withObject {
    // given
    self.selectionManager.allowMultipleSelection = YES;
    NSUInteger previouslySelectedIndex = 2;
    NSIndexPath *previouslySelectedIndexPath = [NSIndexPath indexPathForRow:previouslySelectedIndex
                                                                  inSection:0];
    [self.selectionManager handleSelectionForIndexPath:previouslySelectedIndexPath];
    NSUInteger indexToDeselect = 4;
    NSIndexPath *indexPathToDeselect = [NSIndexPath indexPathForRow:indexToDeselect
                                                          inSection:0];
    [self.selectionManager handleSelectionForIndexPath:indexPathToDeselect];
    id objectToDeselect = self.objects[indexToDeselect];
    OCMExpect([self.selectionManagerDelegateMock selectionManager:self.selectionManager
                                                 willSelectObject:[OCMArg isNil]
                                                   deselectObject:objectToDeselect
                                                        indexPath:indexPathToDeselect
                                                         userInfo:[OCMArg isNil]]);
    OCMExpect([self.selectionManagerDelegateMock selectionManager:self.selectionManager
                                                  didSelectObject:[OCMArg isNil]
                                                 deselectedObject:objectToDeselect
                                                        indexPath:indexPathToDeselect
                                                         userInfo:[OCMArg isNil]]);
    // when
    if (a_withObject) {
        [self.selectionManager handleSelectionForObject:objectToDeselect];
    } else {
        [self.selectionManager handleSelectionForIndexPath:indexPathToDeselect];
    }
    // then
    OCMVerifyAll(self.selectionManagerDelegateMock);
    XCTAssertTrue([self.selectionManager.selectedObjects containsObject:self.objects[previouslySelectedIndex]]);
    XCTAssertTrue([self.selectionManager.selectedIndexPaths containsObject:previouslySelectedIndexPath]);
}

- (void)testDeselectAll {
    // given
    self.selectionManager.allowMultipleSelection = YES;
    NSDictionary *userInfo = @{@"key" : @"value"};
    NSUInteger index1 = 2;
    NSIndexPath *indexPath1 = [NSIndexPath indexPathForRow:index1
                                                 inSection:0];
    id object1 = self.objects[index1];
    [self.selectionManager handleSelectionForIndexPath:indexPath1];
    OCMExpect([self.selectionManagerDelegateMock selectionManager:self.selectionManager
                                                 willSelectObject:[OCMArg isNil]
                                                   deselectObject:object1
                                                        indexPath:indexPath1
                                                         userInfo:userInfo]);
    OCMExpect([self.selectionManagerDelegateMock selectionManager:self.selectionManager
                                                  didSelectObject:[OCMArg isNil]
                                                 deselectedObject:object1
                                                        indexPath:indexPath1
                                                         userInfo:userInfo]);
    NSUInteger index2 = 4;
    NSIndexPath *indexPath2 = [NSIndexPath indexPathForRow:index2
                                                 inSection:0];
    id object2 = self.objects[index2];
    [self.selectionManager handleSelectionForIndexPath:indexPath2];
    OCMExpect([self.selectionManagerDelegateMock selectionManager:self.selectionManager
                                                 willSelectObject:[OCMArg isNil]
                                                   deselectObject:object2
                                                        indexPath:indexPath2
                                                         userInfo:userInfo]);
    OCMExpect([self.selectionManagerDelegateMock selectionManager:self.selectionManager
                                                  didSelectObject:[OCMArg isNil]
                                                 deselectedObject:object2
                                                        indexPath:indexPath2
                                                         userInfo:userInfo]);
    // when
    [self.selectionManager deselectAllWithUserInfo:userInfo];
    // then
    OCMVerifyAll(self.selectionManagerDelegateMock);
    XCTAssertEqual(self.selectionManager.selectedObjects.count, 0);
    XCTAssertEqual(self.selectionManager.selectedIndexPaths.count, 0);
}

- (void)testNotifyDeletionForObject {
    // given
    self.selectionManager.allowMultipleSelection = YES;
    NSUInteger previouslySelectedIndex = 2;
    NSIndexPath *previouslySelectedIndexPath = [NSIndexPath indexPathForRow:previouslySelectedIndex
                                                                  inSection:0];
    [self.selectionManager handleSelectionForIndexPath:previouslySelectedIndexPath];
    NSUInteger indexToDelete = 4;
    NSIndexPath *indexPathToDelete = [NSIndexPath indexPathForRow:indexToDelete
                                                        inSection:0];
    [self.selectionManager handleSelectionForIndexPath:indexPathToDelete];
    id objectToDelete = self.objects[indexToDelete];
    // when
    [self.selectionManager notifyDeletionForObject:objectToDelete];
    // then
    XCTAssertTrue([self.selectionManager.selectedObjects containsObject:self.objects[previouslySelectedIndex]]);
    XCTAssertTrue([self.selectionManager.selectedIndexPaths containsObject:previouslySelectedIndexPath]);
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
    self.selectionManager = [[IFASelectionManager alloc] initWithSelectionManagerDataSource:self];
    self.selectionManagerDelegateMock = OCMProtocolMock(@protocol(IFASelectionManagerDelegate));
    self.selectionManager.delegate = self.selectionManagerDelegateMock;
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
