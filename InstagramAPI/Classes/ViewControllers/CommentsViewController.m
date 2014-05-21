#import "CommentsViewController.h"
#import "CommentCell.h"
#import "CommentCell+CommentPost.h"
#import "CommentCell.h"
#import "PhotoComment.h"


static NSString *const commentCellIdentifier = @"commentCellIdentifier";
static CGFloat const profilePictureHeight = 50.0f;



@interface CommentsViewController()<UITableViewDataSource,UITableViewDelegate>
{

}

@property (nonatomic, strong) UITableView * commentsTable;

@end

@implementation CommentsViewController
{
    NSArray *_commentsArray;
}

-(id)initWithCommentsArray:(NSArray *)comments
{
    self = [super initWithNibName:nil bundle:nil];
    if(self)
    {
        _commentsArray = comments;
    }
    return self;
}

-(void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];

    self.title = @"COMMENTS";

    [self setupCommentsTable];

}

#pragma mark - internals methods

-(void)setupCommentsTable
{
    BOOL isThereCommentsToShow = _commentsArray.count > 0;
    if(isThereCommentsToShow)
    {
        CGRect _tableRect  = self.view.frame;
        _commentsTable = [[UITableView alloc] initWithFrame:_tableRect];

        _commentsTable.separatorInset = UIEdgeInsetsZero;
        _commentsTable.separatorColor = [UIColor blackColor];

        _commentsTable.delegate = self;
        _commentsTable.dataSource = self;

        [_commentsTable registerClass:[CommentCell class] forCellReuseIdentifier:commentCellIdentifier];

        [self.view addSubview:_commentsTable];
    } else 
    {
        [self showNoCommentWithText:@"sorry,\n no comments"];
    }
}

-(void)showNoCommentWithText:(NSString*)text
{
    UILabel * noResult = [[UILabel alloc] initWithFrame:self.view.frame];
    noResult.textColor = [UIColor grayColor];
    noResult.textAlignment = NSTextAlignmentCenter;
    [noResult setFont:[UIFont systemFontOfSize:40]];
    noResult.numberOfLines = 0;

    noResult.text = text;

    [self.view addSubview:noResult];
}

#pragma mark - table view data source methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _commentsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:commentCellIdentifier forIndexPath:indexPath];

    PhotoComment *comment = [_commentsArray objectAtIndex:(NSUInteger) indexPath.row];

    [cell setupWithPost:comment];

    return cell;
}

#pragma  mark - table view delegate methods

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoComment *comment = [_commentsArray objectAtIndex:(NSUInteger) indexPath.row];
    NSString *cellText = comment.commentText;

//    UIFont *cellFont = [UIFont preferredFontForTextStyle: UIFontTextStyleBody ];
    UIFont *cellFont = [UIFont fontWithName:@"Helvetica-Bold" size:17.0f];

    CGSize constraintSize = CGSizeMake(320.0f - profilePictureHeight, MAXFLOAT);

    CGSize labelSize = [cellText sizeWithFont:cellFont constrainedToSize:constraintSize];

    return MAX(labelSize.height + 20.0f,profilePictureHeight + 10.0f);
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}



@end