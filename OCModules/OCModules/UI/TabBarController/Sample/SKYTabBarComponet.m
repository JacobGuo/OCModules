//
//  SKYTabBarComponet.m
//

#import "SKYTabBarComponet.h"
#import "HomeViewController.h"
#import "MyViewController.h"
@implementation SKYTabBarComponet

-(instancetype)init
{
    if (self = [super init]) {
        _tabBarCtrl = [[SKYTabBarController alloc] initWithComponent:self];
    }return self;
}

#pragma mark - TabBarComponentInterface
- (NSArray*)imagesForTabBarItem
{
    return @[@"menu_1_off",@"menu_4_off"];
}
- (NSArray*)titlesForTabBarItem
{
    return @[@"Home",@"My"];
}
-(NSArray *)selectedImagesForTabBarItem
{
    return @[@"menu_1_on",@"menu_4_on"];
}
- (UIViewController*)viewControllerForIndex:(int)index
{
    //create all tabBar viewControllers you need here.
    return index == 0?[HomeViewController new]:[MyViewController new];
}
//Optional
-(void)makeSomeDetailOfNavigationBar:(UINavigationBar *)naviBar atIndex:(int)index
{
    //setup backgroundColor of navigationBar,will also make the bar's translucent = NO,
    naviBar.barTintColor = [UIColor groupTableViewBackgroundColor];
    
    UIColor *appColor = [UIColor colorWithRed:245/255.f green:52/255.f blue:0 alpha:1.0f];//should read from app configuration
    //set title attrs
    [naviBar setTitleTextAttributes:@{NSForegroundColorAttributeName:appColor}];
    
    //set backgroundImage(will cover the barTintColor setting.just choose one)
    //have a strict command on image height and take care of lanscape and portrait case.
    [naviBar  setBackgroundImage:[UIImage imageNamed:@"nav_background"] forBarMetrics:UIBarMetricsCompact];
    
    //set default buttonItem(left,right,etc...) color.you should reset in some special viewController if needed.
    naviBar.tintColor = appColor;
    
    //default is NO of iOS >=7.0,anyway,if you need to adapt the iOS6,just set it.
    naviBar.translucent = NO;
    
    //reset the back style(default with the title of pre viewController)
    //leftBarButtonItem > backItem.backBarButtonItem > backItem(the fronts will cover the behinds if explictly set.)
    //if set leftBarButtonItem or backBarButtonItem,will make the "interactivePopGestureRecognizer" disable and if you still want the gesture effect,you should manuly respond to "add target" of the interactivePopGestureRecognizer.
    naviBar.backItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_arrow"] style:UIBarButtonItemStylePlain target:nil action:nil];
}
@end
