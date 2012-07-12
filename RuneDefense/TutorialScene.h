//
//  TutorialLayer.h
//  Cocos2D Build a Tower Defense Game
//
//  Created by iPhoneGameTutorials on 4/4/11.
//  Copyright 2011 iPhoneGameTutorial.com All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

#import "Creep.h"
#import "Projectile.h"
#import "Tower.h"
#import "WayPoint.h"
#import "Wave.h"
#import "baseAttributes.h"
#import "GameHUD.h"
#import "EndGame.h"
#import "MenuLayer.h"

// Tutorial Layer
@interface Tutorial : CCLayer
{
    CCTMXTiledMap *_tileMap;
    CCTMXLayer *_background;	
	
	int _currentLevel;
	
	GameHUD * gameHUD;
    BaseAttributes * baseAttributes;

}

@property (nonatomic, retain) CCTMXTiledMap *tileMap;
@property (nonatomic, retain) CCTMXLayer *background;

@property (nonatomic, assign) int currentLevel;

+ (id) scene;
- (void)addWaypoint;
- (void)addTower: (CGPoint)pos: (int)towerTag;
- (BOOL) canBuildOnTilePosition:(CGPoint) pos;
+(void) resetGame;
-(void) resetLayer;
-(void) loadMenu;
@end
