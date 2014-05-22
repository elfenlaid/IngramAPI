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
    //sdfgsdffhg

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

    for (NSUInteger i = 0; i < _dataSource.count; i++)
    {
        PhotoPost *post = [_dataSource objectAtIndex:i];

        Annotation *annotation = [[Annotation alloc] init];
        annotation.title = post.fullName;
        annotation.subtitle = [NSString stringWithFormat:@"likes:%i (comments:%i)",post.countLikes,post.commentsArray.count];
        annotation.coordinate = CLLocationCoordinate2DMake(post.location.latitude, post.location.longitude);
        annotation.indexAtDataSource = i;
        [_map addAnnotation:annotation];
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
    [segmentedControl setTintColor:[UIColor grayColor]];

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
        PhotoPost *post = [_dataSource objectAtIndex:custom.indexAtDataSource];
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
    NSUInteger index = annotation.indexAtDataSource;
    PhotoPost *post = [_dataSource objectAtIndex:index];
    CommentsViewController *controller = [[CommentsViewController alloc] initWithCommentsArray:post.commentsArray];
    [self.navigationController pushViewController:controller animated:YES];
}

@end
