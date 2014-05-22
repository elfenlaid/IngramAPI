#import "JSONParser.h"
#import "TagParser.h"
#import "PhotoComment.h"
#import "PhotoPost.h"
#import "Page.h"
#import "PhotoLocation.h"

@implementation JSONParser

+(Page *)parseJSONFromDictionary:(NSDictionary *)json
{
    NSArray *data = json[@"data"];

    NSMutableArray *array = [[NSMutableArray alloc] init];

    for(NSDictionary *slots in data)
    {
        NSString *fullThumbnailPath = slots[@"images"][@"thumbnail"][@"url"];
        NSString *fullStandardPhotoPath = slots[@"images"][@"standard_resolution"][@"url"];
        NSURL *thumbnailURL = [NSURL URLWithString:fullThumbnailPath];
        NSURL *standardResolutionURL = [NSURL URLWithString:fullStandardPhotoPath];
        NSInteger countLikes = [slots[@"likes"][@"count"] integerValue];
        NSString *namePhoto = slots[@"user"][@"full_name"];

        NSDictionary * location = slots[@"location"];
        PhotoLocation *photoLocation = nil;
        if (location!= (id)[NSNull null])
        {
            photoLocation = [[PhotoLocation alloc] init];

            [photoLocation setLocationLatitude:[location[@"latitude"]  floatValue]
                                     longitude:[location[@"longitude"] floatValue]];
        }


        NSDictionary *commentDictionary = [[slots objectForKey:@"comments"] objectForKey:@"data"];
        NSMutableArray *commentsArray = [[NSMutableArray alloc] init];

        for (NSDictionary *comment in commentDictionary)
        {
            NSString *commentText = comment[@"text"];

            BOOL isNeedToAddComment = [TagParser countTagsFromString:commentText] >= 0;

            if(isNeedToAddComment)
            {
                NSString *fullProfilePicturePath = comment[@"from"][@"profile_picture"];
                NSURL *profilePictureURL = [NSURL URLWithString:fullProfilePicturePath];

                PhotoComment *photoComment = [[PhotoComment alloc] initWithProfilePictureURL:profilePictureURL
                                                                                 commentText:commentText];
                [commentsArray addObject:photoComment];
            }
        }


        PhotoPost *photoPost = [[PhotoPost alloc] initWithCountLikes:countLikes
                                                        thumbnailURL:thumbnailURL
                                               standardResolutionURL:standardResolutionURL
                                                            fullName:namePhoto
                                                       commentsArray:commentsArray
                                                            location:photoLocation];

        [array addObject:photoPost];
    }

    NSString *pathForNextURL = json[@"pagination"][@"next_url"];
    NSURL *nextURL = [NSURL URLWithString:pathForNextURL];

    Page *page = [Page pageWithNextURL:nextURL posts:[array copy]];

    return page;
}


@end