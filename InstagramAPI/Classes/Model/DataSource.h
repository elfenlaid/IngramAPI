#import <Foundation/Foundation.h>

@class PhotoPost;
@class Page;

@interface DataSource : NSObject

+ (instancetype)sourceWithPages:(NSArray *)pages;

- (instancetype)initWithPages:(NSArray *)pages;

- (PhotoPost *)objectAtIndexPath:(NSIndexPath *)indexPath;

- (NSInteger)numberOfPhotoAtSection:(NSInteger)section;

- (NSInteger)numberOfPages;

- (NSURL *)nextURL;

- (BOOL)isEmpty;

- (void)fetchNextPage:(Page *)page;

@end