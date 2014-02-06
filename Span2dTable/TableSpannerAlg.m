//
//  TableSpannerAlg.m
//  Span2dTable
//
//  Created by u on 2014-02-06.
//  Copyright (c) 2014 yes. All rights reserved.
//

#import "TableSpannerAlg.h"

typedef struct {
    NSUInteger row;
    NSUInteger col;
} Position;

CG_INLINE Position
PositionMake(NSUInteger row, NSUInteger col)
{
    Position p; p.row = row; p.col = col; return p;
}

@implementation TableSpannerAlg

- (NSArray *)tableForData:(NSArray *)data andSpanInfo:(NSDictionary *)spanInfo {
    NSMutableArray *r = [@[
                           [@[@0] mutableCopy]
                           ] mutableCopy];

    CGSize curSize = CGSizeMake(1, 1);
    Position curPos = PositionMake(0, 0);

    NSMutableArray *row0 = data[0];
    for (NSNumber *num in row0) {
        r[curPos.row][curPos.col] = num;
        curPos.col++;
    }

    return r;
}

- (void)resizeArray:(NSMutableArray *)a fromSize:(CGSize)from toSize:(CGSize)to {
}

@end
