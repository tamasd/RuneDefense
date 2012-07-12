//
//  Creep.h
//  RuneDefense
//
//  Created by Tamas Demeter-Haludka on 7/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CCSprite.h"
#import "cocos2d.h"

@class Waypoint;
@class GameHUD;

@interface Creep : CCSprite {
    GameHUD *gameHUD;
    float firstDistance;
}

@property (nonatomic, assign) int hp;
@property (nonatomic, assign) int moveDuration;
@property (nonatomic, assign) int currentWaypoint;
@property (nonatomic, assign) int lastWaypoint;
@property (nonatomic, assign) int totalHP;
@property (nonatomic, copy) NSString *dataFile;

@property (nonatomic, retain) CCProgressTimer *healthBar;

- (Creep *)initWithCreep:(Creep *)copyFrom;
- (Creep *)initFromDataFile:(NSString *)plistName;
- (Waypoint *)getCurrentWaypoint;
- (Waypoint *)getNextWaypoint;
- (Waypoint *)getLastWaypoint;
- (float)moveDurScale;

@end

@interface FastRedCreep : Creep {
}
+(id)creep;
@end

@interface StrongGreenCreep : Creep {
}
+(id)creep;
@end

@interface BossBrownCreep : Creep {
}
+(id)creep;
@end