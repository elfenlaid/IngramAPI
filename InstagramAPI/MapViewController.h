#import <Foundation/Foundation.h>

@class DataSource;

@interface MapViewController : UIViewController

- (id)init;

- (void)reloadAnnotationsWithDataSource:(DataSource *)dataSource;

@end