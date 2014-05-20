#import "SearchViewController.h"
#import "TableCell.h"
#import "DataLoader.h"
#import "DataSource.h"
#import "PhotoPost.h"
#import "TableCell+PhotoPost.h"
#import "CommentsViewController.h"

static NSString *const cellIdentifier = @"cellIdentifier";

static const int mockPostsCount = 300;
#define HEIGHT_NAVIGATION_CONTROLLER 64
#define SEARCH_BAR_RECT CGRectMake(0, 0, 290, 44)
#define NUMBER_OF_SECTION 1
#define HEIGHT_CELL 60
#define HEIGHT_KEYBOARD 215

#if DEBUG
#define SHOW_FAKE_PHOTOS 0
#import "PhotoPost+MockData.h"
#else
#define SHOW_FAKE_PHOTOS 0
#endif

@interface SearchViewController()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
{
    UISearchBar *_searchBar;
    UITableView *_tableView;
    UIActivityIndicatorView *_activityIndicator;
    DataLoader *_dataLoader;
    DataSource *_dataSource;
    UILabel *_noResult;
}

@end

@implementation SearchViewController


-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)viewDidLoad
{
    [super viewDidLoad];

    [self setupDataLoaderConfigure];
    [self setupSearchConfigure];
    [self setupActivityIndicatorConfigure];

}

#pragma mark - internals methods

-(void)setupSearchConfigure
{
    _searchBar = [[UISearchBar alloc] initWithFrame:SEARCH_BAR_RECT];
    _searchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.navigationItem.rightBarButtonItem =  [[UIBarButtonItem alloc]
            initWithCustomView:_searchBar];

    _searchBar.delegate = self;

}

-(void)setupTableViewConfigure
{
    _tableView = [[UITableView alloc] initWithFrame:[self tableRectWithExistKeyboard]];

    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = HEIGHT_CELL;
    _tableView.separatorInset = UIEdgeInsetsZero;
    _tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    _tableView.backgroundColor = [UIColor grayColor];

    [_tableView registerClass:[TableCell class] forCellReuseIdentifier:cellIdentifier];

    [self.view addSubview:_tableView];

}

-(void)setupActivityIndicatorConfigure
{
    _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _activityIndicator.center = self.view.center;
    _activityIndicator.hidesWhenStopped = YES;
    _activityIndicator.color = [UIColor blackColor];

    [self.view addSubview:_activityIndicator];

}

-(void)setupDataLoaderConfigure
{
    _dataLoader = [[DataLoader alloc] init];
}

-(void)setNoResultConfigureWithText:(NSString *)text
{
    _noResult = [[UILabel alloc] initWithFrame:self.view.frame];
    _noResult.textColor = [UIColor grayColor];
    _noResult.textAlignment = NSTextAlignmentCenter;
    [_noResult setFont:[UIFont systemFontOfSize:40]];
    _noResult.numberOfLines = 0;


    _noResult.text = text;


    [self.view addSubview:_noResult];
}

-(CGRect)tableRectWithExistKeyboard
{
    CGRect tableRect;
    if([_searchBar isFirstResponder])
    {
        tableRect = CGRectMake(0, 0,CGRectGetWidth(self.view.bounds),
                CGRectGetHeight(self.view.bounds) - HEIGHT_KEYBOARD);
    } else {
        tableRect = CGRectMake(0, 0,CGRectGetWidth(self.view.bounds),
                CGRectGetHeight(self.view.bounds));
    }
    return tableRect;
}

-(void)showCommentsAtIndexPath:(NSIndexPath*)indexPath
{
    PhotoPost *post = [_dataSource objectAtIndexPath:indexPath];

    CommentsViewController *controller = [[CommentsViewController alloc] initWithCommentsArray:post.commentsArray];

    [self.navigationController pushViewController:controller animated:YES];
}


#pragma mark - table view dataSource methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return NUMBER_OF_SECTION;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    TableCell *cell = (TableCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    PhotoPost *post = [_dataSource objectAtIndexPath:indexPath];

    [cell setupWithPost:post];

    return cell;
}

#pragma mark - table view delegate methods

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [_searchBar resignFirstResponder];

    [self showCommentsAtIndexPath:indexPath];

}


#pragma mark - search bar delegate methods

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [_activityIndicator startAnimating];
    [_noResult removeFromSuperview];
    [_tableView removeFromSuperview];

    #if SHOW_FAKE_PHOTOS

    [_activityIndicator stopAnimating];

    NSMutableArray *posts = [NSMutableArray array];
    for (int i = 0; i < mockPostsCount; i++)
    {
        [posts addObject:[PhotoPost randomMockPost]];
    }

    [self dataLoaderCallback:posts];

    #else

     [_dataLoader loadDataArrayForQuery:searchText withCallback:^(NSArray *array,NSError *error){
         if (!error) {
             [self dataLoaderCallback:array];
         } else {
             NSLog(@"%@",error.localizedDescription);
             [self setNoResultConfigureWithText:error.localizedDescription];
             [_activityIndicator stopAnimating];
             return;
         }
     }];

    #endif
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    _tableView.frame = [self tableRectWithExistKeyboard];
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
   _tableView.frame = [self tableRectWithExistKeyboard];
}

- (void)dataLoaderCallback:(NSArray *)array {
    [_activityIndicator stopAnimating];

    _dataSource = [[DataSource alloc] initWithArray:array];

    if(array.count > 0) {
        [self setupTableViewConfigure];
    } else {
        [self setNoResultConfigureWithText:@"Sorry,\n can't find \nanything :("];

    }
}

@end
