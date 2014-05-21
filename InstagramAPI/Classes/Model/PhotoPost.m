#import "PhotoPost.h"
#import "PhotoLocation.h"


@interface PhotoPost ()

@property (nonatomic, readwrite) NSInteger countLikes;
@property (nonatomic, strong, readwrite) NSURL*thumbnailURL;
@property (nonatomic, strong, readwrite) NSURL*standardResolutionURL;
@property (nonatomic, strong, readwrite) NSString *fullName;
@property  (nonatomic, copy, readwrite) NSArray *commentsArray;
@property (nonatomic, strong, readwrite) PhotoLocation *location;

@end



@implementation PhotoPost

- (instancetype)initWithCountLikes:(NSInteger)countLikes
                      thumbnailURL:(NSURL *)thumbnailURL
             standardResolutionURL:(NSURL *)standardResolutionURL
                          fullName:(NSString *)fullName
                     commentsArray:(NSArray *)commentsArray
                          location:(PhotoLocation *)location
{
    self = [super init];
    if (self) {
        _countLikes = countLikes;
        _thumbnailURL = thumbnailURL;
        _standardResolutionURL = standardResolutionURL;
        _fullName = fullName;
        _commentsArray=commentsArray;
        self.location=location;
    }

    return self;
}

+ (instancetype)postWithCountLikes:(NSInteger)countLikes
                      thumbnailURL:(NSURL *)thumbnailURL
             standardResolutionURL:(NSURL *)standardResolutionURL
                          fullName:(NSString *)fullName
                     commentsArray:(NSArray *)commentsArray
                          location:(PhotoLocation *)location
{
    return [[self alloc] initWithCountLikes:countLikes thumbnailURL:thumbnailURL standardResolutionURL:standardResolutionURL fullName:fullName commentsArray:commentsArray location:location];
}

@end

