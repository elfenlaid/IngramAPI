#import "CommentCell+CommentPost.h"
#import "PhotoComment.h"
#import "Objc/runtime.h"
#import "DataLoadConnection.h"
#import "DownloadManager.h"

static char key ;


@implementation CommentCell (CommentPost)

-(void)setConnection:(DataLoadConnection *)connection
{
    objc_setAssociatedObject(self,&key,connection, OBJC_ASSOCIATION_RETAIN);
}

-(DataLoadConnection *)connection
{
    return objc_getAssociatedObject(self, &key);
}

#pragma mark - public methods

- (void)setupWithPost:(PhotoComment *)post
{

    [self setCommentText:post.commentText];
    [self setProfileImage:nil];
    [self.activityIndicator startAnimating];

    DataLoadConnection *dataLoadConnection = [[DataLoadConnection alloc] initWithURL:post.profilePictureURL
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
    [self setProfileImage:image];

}




@end
