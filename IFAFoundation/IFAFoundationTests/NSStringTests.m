//
//  IFAFoundation - NSStringTests.m
//  Copyright 2016 InfoAccent Pty Ltd. All rights reserved.
//
//  Created by: Marcelo Schroeder
//

@import XCTest;
#import "NSString+IFAFoundation.h"

@interface NSStringTests : XCTestCase 
@end

@implementation NSStringTests{
}

- (void)testSplitWithMaximumLength {
    // Given
    NSString *stringToBeSplit = @"I want to split NSString into array with fixed-length parts. How can i do this?";
    // When
    NSArray *actualResult = [stringToBeSplit ifa_splitWithMaximumLength:10];
    // Then
    NSArray *expectedResult =
            @[
                    @"I want to ",
                    @"split NSSt",
                    @"ring into ",
                    @"array with",
                    @" fixed-len",
                    @"gth parts.",
                    @" How can i",
                    @" do this?",
            ];
    XCTAssertEqualObjects(actualResult, expectedResult);
}

@end
