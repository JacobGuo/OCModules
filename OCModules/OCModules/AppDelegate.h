//
//  AppDelegate.h
//  OCModules
//
//  Created by lczr on 2017/9/4.
//  Copyright © 2017年 JianpengGuo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

