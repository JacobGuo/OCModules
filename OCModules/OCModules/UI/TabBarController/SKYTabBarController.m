//
//  SKYTabBarController.m
//

#import "SKYTabBarController.h"
#import <objc/runtime.h>
@interface SKYTabBarController ()

@end

@implementation SKYTabBarController

-(instancetype)initWithComponent:(id<TabBarComponentInterface>)component
{
    if (self = [super init]) {
        //using runtime to help retains.
        _component = component;
        NSArray *images = [_component imagesForTabBarItem].copy;
        NSArray*titles = [_component titlesForTabBarItem].copy;
        NSArray *seleImgs = [_component selectedImagesForTabBarItem].copy;
        NSAssert(images.count==titles.count&&titles.count==seleImgs.count, @"Titles and images for tabBarItem should got the same count!");
        NSMutableArray *viewCtls = [NSMutableArray arrayWithCapacity:0];
        int totals = (int)images.count;
        for(int i =0;i<totals;i++){
            UIViewController *ctl = [_component viewControllerForIndex:i];
            UINavigationController *navi = [self viewCtr:ctl title:titles[i] img:images[i] seleImg:seleImgs[i]];
            if([_component respondsToSelector:@selector(makeSomeDetailOfNavigationBar:atIndex:)]){
                [_component makeSomeDetailOfNavigationBar:navi.navigationBar atIndex:i];
            }
            [viewCtls addObject:navi];
        }
        [self setViewControllers:viewCtls];
        self.tabBar.translucent = NO;
    }return self;
}

#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - utils
- (UINavigationController*)viewCtr:(UIViewController*)ctl title:(NSString*)title img:(NSString*)img seleImg:(NSString*)seleImg
{
    NSParameterAssert([ctl isKindOfClass:[UIViewController class]]&&ctl);
    ctl.title = title;
    UIImage *selectedImg = [UIImage imageNamed:seleImg];
    /* UIImageRenderingModeAlwaysOriginal: 防止系统渲染tintColor*/
    ctl.tabBarItem = [self itemForTitle:title img:[UIImage imageNamed:img] selImg:[selectedImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:ctl];
    return nav;
}
- (UITabBarItem*)itemForTitle:(NSString*)title img:(UIImage*)img selImg:(UIImage*)selImg
{
    //modify some details here if needed,such as forgroundColor or fontSize
    UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:title image:img selectedImage:selImg];
    CGFloat fontSize = 14;
    [item setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor grayColor],NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} forState:UIControlStateNormal];
    [item setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:245/255.f green:52/255.f blue:0 alpha:1.0f],NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} forState:UIControlStateSelected];
    return item;
}
@end
