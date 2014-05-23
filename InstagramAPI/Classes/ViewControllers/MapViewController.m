#import "MapViewController.h"
#import "Annotation.h"
#import "DataSource.h"
#import "PhotoPost.h"
#import "PhotoLocation.h"
#import "CommentsViewController.h"

static NSString *const annotationIdentifier = @"annotationIdentifier";
static const CGFloat heightNavigationController = 64;
static const CGFloat heightSegmentControl = 30;
static const CGFloat cornerRadius = 5;
static const CGFloat heightAnnotaionPhoto = 40;


@interface MapViewController()<MKMapViewDelegate>

@property (nonatomic, strong) MKMapView *map;

@end

@implementation MapViewController
{
    DataSource *_dataSource;
}

- (id)init {
    self = [super init];
    if (self)
    {

    }
    return self;
}

-(void)viewDidLoad
{
    [super viewDidLoad];

    [self setupMap];
    [self setupSegmentedControl];
}

#pragma mark - internal methods

-(void)setupMap
{

    _map = [[MKMapView alloc] initWithFrame:self.view.frame];
    _map.showsUserLocation = YES;
    _map.delegate = self;

    [self.view addSubview:_map];
}

-(void)reloadAnnotationsWithDataSource:(DataSource *)dataSource
{
    _dataSource = dataSource;

    [_map removeAnnotations:_map.annotations];

    NSInteger amountSections = _dataSource.numberOfPages;

    for (NSInteger currentSection = 0; currentSection < amountSections; currentSection++)
    {
        NSInteger amountRows = [_dataSource numberOfPhotoAtSection:currentSection];

        for (NSInteger row = 0 ; row < amountRows; row++)
        {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:currentSection];
            PhotoPost *post = [_dataSource objectAtIndexPath:indexPath];
            Annotation *annotation = [[Annotation alloc] init];
            annotation.title = post.fullName;
            annotation.subtitle = [NSString stringWithFormat:@"likes:%i (comments:%i)", post.countLikes, post.commentsArray.count];
            annotation.coordinate = CLLocationCoordinate2DMake(post.location.latitude, post.location.longitude);
            annotation.indexPathAtDataSource = indexPath;
            [_map addAnnotation:annotation];
        }
    }

}

-(void)setupSegmentedControl
{
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"map",@"satellite",@"hybrid"]];

    [segmentedControl addTarget:self
                         action:@selector(segmentControlDidChangeSelectedIndex:)
               forControlEvents:UIControlEventValueChanged];

    CGRect segmentFrame = CGRectMake(50,10+heightNavigationController, CGRectGetWidth(self.view.bounds)-100,heightSegmentControl);
    segmentedControl.frame = segmentFrame;
    segmentedControl.selectedSegmentIndex = 0;
    [segmentedControl setTintColor:[UIColor blackColor]];

    [self.view addSubview:segmentedControl];

}

-(IBAction)segmentControlDidChangeSelectedIndex:(UISegmentedControl *)control
{
    NSInteger selectedIndex = control.selectedSegmentIndex;

    switch (selectedIndex)
    {
        case 0:_map.mapType = MKMapTypeStandard;  break;
        case 1:_map.mapType = MKMapTypeSatellite;  break;
        case 2:_map.mapType = MKMapTypeHybrid;   break;
        default: break;
    }
}

#pragma mark - map view delegate methods

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if (annotation == _map.userLocation)
    {
        return nil;
    }

    MKPinAnnotationView *annotationView = (MKPinAnnotationView *) [mapView dequeueReusableAnnotationViewWithIdentifier:annotationIdentifier];

    if (annotationView == nil)
    {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
                                                         reuseIdentifier:annotationIdentifier];
        annotationView.canShowCallout = YES;
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        annotationView.rightCalloutAccessoryView = rightButton;

        UIImageView *leftImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, heightAnnotaionPhoto, heightAnnotaionPhoto)];
        leftImage.layer.cornerRadius = cornerRadius;
        leftImage.clipsToBounds = YES;

        annotationView.leftCalloutAccessoryView =  leftImage;
        Annotation *custom= (Annotation *)annotation;
        PhotoPost *post = [_dataSource objectAtIndexPath:custom.indexPathAtDataSource];
        NSURL *imageURL = post.thumbnailURL;

        dispatch_async(dispatch_get_global_queue(0, 0),^{
            NSData *data = [NSData dataWithContentsOfURL:imageURL];
            UIImage *image = [UIImage imageWithData:data];

            dispatch_async(dispatch_get_main_queue(), ^{
                leftImage.image = image;
            });
        });

    }
    return annotationView;
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    Annotation *annotation = (Annotation *) view.annotation;
    NSIndexPath * indexPath = annotation.indexPathAtDataSource;
    PhotoPost *post = [_dataSource objectAtIndexPath:indexPath];
    CommentsViewController *controller = [[CommentsViewController alloc] initWithCommentsArray:post.commentsArray];
    [self.navigationController pushViewController:controller animated:YES];



}

@end
