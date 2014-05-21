#import "AppDelegate.h"
#import "SearchViewController.h"
#import "TagParser.h"


@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];


    SearchViewController *searchViewController = [[SearchViewController alloc] init];

    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:searchViewController];

    navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;

    navigationController.navigationBar.tintColor = [UIColor whiteColor];

    self.window.rootViewController = navigationController;

    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

@end