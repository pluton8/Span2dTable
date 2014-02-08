//
//  Span2dTableTests.m
//  Span2dTableTests
//
//  Created by u on 2014-02-06.
//  Copyright (c) 2014 yes. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TableSpannerAlg.h"

#define null [NSNull null]

@interface Span2dTableTests : XCTestCase

@property (nonatomic, strong) TableSpannerAlg *alg;

@end

@implementation Span2dTableTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.alg = [TableSpannerAlg new];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testInstanceShouldBeCreated
{
    XCTAssertNotNil(self.alg, @"Instance should be created");
}

- (void)testOneRowOneCell {
    NSArray *data = @[ @[@1] ];

    NSArray *expected = @[ @[@1] ];

    NSArray *actual = [self.alg tableForData:data andSpanInfo:nil];
    XCTAssertEqualObjects(actual, expected, @"Result is wrong");
}

- (void)testOneRowTwoCells {
    NSArray *data = @[ @[@1, @2] ];

    NSArray *expected = @[ @[@1, @2] ];

    NSArray *actual = [self.alg tableForData:data andSpanInfo:nil];
    XCTAssertEqualObjects(actual, expected, @"Result is wrong");
}

- (void)testTwoRowsTwoCells {
    NSArray *data = @[ @[@1], @[@2] ];

    NSArray *expected = @[ @[@1], @[@2] ];

    NSArray *actual = [self.alg tableForData:data andSpanInfo:nil];
    XCTAssertEqualObjects(actual, expected, @"Result is wrong");
}

- (void)testTwoRowsOneSpanCell {
    NSArray *data = @[ @[@1] ];
    NSDictionary *spans = @{ @1: @[@2, @2] };

    NSArray *expected = @[ @[@1, null], @[null, null] ];

    NSArray *actual = [self.alg tableForData:data andSpanInfo:spans];
    XCTAssertEqualObjects(actual, expected, @"Result is wrong");
}

- (void)testOneRowTwoSpanCells {
    NSArray *data = @[ @[@1] ];
    NSDictionary *spans = @{ @1: @[@1, @3] };

    NSArray *expected = @[ @[@1, null, null] ];

    NSArray *actual = [self.alg tableForData:data andSpanInfo:spans];
    XCTAssertEqualObjects(actual, expected, @"Result is wrong");
}

- (void)testOneRowOneAndOneSpanCell {
    NSArray *data = @[ @[@1, @2] ];
    NSDictionary *spans = @{ @1: @[@1, @3] };

    NSArray *expected = @[ @[@1, null, null, @2] ];

    NSArray *actual = [self.alg tableForData:data andSpanInfo:spans];
    XCTAssertEqualObjects(actual, expected, @"Result is wrong");
}

- (void)testThreeRowsOneSpanCell {
    NSArray *data = @[ @[@1] ];
    NSDictionary *spans = @{ @1: @[@3, @1] };

    NSArray *expected = @[ @[@1], @[null], @[null] ];

    NSArray *actual = [self.alg tableForData:data andSpanInfo:spans];
    XCTAssertEqualObjects(actual, expected, @"Result is wrong");
}

- (void)testTwoRowsShiftedCell {
    NSArray *data = @[ @[@1, @2], @[@3] ];
    NSDictionary *spans = @{ @1: @[@2, @1] };

    NSArray *expected = @[ @[@1, @2], @[null, @3] ];

    NSArray *actual = [self.alg tableForData:data andSpanInfo:spans];
    XCTAssertEqualObjects(actual, expected, @"Result is wrong");
}

- (void)testThreeRowsShiftedCell {
    NSArray *data = @[ @[@1, @2],
                       @[    @3],
                       @[    @4] ];
    NSDictionary *spans = @{ @1: @[@3, @1] };

    NSArray *expected = @[ @[@1,   @2],
                           @[null, @3],
                           @[null, @4] ];

    NSArray *actual = [self.alg tableForData:data andSpanInfo:spans];
    XCTAssertEqualObjects(actual, expected, @"Result is wrong");
}

- (void)testTwoRowsSpanCols {
    NSArray *data = @[ @[@1, @2, @3, @4],
                       @[    @5,     @6] ];
    NSDictionary *spans = @{ @1: @[@2, @1],
                             @3: @[@2, @1] };

    NSArray *expected = @[ @[@1,   @2, @3,   @4],
                           @[null, @5, null, @6] ];

    NSArray *actual = [self.alg tableForData:data andSpanInfo:spans];
    XCTAssertEqualObjects(actual, expected, @"Result is wrong");
}

- (void)testExample1 {
    NSArray *data = @[ @[@1, @2], @[@3, @4, @5] ];
    NSDictionary *spans = @{ @1: @[@2, @1], @2: @[@1, @3] };

    /*
     should get:
     1 2 - -
     - 3 4 5
     */
    NSArray *expected = @[ @[@1, @2, null, null],
                           @[null, @3, @4, @5] ];

    NSArray *actual = [self.alg tableForData:data andSpanInfo:spans];
//    XCTAssertEqualObjects(actual, expected, @"Result is wrong");
}

@end
