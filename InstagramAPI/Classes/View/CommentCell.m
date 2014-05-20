#import "CommentCell.h"
#import "TagParser.h"


static CGFloat const profilePictureHeight = 50.0f;
static CGFloat const indent = 5.0f;

@interface CommentCell()
{

}

@end


@implementation CommentCell
{
   UIImageView * _profilePicture;
   UILabel *_commentLabel;
}

 -(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
 {
     self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
     if(self)
     {
         [self setupProfileImage];
         [self setupComment];
         [self setupActivityIndicator];
         [self setSeparatorInset:UIEdgeInsetsZero];
     }
     return self;
 }

#pragma  mark - internal methods

-(void)setupProfileImage
{
    _profilePicture = [[UIImageView alloc] init];

    _profilePicture.layer.cornerRadius = 5;
    _profilePicture.clipsToBounds = YES;

    [self addSubview:_profilePicture];
}

-(void)setupComment
{
   _commentLabel = [[UILabel alloc] init];

   _commentLabel.textColor = [UIColor blackColor];
//   _commentLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
   _commentLabel.numberOfLines = 0;

    [self addSubview:_commentLabel];

}

-(void)setupActivityIndicator
{
    _activityIndicator = [[UIActivityIndicatorView alloc] init];
    _activityIndicator.hidesWhenStopped = YES;
    _activityIndicator.color = [UIColor blackColor];

    [self addSubview:_activityIndicator];
}

-(void)layoutSubviews
{
    CGFloat height = CGRectGetHeight(self.bounds);

    CGPoint imageCenter = CGPointMake(indent+profilePictureHeight/2,height/2);
    CGRect imageRect = (CGRect){CGPointZero,{profilePictureHeight,profilePictureHeight}};

    _profilePicture.frame = imageRect;
    _profilePicture.center = imageCenter;

    _activityIndicator.center = imageCenter;

    CGFloat commentWidth = CGRectGetWidth(self.bounds) - indent*2 - profilePictureHeight;
    CGRect commentRect = (CGRect){{indent*2+profilePictureHeight,indent},{commentWidth,height - indent*2}};

    _commentLabel.frame = CGRectIntegral(commentRect);

}

#pragma mark  - public methods

-(void)setCommentText:(NSString*)text
{
    _commentLabel.text = text;

    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];

    NSArray *ranges = [TagParser extractTagsFromString:text];

    for (NSValue * value in ranges)
    {
        [attributedString addAttribute:NSForegroundColorAttributeName
                                 value:[UIColor blueColor]
                                 range:value.rangeValue];

        [attributedString addAttribute:NSUnderlineStyleAttributeName value:@1 range:value.rangeValue];
    }
    _commentLabel.attributedText = attributedString;

}

-(void)setProfileImage:(UIImage*)image
{
    _profilePicture.image = image;
}

@end
