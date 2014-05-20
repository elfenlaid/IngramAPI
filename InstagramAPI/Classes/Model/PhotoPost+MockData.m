#import "PhotoPost+MockData.h"


static const NSUInteger maxLikesCount = 1000000;

@implementation PhotoPost (MockData)

+ (instancetype)randomMockPost
{

    NSString *path = [self randomImagePath];
    NSURL *imageURL = [NSURL fileURLWithPath:path];

    NSUInteger likesCount = [self randomLikesCount];

    return [PhotoPost postWithCountLikes:likesCount thumbnailURL:imageURL standardResolutionURL:imageURL fullName:[imageURL.lastPathComponent componentsSeparatedByString:@"."][0] commentsArray:nil ];
}

+ (NSUInteger)randomLikesCount
{
    return arc4random() % maxLikesCount;
}

+ (NSString *)randomImagePath
{
    static NSArray *images;
    if (!images) {
        images = @[@"xCode", @"appCode", @"idea"];
    }

    NSString *fileName = images[arc4random() % images.count];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"png"];
    
    return filePath;
}

@end