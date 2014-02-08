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
    NSMutableArray *r = [NSMutableArray array];

    const NSNull *null = [NSNull null];

    Position curPos = PositionMake(0, 0);

    CGSize minSize = [self minimalSizeOfTableForData:data andSpanInfo:spanInfo];
    CGSize curSize = [self resizeArray:r fromSize:CGSizeMake(0, 0) toSize:minSize];

    for (NSArray *row in data) {
        // extend the table down if necessary
        CGSize newSize = CGSizeMake(curSize.width, MAX(curSize.height, curPos.row + 1));
        curSize = [self resizeArray:r fromSize:curSize toSize:newSize];

        for (NSNumber *num in row) {
            NSArray *cellSpan = spanInfo[num];
            NSUInteger rowspan = 1;
            NSUInteger colspan = 1;
            if (cellSpan) {
                rowspan = [cellSpan[0] unsignedIntegerValue];
                colspan = [cellSpan[1] unsignedIntegerValue];
            }

            // extend the table down if necessary
            newSize = CGSizeMake(curSize.width, MAX(curSize.height, curPos.row + rowspan));
            curSize = [self resizeArray:r fromSize:curSize toSize:newSize];

            // mark null the spanned cells
            for (int colInd = 0; colInd < colspan; ++colInd) {
                for (int rowInd = 0; rowInd < rowspan; ++rowInd) {
                    r[curPos.row + rowInd][curPos.col + colInd] = null;
                }
            }
            // set the value into current cell
            r[curPos.row][curPos.col] = num;

            curPos.col += colspan;
            // the new current cell may be null, we need to skip it
            for (; curPos.col < curSize.width; ++curPos.col) {
                if (null != r[curPos.row][curPos.col]) {
                    break;
                }
            }
        }

        // move to next line
        ++curPos.row;
        curPos.col = 0;

        // if we have the next row, it may already start with nulls
        if (curPos.row < curSize.height) {
            for (NSUInteger colInd = 0; colInd < curSize.width; ++colInd) {
                if (null == r[curPos.row][colInd]) {
                    ++curPos.col;
                } else {
                    break;
                }
            }
        }
    }

    return r;
}

- (CGSize)minimalSizeOfTableForData:(NSArray *)data
                        andSpanInfo:(NSDictionary *)spanInfo {
    CGSize size = CGSizeMake(0, 0);

    NSArray *row0 = data[0];
    for (NSNumber *num in row0) {
        // make sure height is at least 1
        size.height = MAX(size.height, 1);

        NSArray *cellSpan = spanInfo[num];
        if (cellSpan) {
            NSUInteger rowspan = [cellSpan[0] unsignedIntegerValue];
            NSUInteger colspan = [cellSpan[1] unsignedIntegerValue];

            // width is increased always
            size.width += colspan;
            // expand height if needed
            size.height = MAX(size.height, rowspan);
        } else {
            ++size.width;
        }
    }

    return size;
}

- (CGSize)resizeArray:(NSMutableArray *)a fromSize:(CGSize)from toSize:(CGSize)to {
    if ((from.width >= to.width) && (from.height >= to.height)) {
        // nothing to resize
        return from;
    }

    const NSUInteger numNewCols = (NSUInteger) (to.width - from.width);
    NSUInteger numNewRows = (NSUInteger) (to.height - from.height);

    if (numNewCols > 0) {
        NSMutableArray *extraCols = [NSMutableArray arrayWithCapacity:numNewCols];
        for (int i = 0; i < numNewCols; ++i) {
            [extraCols addObject:@0];
        }

        if (a.count == 0) {
            [a addObject:[NSMutableArray array]];
            --numNewRows;
        }

        for (NSMutableArray *row in a) {
            [row addObjectsFromArray:extraCols];
        }
    }

    if (numNewRows > 0) {
        NSMutableArray *newRow = [NSMutableArray arrayWithCapacity:numNewCols];
        for (int i = 0; i < to.width; ++i) {
            [newRow addObject:@0];
        }

        for (int i = 0; i < numNewRows; ++i) {
            [a addObject:[NSMutableArray arrayWithArray:newRow]];
        }
    }

    return to;
}

@end
