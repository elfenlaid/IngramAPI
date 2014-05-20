#import <Foundation/Foundation.h>


typedef void (^DataLoaderCallback)(NSArray *, NSError *);

@interface DataLoader : NSObject

- (void)loadDataArrayForQuery:(NSString *)query withCallback:(DataLoaderCallback)callback;

@end
