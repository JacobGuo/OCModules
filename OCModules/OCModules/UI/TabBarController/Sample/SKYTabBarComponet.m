//
//  SKYTabBarComponet.m
//

#import "SKYTabBarComponet.h"

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
    UIViewController *ctl = [UIViewController new];
    ctl.view.backgroundColor = [UIColor whiteColor];
    return ctl;
}
@end
