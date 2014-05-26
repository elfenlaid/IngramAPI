#import "DataLoadConnection.h"

@interface DataLoadConnection ()<NSURLConnectionDataDelegate>
{
    NSMutableData *_downloadData;
    NSURLConnection *_urlConnection;
    NSURL *_dataURL;

    BOOL _isFinished;
    BOOL _isExecuting;

    NSPort *_port;
    NSRunLoop *_runLoop;
    NSTimer *_timer;

    DataLoadConnectionCallback _callback;
}

@end

@implementation DataLoadConnection

- (void)dealloc {
    
}

-(id)initWithURL:(NSURL *)url callback:(DataLoadConnectionCallback)callback
{
    self = [super init];
    if (self)
    {
       _downloadData = [NSMutableData data];
       _dataURL = url;
       _callback = callback;

    }
    return self;

}

- (void)startAsync
{
    NSURLRequest *request = [NSURLRequest requestWithURL:_dataURL];

    _urlConnection = [NSURLConnection connectionWithRequest:request delegate:self];

    if(_urlConnection)
    {
        [_urlConnection scheduleInRunLoop:_runLoop forMode:NSDefaultRunLoopMode];
        [_urlConnection start];
    }
}


-(void)cancel
{
    [super cancel];

    [self cancelDownload];

    if (self.isExecuting) {
        self.isFinished = YES;
        self.isExecuting = NO;
    }
}

-(void)cancelDownload
{
    [_urlConnection cancel];
}

-(NSData *)downloadData
{
    return [_downloadData copy];
}


#pragma mark - NSOperation implementation

- (void)main {
    self.isFinished = NO;
    self.isExecuting = YES;
    
    _runLoop = [NSRunLoop currentRunLoop];
    
    [self startAsync];
    
    while (self.isExecuting && !self.isCancelled) {
        [_runLoop runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    
    NSLog(@"finished");
}

- (void)setIsExecuting:(BOOL)isExecuting {
    [self willChangeValueForKey:@"isExecuting"];
    _isExecuting = isExecuting;
    [self didChangeValueForKey:@"isExecuting"];
}

- (void)setIsFinished:(BOOL)isFinished {
    [self willChangeValueForKey:@"isFinished"];
    _isFinished = isFinished;
    [self didChangeValueForKey:@"isFinished"];
}

- (BOOL)isConcurrent
{
    return NO;
}

-(BOOL)isFinished
{
    return _isFinished;
}

-(BOOL)isExecuting
{
    return _isExecuting;
}

#pragma mark - urlConnection data delegate methods

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_downloadData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    void (^callbackBlock)() = ^{
        if (_callback) _callback(self,nil);
        _callback = nil;
    };

    if ([NSThread mainThread] != [NSThread currentThread] )
    {
        dispatch_sync(dispatch_get_main_queue(), callbackBlock);
    } else {
        callbackBlock();
    }

    self.isFinished = YES;
    self.isExecuting = NO;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if (_callback) _callback(nil,error);
    _callback = nil;

    self.isFinished = YES;
    self.isExecuting = NO;
}


@end
