#import "DownloadManager.h"
#import "DataLoadConnection.h"


#define MAX_CONCURRENT_OPERATION 6

@interface DownloadManager()

@property(nonatomic, strong) NSOperationQueue * queue;

@end

@implementation DownloadManager

-(id)init
{
    self = [super init];
    if (self)
    {
        _queue = [[NSOperationQueue alloc] init];
        [_queue setMaxConcurrentOperationCount:MAX_CONCURRENT_OPERATION];
    }
    return self;
}

+ (void)addOperation:(DataLoadConnection *)dataLoadConnection
{
    [[self sharedManager].queue addOperation:dataLoadConnection];
}

+(void)cancelAllOperations
{
    [[self sharedManager].queue cancelAllOperations];
}


#pragma  mark - public methods

+ (DownloadManager *)sharedManager
{
    static DownloadManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        sharedManager = [[DownloadManager alloc] init];
    });
    return sharedManager;
}



@end