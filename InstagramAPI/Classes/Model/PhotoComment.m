#import "PhotoComment.h"


@interface PhotoComment ()
{

}

@property (nonatomic, strong, readwrite) NSURL* profilePictureURL;
@property (nonatomic, strong, readwrite) NSString *commentText;

@end

@implementation PhotoComment

-(id)initWithProfilePictureURL:(NSURL *)url commentText:(NSString *)text
{
    self = [super init];
    if (self)
    {
        _commentText = text;
        _profilePictureURL = url;
    }
    return self;
}




@end