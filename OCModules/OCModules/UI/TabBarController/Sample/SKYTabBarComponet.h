//
//  SKYTabBarComponet.h
//  OCModules
//
//  Created by SKY on 2017/9/4.

//  To confirm to the "TabBarComponentInterface" and Provide a tabBar for window.
//  Not need to set as global,window will autoly retain the tabBarCtrl,
//  Copyright © 2017年 JianpengGuo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKYTabBarController.h"

@interface SKYTabBarComponet : NSObject<TabBarComponentInterface>


@property(nonatomic,strong,readonly)SKYTabBarController *tabBarCtrl;
@end
