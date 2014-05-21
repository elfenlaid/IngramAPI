
#import <Foundation/Foundation.h>

@class PhotoLocation;

@interface PhotoPost : NSObject

@property (nonatomic, readonly) NSInteger countLikes;
@property (nonatomic, strong, readonly) NSURL*thumbnailURL;
@property (nonatomic, strong, readonly) NSURL*standardResolutionURL;
@property (nonatomic, strong, readonly) NSString *fullName;
@property (nonatomic, copy, readonly) NSArray *commentsArray;
@property (nonatomic, strong, readonly) PhotoLocation *location;

- (instancetype)initWithCountLikes:(NSInteger)countLikes thumbnailURL:(NSURL *)thumbnailURL standardResolutionURL:(NSURL *)standardResolutionURL fullName:(NSString *)fullName commentsArray:(NSArray *)commentsArray location:(PhotoLocation *)location;

+ (instancetype)postWithCountLikes:(NSInteger)countLikes thumbnailURL:(NSURL *)thumbnailURL standardResolutionURL:(NSURL *)standardResolutionURL fullName:(NSString *)fullName commentsArray:(NSArray *)commentsArray location:(PhotoLocation *)location;


@end
