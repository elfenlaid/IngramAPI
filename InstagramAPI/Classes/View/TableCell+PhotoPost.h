#import "TableCell.h"
#import "DataLoadConnection.h"

@class PhotoPost;

@interface TableCell (PhotoPost)

- (void)setupWithPost:(PhotoPost *)post;

@end