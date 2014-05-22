#import <Foundation/Foundation.h>

@class PhotoPost;


@interface Page : NSObject


+ (instancetype)pageWithNextURL:(NSURL *)nextURL posts:(NSArray *)posts;

- (instancetype)initWithNextURL:(NSURL *)nextURL posts:(NSArray *)posts;

- (PhotoPost *)objectAtIndex:(NSUInteger)index;

- (NSUInteger)count;

- (NSURL*)nextURL;


@end