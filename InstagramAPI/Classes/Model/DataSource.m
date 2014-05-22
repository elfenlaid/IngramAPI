#import "DataSource.h"
#import "Page.h"
#import "PhotoPost.h"


@interface DataSource()
{

}

@property (nonatomic, strong) NSArray *pages;

@end

@implementation DataSource

+ (instancetype)sourceWithPages:(NSArray *)pages
{
    return [[self alloc] initWithPages:pages];
}

- (instancetype)initWithPages:(NSArray *)pages
{
    self = [super init];
    if (self)
    {
        self.pages = pages;
    }

    return self;
}

-(PhotoPost *)objectAtIndexPath:(NSIndexPath*)indexPath
{
    Page *page = _pages[(NSUInteger) indexPath.section];
    PhotoPost *photoPost = [page objectAtIndex:(NSUInteger) indexPath.row];
    return photoPost;
}

- (void)fetchNextPage:(Page *)page
{
    NSMutableArray *pages = [NSMutableArray arrayWithArray:_pages];
    [pages addObject:page];
    _pages = [pages copy];
}

-(NSInteger)numberOfPhotoAtSection:(NSInteger)section
{
    Page *page = _pages[(NSUInteger) section];
    return [page count];
}

-(NSInteger)numberOfPages
{
    return _pages.count;
}

-(NSURL *)nextURL
{
   Page *page = [_pages lastObject];
   return [page nextURL];
}


-(BOOL)isEmpty
{
    int amountPost = 0;

    for (Page *page in _pages)
    {
        amountPost += page.count;
    }

    BOOL isEmpty = amountPost == 0;

    return isEmpty;
}

@end