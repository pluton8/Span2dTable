//
//  Span2dTableTests.m
//  Span2dTableTests
//
//  Created by u on 2014-02-06.
//  Copyright (c) 2014 yes. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TableSpannerAlg.h"

@interface Span2dTableTests : XCTestCase

@end

@implementation Span2dTableTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testInstanceShouldBeCreated
{
    TableSpannerAlg *alg = [TableSpannerAlg new];
    XCTAssertNotNil(alg, @"Instance should be created");
}

@end
