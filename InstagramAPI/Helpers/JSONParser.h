#import <Foundation/Foundation.h>


@interface JSONParser : NSObject

+ (NSArray *)parseJSONFromDictionary:(NSDictionary *)dictionary;
@end