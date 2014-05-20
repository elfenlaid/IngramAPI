
#import <Foundation/Foundation.h>

@interface PhotoPost : NSObject

@property (nonatomic, readonly) NSInteger countLikes;
@property (nonatomic, strong, readonly) NSURL*thumbnailURL;
@property (nonatomic, strong, readonly) NSURL*standardResolutionURL;
@property (nonatomic, strong, readonly) NSString *fullName;
@property (nonatomic, copy, readonly) NSArray *commentsArray;

- (instancetype)initWithCountLikes:(NSInteger)countLikes thumbnailURL:(NSURL *)thumbnailURL standardResolutionURL:(NSURL *)standardResolutionURL fullName:(NSString *)fullName commentsArray:(NSArray *)commentsArray;

+ (instancetype)postWithCountLikes:(NSInteger)countLikes thumbnailURL:(NSURL *)thumbnailURL standardResolutionURL:(NSURL *)standardResolutionURL fullName:(NSString *)fullName commentsArray:(NSArray *)commentsArray;


@end
