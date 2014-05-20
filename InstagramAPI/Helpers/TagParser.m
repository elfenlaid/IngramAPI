#import "TagParser.h"

static NSString *const hashRegexp = @"(#\\w+)";

@implementation TagParser

+ (NSArray *)extractTagsFromString:(NSString *)text {

    NSArray *tags = [self parseStringToArrayTags:text];

    NSMutableArray *tagRanges = [NSMutableArray array];
    for (NSTextCheckingResult* match in tags) {
        NSRange range = [match range];
        NSValue *rangeValue = [NSValue valueWithRange:range];
        [tagRanges addObject:rangeValue];
    }

    return tagRanges;
}

+(NSInteger)countTagsFromString:(NSString*)text
{
   return [self parseStringToArrayTags:text].count;
}

+(NSArray *)parseStringToArrayTags:(NSString *)text
{
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:hashRegexp
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    if (error) {
        NSLog(@"Failed to parse <%@> with error: %@", text, [error localizedDescription]);
        return nil;
    }

    NSArray *tags = [regex matchesInString:text options:NSMatchingReportCompletion range:NSMakeRange(0, text.length)];

    return tags;
}

@end