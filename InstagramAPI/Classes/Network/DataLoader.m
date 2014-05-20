#import "DataLoader.h"
#import "DataLoadConnection.h"
#import "PhotoPost.h"
#import "DownloadManager.h"
#import "PhotoComment.h"
#import "TagParser.h"
#import "JSONParser.h"


//static NSString *const FormatURLForJSON = @"https://api.instagram.com/v1/tags/%@/media/recent?min_id=50&client_id=6834e58e8bdf4534ad8c58ca46b26dd6";
static NSString *const FormatURLForJSON = @"https://api.instagram.com/v1/media/popular?min_id=50&client_id=6834e58e8bdf4534ad8c58ca46b26dd6";

@interface DataLoader()
{
    DataLoaderCallback _callback;
}



@end

@implementation DataLoader


- (void)loadDataArrayForQuery:(NSString *)query withCallback:(DataLoaderCallback)callback
{

    _callback = callback ;

    NSString *fullFileURL = [NSString stringWithFormat:FormatURLForJSON,query];

    NSURL *url = [NSURL URLWithString:fullFileURL];

    DataLoadConnection *dataLoadConnection = [[DataLoadConnection alloc] initWithURL:url
                                                                            callback:^(DataLoadConnection *connection,NSError *error){
                                                                               if(!error)
                                                                               {
                                                                                   [self dataLoadConnectionCallback:connection];
                                                                               }else{
                                                                                   if (_callback) _callback(nil,error);
                                                                                   _callback = nil;
                                                                               }

                                                                            }];
    [DownloadManager addOperation:dataLoadConnection];

}

-(void)dataLoadConnectionCallback:(DataLoadConnection *)connection
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        NSError *error;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:connection.downloadData
                                                             options:(NSJSONReadingOptions) kNilOptions
                                                               error:&error];

        NSArray *array = [JSONParser parseJSONFromDictionary:json];

        if (_callback) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                _callback(array,nil);
            });
        }

        _callback = nil;
    });
}

@end