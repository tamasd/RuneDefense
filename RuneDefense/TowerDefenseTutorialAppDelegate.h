//
//  TowerDefenseTutorialAppDelegate.h
//  Cocos2D Build a Tower Defense Game
//
//  Created by iPhoneGameTutorials on 4/4/11.
//  Copyright 2011 iPhoneGameTutorial.com All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameHUD.h"

@class RootViewController;

@interface TowerDefenseTutorialAppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
    GameHUD *gameHUD;
}

@property (nonatomic, retain) UIWindow *window;

//-(void) runGame;
//-(void) runMenu;
@end
