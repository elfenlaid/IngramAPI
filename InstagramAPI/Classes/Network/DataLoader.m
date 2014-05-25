#import "DataLoader.h"
#import "DataLoadConnection.h"
#import "PhotoPost.h"
#import "Page.h"
#import "DownloadManager.h"
#import "PhotoComment.h"
#import "TagParser.h"
#import "JSONParser.h"
#import "Page.h"


@interface DataLoader()
{
    DataLoaderCallback _callback;
}



@end

@implementation DataLoader


- (void)loadDataArrayForQueryURL:(NSURL *)query withCallback:(DataLoaderCallback)callback
{

    _callback = callback ;
    [self.dataLoadConnection cancel];
    self.dataLoadConnection = [[DataLoadConnection alloc] initWithURL:query
                                                                            callback:^(DataLoadConnection *connection,NSError *error){
                if(!error)
                {
                    [self dataLoadConnectionCallback:connection];
                }else{
                    if (_callback) _callback(nil,error);
                    _callback = nil;
                }

            }];
    [DownloadManager addOperation:self.dataLoadConnection];

}

-(void)dataLoadConnectionCallback:(DataLoadConnection *)connection
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        NSError *error;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:connection.downloadData
                                                             options:(NSJSONReadingOptions)kNilOptions
                                                               error:&error];

        Page *page = [JSONParser parseJSONFromDictionary:json];

        if (_callback) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                _callback(page,nil);
            });
        }

        _callback = nil;
    });
}

@end