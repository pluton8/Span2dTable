//
//  main.m
//  Span2dTable
//
//  Created by u on 2014-02-06.
//  Copyright (c) 2014 yes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TableSpannerAlg.h"

NSString *stringForTable(NSArray *table) {
    NSMutableString *res = [NSMutableString string];
    for (NSArray *row in table) {
        for (id col in row) {
            id symbol = (col == [NSNull null]) ? @"-" : col;
            [res appendFormat:@"%@ ", symbol];
        }
        [res appendString:@"\n"];
    }
    return [res copy];
}

int main(int argc, const char * argv[])
{
    @autoreleasepool {
        NSArray *data = @[ @[@1, @2        ],
                           @[    @3, @4, @5] ];
        NSDictionary *spans = @{ @1: @[@2, @1],
                                 @2: @[@1, @3] };

        NSArray *actual = [[TableSpannerAlg new]
                           tableForData:data andSpanInfo:spans];
        NSLog(@"Result:\n%@", stringForTable(actual));
    }
    return 0;
}
