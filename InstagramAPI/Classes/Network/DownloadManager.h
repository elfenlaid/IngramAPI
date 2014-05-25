#import <Foundation/Foundation.h>

@class DataLoadConnection;

@interface DownloadManager : NSObject

+ (void)addOperation:(DataLoadConnection*)dataLoadConnection;

+ (void)cancelAllOperations;

@end
