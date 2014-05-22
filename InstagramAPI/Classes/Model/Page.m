
#import "Page.h"
#import "PhotoPost.h"


@interface Page ()
{

}

@property (nonatomic,strong) NSURL *nextURL;
@property (nonatomic, strong) NSArray *posts;

@end

@implementation Page

+ (instancetype)pageWithNextURL:(NSURL *)nextURL posts:(NSArray *)posts
{
    return [[self alloc] initWithNextURL:nextURL posts:posts];
}

- (instancetype)initWithNextURL:(NSURL *)nextURL posts:(NSArray *)posts
{
    self = [super init];
    if (self)
    {
        _nextURL = nextURL;
        _posts = posts;
    }

    return self;
}

-(NSURL *)nextURL
{
    return _nextURL;
}

-(PhotoPost*)objectAtIndex:(NSUInteger)index
{
    return _posts[index];
}

-(NSUInteger)count
{
    return _posts.count;
}


@end