#import <Foundation/Foundation.h>


@interface  PhotoComment : NSObject


@property (nonatomic,strong, readonly) NSURL* profilePictureURL;
@property (nonatomic,strong, readonly) NSString *commentText;


- (id)initWithProfilePictureURL:(NSURL *)url commentText:(NSString *)text;


@end