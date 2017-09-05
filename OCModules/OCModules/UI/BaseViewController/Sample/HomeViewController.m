//
//  HomeViewController.m
//

#import "HomeViewController.h"
#import "SKYAutoScrollView.h"

@interface HomeViewController ()<AutoScrollViewDataSource,AutoScrollViewDelegate>

@property(nonatomic,strong)SKYAutoScrollView *adScroll;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
   
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    _adScroll = [[SKYAutoScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 100) usingPageCtrl:YES circle:YES dataSource:self];
    [self.view addSubview:_adScroll];
}
#pragma mark - AutoScrollViewDataSource
-(int)totalPages{return 4;}
-(UIView *)viewForPageIndex:(int)index
{
    UIView*view = [UIView new];
    if (index==0) {
        view.backgroundColor = [UIColor redColor];
    }else if (index==1){
        view.backgroundColor = [UIColor blueColor];
    }else if (index==2){
        view.backgroundColor = [UIColor blackColor];
    }
    else{view.backgroundColor = [UIColor greenColor];}
    return view;
}
#pragma AutoScrollViewDelegate
-(void)didClickPageIndex:(int)index
{
    NSLog(@"index is :%d",index);
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
