#import "TableCell+PhotoPost.h"
#import "PhotoPost.h"
#import "DownloadManager.h"
#import "Objc/runtime.h"

static char key ;

@implementation TableCell (PhotoPost)


-(void)setConnection:(DataLoadConnection *)connection
{
    objc_setAssociatedObject(self,&key,connection, OBJC_ASSOCIATION_RETAIN);
}

-(DataLoadConnection *)connection
{
    return objc_getAssociatedObject(self, &key);
}


#pragma mark - public methods

- (void)setupWithPost:(PhotoPost *)post {

    [self setNameText:post.fullName];
    [self setLikesCount:post.countLikes];
    [self setImageURL:post.standardResolutionURL];
    [self setCountComment:post.commentsArray.count];
    [self setImage:nil];
    [self.activityIndicator startAnimating];


    DataLoadConnection *dataLoadConnection = [[DataLoadConnection alloc] initWithURL:post.thumbnailURL
                                                                            callback:^(DataLoadConnection *connection,NSError *error){
                                                                               if(!error)
                                                                               {
                                                                                   [self dataLoadConnectionCallback:connection];
                                                                               }else{
                                                                                   if (connection != self.connection) return;

                                                                                   [self.activityIndicator stopAnimating];

                                                                                   NSLog(@"%@",error.localizedDescription);
                                                                               }
                                                                            }];

    [DownloadManager addOperation:dataLoadConnection];

    self.connection = dataLoadConnection;
}


-(void)dataLoadConnectionCallback:(DataLoadConnection *)connection
{
    if (connection != self.connection) return;

    [self.activityIndicator stopAnimating];

    UIImage *image = [UIImage imageWithData:connection.downloadData];
    [self setImage:image];
}

@end