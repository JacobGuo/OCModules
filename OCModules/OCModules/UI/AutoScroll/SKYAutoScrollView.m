//
//  SKYAutoScrollView.m
//

#import "SKYAutoScrollView.h"

@implementation SKYAutoScrollView
{
    int _curPage,_totalPages;
    NSMutableArray *_displays;  //current displaying views.
    BOOL _circle;
    NSTimer *_timer;
}
-(void)dealloc
{
    [self setAutoScroll:NO];
}
-(instancetype)initWithFrame:(CGRect)frame usingPageCtrl:(BOOL)usingPageCtrl circle:(BOOL)circle dataSource:(id<AutoScrollViewDataSource>)dataSource
{
    if (self = [super initWithFrame:frame]) {
        _circle = circle;
        _timerDuration = 1.0;
        _dataSource = dataSource;
        //add scrollView
        _scrollV = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollV.delegate = self;
        _scrollV.contentSize = CGSizeMake(self.bounds.size.width*3, self.bounds.size.height);//max reuse 3 numbers.
        _scrollV.pagingEnabled = YES;
        _scrollV.showsHorizontalScrollIndicator = NO;
        _scrollV.contentOffset = CGPointMake(self.bounds.size.width, 0);//default stay at middle.
        [self addSubview:_scrollV];
        //add pageCtrl
        if(usingPageCtrl){
            _pageCtrl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, frame.size.height-35, frame.size.width, 25)];
            _pageCtrl.userInteractionEnabled = NO;
            _pageCtrl.pageIndicatorTintColor = [UIColor grayColor];
            [self addSubview:_pageCtrl];
            [self bringSubviewToFront:_pageCtrl];
        }
        _curPage = 1;
        //load data
        NSParameterAssert(dataSource);
        [self reloadData];
        [self setAutoScroll:YES];
    }return self;
}

-(void)reloadData
{
    _totalPages = [_dataSource totalPages];
    if(_totalPages==0){return;}
    
    _pageCtrl.numberOfPages = _totalPages;
    _pageCtrl.currentPage = _curPage;
    
    //update all subViews of scrollView
    [_scrollV.subviews makeObjectsPerformSelector:@selector(removeFromSuperview) withObject:nil];
    
    //got views and add on scrollview
    _displays = [self getDisplayViewsByCurPage:_curPage];
    for(int i =0;i<_displays.count;i++){
        UIView*view = _displays[i];
        view.frame = CGRectMake(i*self.bounds.size.width, 0, self.bounds.size.width, self.bounds.size.height); //so not need to set the frame outside
        [self addTapGestureFotVIew:view];
        [_scrollV addSubview:view];
    }
    //reset contentSize&offset after add subviews
    if(_displays.count==3){
        _scrollV.contentSize = CGSizeMake(self.bounds.size.width * 3, self.bounds.size.height);
        //stay in middle
        _scrollV.contentOffset = CGPointMake(self.bounds.size.width, 0);
    }else{
        //only 1 or 2 pages.
        //whatever,we need to see second page.
        [_scrollV setContentOffset:CGPointMake(_curPage ==0?1:self.bounds.size.width, 0)];//1 for not need to preload at first.
        if (_curPage!=0) {
            _scrollV.contentSize = CGSizeMake(self.bounds.size.width, 0);
        }
    }
}
- (NSMutableArray*)getDisplayViewsByCurPage:(int)page
{
    NSMutableArray *array = [NSMutableArray new];
    int pre = [self validPageValue:page - 1];
    int last = [self validPageValue:page+1];
    
    //we got at least one page.
    if (pre >=0) {
        [array addObject:[_dataSource viewForPageIndex:pre]];
    }
    [array addObject:[_dataSource viewForPageIndex:page]];
    if (last >=0) {
        [array addObject:[_dataSource viewForPageIndex:last]];
    }
    return array;
}
#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_displays.count==1) {return;}
    
    CGFloat x = scrollView.contentOffset.x;
    if (x>=((_displays.count-1)*self.bounds.size.width)) { //come to the last one of current displays
       
        int page = [self validPageValue:_curPage+1];;
        if(page==-1){return;}
        
        _curPage = page;//got the next page
        [self loadNext];
    }
    
    if(x<=0){//actually we only need ==0
        int page = [self validPageValue:_curPage-1];
        if(page==-1){return;}
        
        _curPage = page;
        [self loadPre];
    }
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat x = (_displays.count==1||(_displays.count==2&&_curPage==0))?0:self.bounds.size.width;
    [_scrollV setContentOffset:CGPointMake(x, 0) animated:YES];
}
#pragma mark - utils
- (int)validPageValue:(int)value
{
    if (value==-1) {
        return _circle?_totalPages-1:value;
    }else if (value==_totalPages){
        return _circle?0:-1;
    }
    return value;
}

