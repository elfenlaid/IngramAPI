#import "JSONParser.h"
#import "TagParser.h"
#import "PhotoComment.h"
#import "PhotoPost.h"


@implementation JSONParser

+(NSArray *)parseJSONFromDictionary:(NSDictionary *)json
{
    NSArray *data = [json objectForKey:@"data"];

    NSMutableArray *array = [[NSMutableArray alloc] init];

    for(NSDictionary *slots in data)
    {
        NSString *fullThumbnailPath = [[[slots objectForKey:@"images"] objectForKey:@"thumbnail"] objectForKey:@"url"];
        NSString *fullStandardPhotoPath = [[[slots objectForKey:@"images"] objectForKey:@"standard_resolution"] objectForKey:@"url"];
        NSURL *thumbnailURL = [NSURL URLWithString:fullThumbnailPath];
        NSURL *standardResolutionURL = [NSURL URLWithString:fullStandardPhotoPath];
        NSInteger countLikes = [[[slots objectForKey:@"likes"] objectForKey:@"count"] integerValue];
        NSString *namePhoto = [[slots objectForKey:@"user"] objectForKey:@"full_name"] ;

        NSDictionary *commentDictionary = [[slots objectForKey:@"comments"] objectForKey:@"data"];
        NSMutableArray *commentsArray = [[NSMutableArray alloc] init];

        for (NSDictionary *comment in commentDictionary)
        {
            NSString *commentText = [comment objectForKey:@"text"];


            if([TagParser countTagsFromString:commentText] > 0)
            {
                NSString *fullProfilePicturePath = [[comment objectForKey:@"from"] objectForKey:@"profile_picture"];
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
                                                       commentsArray:commentsArray];

        [array addObject:photoPost];
    }

    return [array copy];
}


@end