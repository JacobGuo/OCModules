//
//  SKYTabBarComponet.h
//  OCModules
//
//  Created by SKY on 2017/9/4.

//  To confirm to the "TabBarComponentInterface" and Provide a tabBar for window.
//  Copyright © 2017年 JianpengGuo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKYTabBarController.h"

@interface SKYTabBarComponet : NSObject<TabBarComponentInterface>


@property(nonatomic,strong,readonly)SKYTabBarController *tabBarCtrl;
@end