//manage 2 or >2 pages case
- (void)loadNext
{
    _pageCtrl.currentPage = _curPage;
    
    UIView *v;
    if(_displays.count==3){
        [_displays[0] removeFromSuperview];//throw the first one when load the third page.
        for(int i =0;i<2;i++){
            _displays[i] = _displays[i+1];
            v = _displays[i];
            v.frame = CGRectOffset(v.frame, v.frame.size.width*-1, 0);//move the pre 2 views left,keep the displaying view at middle.
        }
    }
    
    //preload the reuse one or delete the last index if not circle. .
    int next = [self validPageValue:_curPage+1];
    if (next >=0) {
        //preload
        if(_displays.count==3){
            _displays[2] = [_dataSource viewForPageIndex:next];
        }else{[_displays addObject:[_dataSource viewForPageIndex:next]];}//we add it to 3 pages since we got 2.
        v = _displays[2];
        v.frame = CGRectMake(self.bounds.size.width*2, 0, self.bounds.size.width, self.bounds.size.height);
        [_scrollV addSubview:v];
        [self addTapGestureFotVIew:v];
    }else if (_displays.count==3){
        //got the last and not circle.
        [_displays removeObjectAtIndex:2];
    }
    
    _scrollV.contentSize = CGSizeMake(_displays.count*self.bounds.size.width, self.bounds.size.height);//see up,may be we have delete 1
    
    _scrollV.contentOffset = CGPointMake(self.bounds.size.width, 0);//keep showing the _displaying[1],our final purpose.
}
- (void)loadPre
{
    _pageCtrl.currentPage = _curPage;
    
    if(_displays.count==3){[_displays[2] removeFromSuperview];}//bash the last one
    
    int pre = [self validPageValue:_curPage-1];
    if (pre>=0) {
        //move to right
        if(_displays.count==3){
            _displays[2] = _displays[1];
        }else{[_displays addObject:_displays[1]];}//1 ->2,0->1.
        UIView*v;
        _displays[1] = _displays[0];
        v =  _displays[0] = [_dataSource viewForPageIndex:pre];//preload
        v.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
         [_scrollV addSubview:_displays[0]];
        [self addTapGestureFotVIew:(UIView*)_displays[0]];
        for(int i=2;i>0;i--){
            v = _displays[i];
            v.frame = CGRectOffset(v.frame, self.bounds.size.width, 0);
        }
    }else{
        if(_displays.count==3){[_displays removeObjectAtIndex:2];}
    }
    _scrollV.contentSize = CGSizeMake(_displays.count*self.bounds.size.width, self.bounds.size.height);//see up,may be we have delete 1
    _scrollV.contentOffset = CGPointMake(pre>=0?self.bounds.size.width:1, 0);
}
- (void)addTapGestureFotVIew:(UIView*)v
{
    v.userInteractionEnabled = YES;//imageView default is NO,and this type is always we got.
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                action:@selector(tapping)];
    [v addGestureRecognizer:singleTap];
}
- (void)scrollToNext
{
    [_scrollV setContentOffset:CGPointMake((_displays.count-1)*self.bounds.size.width+1, 0) animated:NO];
}
#pragma mark - tapping
- (void)tapping
{
    if(_delegate&&[_delegate respondsToSelector:@selector(didClickPageIndex:)]){
        [_delegate didClickPageIndex:_curPage];
    }
}
#pragma mark - getters
-(UIView *)currentView{return _displays[1];}
#pragma mark - setters
-(void)setAutoScroll:(BOOL)autoScroll
{
    if(_autoScroll==autoScroll){return;}
    _autoScroll = autoScroll;
    if (_autoScroll) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:_timerDuration target:self selector:@selector(scrollToNext) userInfo:nil repeats:YES];
    }else{
        [_timer invalidate];
        _timer = nil;
    }
}
@end
