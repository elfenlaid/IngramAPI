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

    DataLoadConnectionCallback _callback;
}

@end

@implementation DataLoadConnection

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
        [_runLoop run];
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

- (void)start {
    
    self.isFinished = NO;
    self.isExecuting = YES;

    _port = [NSPort port];
    _runLoop = [NSRunLoop currentRunLoop];
    [_runLoop addPort:_port forMode:NSDefaultRunLoopMode];

    [self cancelDownload];
    [self startAsync];

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

- (BOOL)isConcurrent {
    return YES;
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

    };

    if ([NSThread mainThread] != [NSThread currentThread] )
    {
        dispatch_sync(dispatch_get_main_queue(), callbackBlock);
    } else {
        callbackBlock();
    }

    self.isFinished = YES;
    self.isExecuting = NO;
    [_port removeFromRunLoop:_runLoop forMode:NSDefaultRunLoopMode];

}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    _callback(nil,error);

    self.isFinished = YES;
    self.isExecuting = NO;
    [_port removeFromRunLoop:_runLoop forMode:NSDefaultRunLoopMode];

}


@end
