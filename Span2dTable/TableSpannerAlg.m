//
//  TableSpannerAlg.m
//  Span2dTable
//
//  Created by u on 2014-02-06.
//  Copyright (c) 2014 yes. All rights reserved.
//

#import "TableSpannerAlg.h"

// CGPoint copycat
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
    NSMutableArray *r = [@[] mutableCopy];

    const NSNull *null = [NSNull null];

    CGSize curSize = CGSizeMake(0, 0);
    Position curPos = PositionMake(0, 0);

    NSMutableArray *row0 = data[0];
    for (NSNumber *num in row0) {
        NSArray *cellSpan = spanInfo[num];
        NSUInteger rowspan = 0;
        NSUInteger colspan = 0;
        CGSize newSize;
        if (cellSpan) {
            rowspan = [cellSpan[0] unsignedIntegerValue] - 1;
            colspan = [cellSpan[1] unsignedIntegerValue] - 1;

            newSize = CGSizeMake(curSize.width + colspan,
                    curSize.height + rowspan);
        } else {
            newSize = CGSizeMake(curSize.width + 1, curSize.height);
        }

        [self resizeArray:r fromSize:curSize toSize:newSize];
        curSize = newSize;

        // set the value into current cell
        r[curPos.row][curPos.col++] = num;
        // and mark null the spanned cells
        for (int i = 0; i < colspan; ++i) {
            r[curPos.row][curPos.col++] = null;
        }
    }

    return r;
}

- (void)resizeArray:(NSMutableArray *)a fromSize:(CGSize)from toSize:(CGSize)to {
    if ((from.width >= to.width) && (from.height >= to.height)) {
        // nothing to resize
        return;
    }

    NSLog(@"resizing %@ to %@", NSStringFromSize(from), NSStringFromSize(to));
    const NSUInteger numNewCols = (NSUInteger) (to.width - from.width);
    const NSUInteger numNewRows = (NSUInteger) (to.height - from.height);

    if (numNewCols > 0) {
        NSMutableArray *extraCols = [NSMutableArray arrayWithCapacity:numNewCols];
        for (int i = 0; i < numNewCols; ++i) {
            [extraCols addObject:@0];
        }

        if (a.count == 0) {
            [a addObject:[NSMutableArray array]];
        }

        for (NSMutableArray *row in a) {
            [row addObjectsFromArray:extraCols];
        }
    }
}

@end
