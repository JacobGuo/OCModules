//
//  SKYTabBarController.h
//  OCModules
//
//  Created by SKY on 2017/9/4.
//  Copyright © 2017年 JianpengGuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TabBarComponentInterface;
@interface SKYTabBarController : UITabBarController

- (instancetype)initWithComponent:(id<TabBarComponentInterface>)component;

@property(nonatomic,weak,readonly)id<TabBarComponentInterface>component;
@end
/**
 ** Delegate to help tabBarCtrl to create components
 ** Decide each controller
 **/
@protocol TabBarComponentInterface <NSObject>

@required
- (NSArray*)imagesForTabBarItem;
- (NSArray*)selectedImagesForTabBarItem;
- (NSArray*)titlesForTabBarItem;
- (UIViewController*)viewControllerForIndex:(int)index;
@end
