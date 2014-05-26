#import "TableCell.h"


static const float indentSaveButton = 20;
static const float defaultDuration = 0.25f;

#define INDENT_IMAGE 3
#define INDENT_NAME 5
#define INDENT_ACCESSORY_TYPE 20
#define LIKES_SIZE 20
#define CORNER_RADIUS 5


@interface TableCell()<UIGestureRecognizerDelegate>
{

}

@property (nonatomic,strong) UIButton *saveButton;
@property (nonatomic) BOOL isHiddenSaveButton;

@end


@implementation TableCell
{
    UIImageView *_imageView;
    UILabel *_nameLabel;
    UILabel *_likesLabel;
    UIImageView *_likeImageView;
    UILabel *_countCommentlabel;
    NSURL *_imageURL;


    UIPanGestureRecognizer *_panRecognizer;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        self.accessoryType  = UITableViewCellAccessoryDisclosureIndicator;
        self.selectionStyle = UITableViewCellSelectionStyleGray;

        [self setupImageLikesConfigure];
        [self setupImageView];
        [self setupLikesConfigure];
        [self setupNameConfigure];
        [self setupActivityIndicatorConfigure];
        [self setupCountCommentLabel];
        [self setupGestureRecognizers];
        [self setupSaveButton];
    }
    return self;
}

#pragma mark - internals methods

-(void)setupSaveButton
{
    _saveButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _saveButton.backgroundColor = [UIColor grayColor];
    [_saveButton setTitle:@"save" forState:UIControlStateNormal];
    [_saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _isHiddenSaveButton = YES;

    [self addSubview:_saveButton];
}

- (void)setupGestureRecognizers
{
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panRecognizer:)];
    panRecognizer.delegate = self;
    
    _panRecognizer = panRecognizer;

    [self addGestureRecognizer:panRecognizer];
}


-(IBAction)panRecognizer:(UIPanGestureRecognizer *)recognizer
{

    if(recognizer.state == UIGestureRecognizerStateEnded)
    {
        [UIView animateWithDuration: defaultDuration animations:^{
            self.frame = (CGRect){CGPointMake(0, self.frame.origin.y),self.frame.size};

            if (!_isHiddenSaveButton)
            {
                [self downloadImage];
            }
            _isHiddenSaveButton = YES;

        }];
        return;
    }

    CGFloat translationCell = [recognizer translationInView:self].x;
    translationCell = translationCell > 0 ? translationCell:0;
    CGFloat maxTranslation = (CGRectGetWidth(_saveButton.frame) + indentSaveButton*2);
    translationCell = translationCell > maxTranslation ? maxTranslation : translationCell;
    self.frame =  (CGRect){CGPointMake(translationCell, self.frame.origin.y),self.frame.size};

    CGFloat positionSaveButton = _isHiddenSaveButton? -CGRectGetWidth(_saveButton.frame):0;
    CGRect saveButtonRect = (CGRect){CGPointMake(-translationCell+positionSaveButton,0),_saveButton.frame.size};

    _saveButton.frame = saveButtonRect;

    BOOL isNeedHiddenSaveButton = translationCell < CGRectGetWidth(_saveButton.frame) + indentSaveButton;
    if (isNeedHiddenSaveButton != _isHiddenSaveButton)
    {
        _isHiddenSaveButton = !_isHiddenSaveButton;
        positionSaveButton = _isHiddenSaveButton? -CGRectGetWidth(_saveButton.frame):0;
        saveButtonRect = (CGRect){CGPointMake(-translationCell-positionSaveButton,0),_saveButton.frame.size};
        [UIView animateWithDuration:defaultDuration animations:^{
            _saveButton.frame = saveButtonRect;
        }];
    }

}

-(void)setupImageView
{
    _imageView = [[UIImageView alloc] init];

    _imageView.layer.cornerRadius = CORNER_RADIUS;
    _imageView.clipsToBounds = YES;

    [self addSubview:_imageView];
}

-(void)setupNameConfigure
{
    _nameLabel = [[UILabel alloc]  init];
    _nameLabel.textColor = [UIColor blackColor];
    _nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;

    [self addSubview:_nameLabel];
}

-(void)setupLikesConfigure
{

    _likesLabel = [[UILabel alloc]  init];
    _likesLabel.textColor = [UIColor blackColor];
    _likesLabel.font = [UIFont systemFontOfSize:14.0f];

    [self addSubview:_likesLabel];

}

-(void)setupImageLikesConfigure
{
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"like.png"];

    _likeImageView = imageView;

    [self addSubview:imageView];
}

-(void)setupCountCommentLabel
{
    _countCommentlabel = [[UILabel alloc] init];
    _countCommentlabel.textColor = [UIColor blackColor];
    _countCommentlabel.font = [UIFont systemFontOfSize:13.0f];
    [_countCommentlabel setTextColor:[UIColor grayColor]];

    [self addSubview:_countCommentlabel];

}

-(void)setupActivityIndicatorConfigure
{

    _activityIndicator = [[UIActivityIndicatorView alloc] init];
    _activityIndicator.hidesWhenStopped = YES;
    _activityIndicator.color = [UIColor blackColor];

    [self addSubview:_activityIndicator];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    CGFloat height = CGRectGetHeight(self.bounds);

    CGRect saveButtonFrame = CGRectMake(-height,0, height, height);
    _saveButton.frame = saveButtonFrame;

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

#pragma mark -  UIGestureRecognizersDelegate methods

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer == _panRecognizer)
    {
        CGPoint translation = [_panRecognizer translationInView:self];
        BOOL gestureShouldBegin = fabs(translation.x) > fabs(translation.y);
        return gestureShouldBegin;
    }

    return YES;
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo: (void *) contextInfo
{

    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"FAIL"
                                                        message:error.localizedDescription
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];

    if (error)
    {
        [alertView show];
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


@end
