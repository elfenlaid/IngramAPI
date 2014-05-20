#import <Foundation/Foundation.h>



@interface TagParser : NSObject

+ (NSArray *)extractTagsFromString:(NSString *)text;

+ (NSInteger)countTagsFromString:(NSString *)text;
@end