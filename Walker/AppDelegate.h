//
//  AppDelegate.h
//  Walker
//
//  Created by Bruno Macedo on 01/04/11.
//  Copyright home 2011. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
}

@property (nonatomic, retain) UIWindow *window;

@end
