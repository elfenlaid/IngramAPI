#import <Foundation/Foundation.h>

@class Page;

typedef void (^DataLoaderCallback)(Page *, NSError *);

@interface DataLoader : NSObject

- (void)loadDataArrayForQueryURL:(NSURL *)query withCallback:(DataLoaderCallback)callback;

@end
