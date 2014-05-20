#import <UIKit/UIKit.h>

@interface CommentCell : UITableViewCell

@property (nonatomic , strong) UIActivityIndicatorView *activityIndicator;

- (void)setCommentText:(NSString *)text;

- (void)setProfileImage:(UIImage *)image;

@end
