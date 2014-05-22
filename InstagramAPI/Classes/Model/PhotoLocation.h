#import <Foundation/Foundation.h>


@interface PhotoLocation : NSObject

@property  (nonatomic) CGFloat latitude;
@property  (nonatomic) CGFloat longitude;

- (void)setLocationLatitude:(CGFloat)latitude longitude:(CGFloat)longitude;

@end