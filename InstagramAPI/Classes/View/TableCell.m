#import "TableCell.h"


static const float indentSaveButton = 10;

#define INDENT_IMAGE 3
#define INDENT_NAME 5
#define INDENT_ACCESSORY_TYPE 20
#define LIKES_SIZE 20


@interface TableCell()<UIScrollViewDelegate>
{

}

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIButton *saveButton;
@property (nonatomic, strong) UIView *scrollBackgroundView;
@property  (nonatomic) BOOL isHiddenSaveButton;

@end


@implementation TableCell
{
    UIImageView *_imageView;
    UILabel *_nameLabel;
    UILabel *_likesLabel;
    UIImageView *_likeImageView;
    UILabel *_countCommentlabel;
    NSURL *_imageURL;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        self.accessoryType  = UITableViewCellAccessoryDisclosureIndicator;
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        [self setupScrollView];

        [self setupImageLikesConfigure];
        [self setupImageView];
        [self setupLikesConfigure];
        [self setupNameConfigure];
        [self setupActivityIndicatorConfigure];
        [self setupCountCommentLabel];

    }
    return self;
}

#pragma mark - internals methods

 -(void)setupScrollView
 {
     _saveButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
     _saveButton.backgroundColor = [UIColor grayColor];
     [_saveButton setTitle:@"SAVE" forState:UIControlStateNormal];
     [_saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
     [_saveButton sizeToFit];
     _isHiddenSaveButton = YES;

     [self.contentView addSubview:self.saveButton];

     _scrollBackgroundView = [[UIView alloc]  init];
     _scrollBackgroundView.backgroundColor = [UIColor whiteColor];


     _scrollView = [[UIScrollView alloc] init];
     _scrollView.delegate = self;
     _scrollView.showsHorizontalScrollIndicator = NO;

     [self.contentView addSubview:_scrollView];
     [_scrollView addSubview:_scrollBackgroundView];

 }

-(void)setupImageView
{
   _imageView = [[UIImageView alloc] init];

   _imageView.layer.cornerRadius = 5;
   _imageView.clipsToBounds = YES;

    [_scrollView addSubview:_imageView];
}

-(void)setupNameConfigure
{
    _nameLabel = [[UILabel alloc]  init];
    _nameLabel.textColor = [UIColor blackColor];
    _nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
//  _nameLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];

    [_scrollView addSubview:_nameLabel];
}

-(void)setupLikesConfigure
{

    _likesLabel = [[UILabel alloc]  init];
    _likesLabel.textColor = [UIColor blackColor];
    _likesLabel.font = [UIFont systemFontOfSize:14.0f];

    [_scrollView addSubview:_likesLabel];

}

-(void)setupImageLikesConfigure
{
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"like.png"];

    _likeImageView = imageView;

   [_scrollView addSubview:imageView];
}

-(void)setupCountCommentLabel
{
    _countCommentlabel = [[UILabel alloc] init];
    _countCommentlabel.textColor = [UIColor blackColor];
    _countCommentlabel.font = [UIFont systemFontOfSize:13.0f];
    [_countCommentlabel setTextColor:[UIColor grayColor]];

    [_scrollView addSubview:_countCommentlabel];

}

-(void)setupActivityIndicatorConfigure
{

    _activityIndicator = [[UIActivityIndicatorView alloc] init];
    _activityIndicator.hidesWhenStopped = YES;
    _activityIndicator.color = [UIColor blackColor];

    [_scrollView addSubview:_activityIndicator];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    CGFloat height = CGRectGetHeight(self.bounds);

    _saveButton.frame = (CGRect){CGPointZero, {height, height}};
    _saveButton.center = CGPointMake(-_saveButton.center.x, _saveButton.center.y);

    _scrollView.frame = self.contentView.bounds;
    _scrollView.contentSize = (CGSize){CGRectGetWidth(self.contentView.bounds) + 1, CGRectGetHeight(self.contentView.bounds)};

    _scrollBackgroundView.frame = _scrollView.bounds;

    CGFloat heightImage = height - 2* INDENT_IMAGE;
    CGRect imageRect = CGRectMake(INDENT_IMAGE, INDENT_IMAGE, heightImage, heightImage);
    _imageView.frame = imageRect;

    CGRect nameLabelRect = CGRectMake(height+ INDENT_NAME, INDENT_NAME,
            CGRectGetWidth(self.frame)-height- 2*INDENT_NAME - INDENT_ACCESSORY_TYPE,height/2);
    _nameLabel.frame = nameLabelRect;

    CGRect likesRect = CGRectMake(height+ 2*INDENT_NAME+LIKES_SIZE,height/2,
            (CGRectGetWidth(self.frame) - height - 2*INDENT_NAME - LIKES_SIZE)/2 - INDENT_ACCESSORY_TYPE , LIKES_SIZE);
    _likesLabel.frame = likesRect;

    CGRect countCommentRect = CGRectOffset(likesRect, CGRectGetWidth(likesRect), 0);
    _countCommentlabel.frame = countCommentRect;

    CGRect likesImageViewFrame = CGRectMake(height+ INDENT_NAME,height/2, LIKES_SIZE, LIKES_SIZE);
    _likeImageView.frame = likesImageViewFrame;

    _activityIndicator.center = _imageView.center;
}


#pragma mark - public methods


-(void)setNameText:(NSString*)name
{
  _nameLabel.text = name;
}

-(void)setLikesCount:(NSInteger)count
{
  _likesLabel.text = [NSString stringWithFormat:@"%i",count];
}


-(void)setImage:(UIImage*)image
{
    _imageView.image = image;
}

-(void)setCountComment:(NSUInteger)count
{
    _countCommentlabel.text = [NSString stringWithFormat:@"(comments:%u)",count];
}

-(void)setImageURL:(NSURL*)url
{
    _imageURL = url;
}


#pragma mark - scroll view delegate methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    CGPoint contentOffset = scrollView.contentOffset;

    contentOffset.x = -MIN(contentOffset.x, 0);

    CGFloat showSaveImageDelta = CGRectGetWidth(self.saveButton.bounds);


    BOOL isNeedToShowSaveButton = (showSaveImageDelta + indentSaveButton) > contentOffset.x;

     if (isNeedToShowSaveButton != _isHiddenSaveButton)
     {
       _isHiddenSaveButton = isNeedToShowSaveButton;
      [self moveSavedButton];
     }

}

-(void)moveSavedButton
{
    [UIView animateWithDuration:0.25f animations:^{
        _saveButton.center = CGPointMake(-_saveButton.center.x, _saveButton.center.y);
    }];

}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(__unused BOOL)decelerate {
    CGFloat showSaveImageDelta = -CGRectGetWidth(self.saveButton.bounds);
    BOOL isSaveChoose = showSaveImageDelta > scrollView.contentOffset.x;
    if (isSaveChoose)
    {
       [self downloadImage];
    }
}


-(void)downloadImage
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    });

    dispatch_async(dispatch_get_global_queue(0,0),^{
        NSData *data = [NSData dataWithContentsOfURL:_imageURL];
        UIImage *standardResolutionImage = [UIImage imageWithData:data];
        UIImageWriteToSavedPhotosAlbum(standardResolutionImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);

        dispatch_async(dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        });
    });
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo: (void *) contextInfo
{

    NSString *message = error?@"FAIL":@"SUCCESSFUL";


    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:message
                                                        message:error.localizedDescription
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
}



@end
