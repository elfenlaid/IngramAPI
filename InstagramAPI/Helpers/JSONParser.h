#import <Foundation/Foundation.h>

@class Page;


@interface JSONParser : NSObject

+ (Page *)parseJSONFromDictionary:(NSDictionary *)dictionary;

@end