#import "DataSource.h"
#import "PhotoPost.h"


@interface DataSource()
{

}

@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation DataSource

-(id)initWithArray:(NSArray *)array
{
    self = [super init];
    if(self)
    {
       _dataArray = array;
    }
    return self;
}

- (PhotoPost *)objectAtIndexPath:(NSIndexPath *)path
{
    return self.dataArray[(NSUInteger) path.row];
}

- (PhotoPost *)objectAtIndex:(NSUInteger)index
{
    return self.dataArray[index];
}


- (NSInteger)count {
    return self.dataArray.count;
}
@end