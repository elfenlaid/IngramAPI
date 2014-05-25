#import <Foundation/Foundation.h>

@class Page;
@class DataLoadConnection;

typedef void (^DataLoaderCallback)(Page *, NSError *);

@interface DataLoader : NSObject

@property(nonatomic, strong) DataLoadConnection *dataLoadConnection;

- (void)loadDataArrayForQueryURL:(NSURL *)query withCallback:(DataLoaderCallback)callback;

@end
