#import <Foundation/Foundation.h>

@class PhotoPost;

@interface DataSource : NSObject

- (id)initWithArray:(NSArray *)array;

- (PhotoPost *)objectAtIndexPath:(NSIndexPath *)path;

- (NSInteger)count;

@end