#import "MapViewController.h"
#import <MapKit/MapKit.h>


@interface MapViewController()<MKMapViewDelegate>

@property (nonatomic, strong) MKMapView *map;

@end

@implementation MapViewController


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
   [_map setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
//   _map.delegate = self;

   [self.view addSubview:_map];
}

-(void)setupSegmentedControl
{
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"map",@"satellite",@"hybrid"]];
    
    [segmentedControl addTarget:self
                         action:@selector(segmentControlDidChangeSelectedIndex:)
               forControlEvents:UIControlEventValueChanged];

    CGRect segmentFrame = CGRectMake(50, 20, CGRectGetWidth(self.view.bounds)-100, 30);
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

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{

}


@end