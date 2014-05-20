#import "CommentCell.h"

@class PhotoComment;

@interface CommentCell (CommentPost)

-(void)setupWithPost:(PhotoComment *)post;

@end
