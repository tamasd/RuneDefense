//
//  MapScreenLayer.h
//  RuneDefense
//
//  Created by Tamas Demeter-Haludka on 7/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>
#import "cocos2d.h"

@class Wave;
@class GameHUD;
@class BaseAttributes;

@interface MapScreenLayer : CCLayer {
    GameHUD *gameHUD;
    BaseAttributes *baseAttributes;
}

@property (nonatomic, retain) CCTMXTiledMap *tileMap;
@property (nonatomic, retain) CCTMXLayer *background;
@property (nonatomic, assign) int currentLevel;

+(CCScene *) scene;

- (void)addWaypoint;
- (void)addTarget;
- (void)addWaves;
- (id)initWithTiledMap:(NSString *)tiledMapPath;
- (void)followPath:(id)sender;
- (Wave *)getCurrentWave;
- (Wave *)getNextWave;
- (void)addTower:(CGPoint)pos:(int)towerTag;
- (BOOL)canBuildOnTilePosition:(CGPoint) pos;
+ (void)resetGame;
- (void)resetLayer;
- (void)loadMenu;

@end
