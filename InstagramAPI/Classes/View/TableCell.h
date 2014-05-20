#import <UIKit/UIKit.h>

@interface TableCell : UITableViewCell


@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

- (void)setNameText:(NSString *)name;

- (void)setLikesCount:(NSInteger)count;

- (void)setImage:(UIImage *)image;

- (void)setCountComment:(NSUInteger)count;

- (void)setImageURL:(NSURL *)url;
@end
