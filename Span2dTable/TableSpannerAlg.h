//
//  TableSpannerAlg.h
//  Span2dTable
//
//  Created by u on 2014-02-06.
//  Copyright (c) 2014 yes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TableSpannerAlg : NSObject

/**
 * Converts the input table with the span info into a 2d array. Check out the
 * tests for usage examples.
 *
 * Assumption: all numbers are distinct!
 * Assumption: no zeroes in input data!
 */
- (NSArray *)tableForData:(NSArray *)data andSpanInfo:(NSDictionary *)spanInfo;

@end
