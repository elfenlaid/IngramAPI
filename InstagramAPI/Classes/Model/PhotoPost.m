#import "PhotoPost.h"


@interface PhotoPost ()
@property (nonatomic, readwrite) NSInteger countLikes;
@property (nonatomic, strong, readwrite) NSURL*thumbnailURL;
@property (nonatomic, strong, readwrite) NSURL*standardResolutionURL;
@property (nonatomic, strong, readwrite) NSString *fullName;
@property  (nonatomic, copy, readwrite) NSArray *commentsArray;
@end

@implementation PhotoPost

- (instancetype)initWithCountLikes:(NSInteger)countLikes thumbnailURL:(NSURL *)thumbnailURL standardResolutionURL:(NSURL *)standardResolutionURL fullName:(NSString *)fullName commentsArray:(NSArray *)commentsArray
{
    self = [super init];
    if (self) {
        _countLikes = countLikes;
        _thumbnailURL = thumbnailURL;
        _standardResolutionURL = standardResolutionURL;
        _fullName = fullName;
        _commentsArray=commentsArray;
    }

    return self;
}

+ (instancetype)postWithCountLikes:(NSInteger)countLikes thumbnailURL:(NSURL *)thumbnailURL standardResolutionURL:(NSURL *)standardResolutionURL fullName:(NSString *)fullName commentsArray:(NSArray *)commentsArray
{
    return [[self alloc] initWithCountLikes:countLikes
                               thumbnailURL:thumbnailURL
                      standardResolutionURL:standardResolutionURL
                                   fullName:fullName
                              commentsArray:commentsArray];
}

@end

