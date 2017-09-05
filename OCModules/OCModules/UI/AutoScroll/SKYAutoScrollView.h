//
//  SKYAutoScrollView.h
//  OCModules
//
//  Idea from internet,and lost the source url from..
//  Mainly we need to do is move the next displaying view(pre or next)at views[1] and preload the view when arrive at the bound page(0 or 2)
//
//  Created by SKY on 2017/9/5.
//  Copyright © 2017年 JianpengGuo. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol AutoScrollViewDataSource,AutoScrollViewDelegate;
@interface SKYAutoScrollView : UIView<UIScrollViewDelegate>

-(instancetype)initWithFrame:(CGRect)frame usingPageCtrl:(BOOL)usingPageCtrl circle:(BOOL)circle dataSource:(id<AutoScrollViewDataSource>)dataSource;

@property(nonatomic,assign)BOOL autoScroll;                                 //default is YES
@property(nonatomic,assign)NSTimeInterval timerDuration;            //default is 6.0
@property(nonatomic,weak)id<AutoScrollViewDelegate>delegate;
@property(nonatomic,weak,readonly)id<AutoScrollViewDataSource>dataSource;

//to do more details if needed.
@property(nonatomic,strong,readonly)UIScrollView*scrollV;
@property(nonatomic,strong,readonly)UIPageControl*pageCtrl;
@property(nonatomic,strong,readonly)UIView *currentView;

//generally will not use,anyway....
- (void)reloadData;
@end

//we got views from outside.
@protocol AutoScrollViewDataSource <NSObject>

- (int)totalPages;
- (UIView*)viewForPageIndex:(int)index;
@end
//sometimes we need jump to the next VC
@protocol AutoScrollViewDelegate <NSObject>

@optional
- (void)didClickPageIndex:(int)index;
@end
