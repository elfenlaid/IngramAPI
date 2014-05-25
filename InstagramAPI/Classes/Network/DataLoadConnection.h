#import <Foundation/Foundation.h>

@class DataLoadConnection;


typedef void(^DataLoadConnectionCallback)(DataLoadConnection*,NSError *);

@interface DataLoadConnection : NSOperation

@property (nonatomic, strong, readonly) NSData *downloadData;

- (id)initWithURL:(NSURL *)url callback:(DataLoadConnectionCallback)callback;

@end
