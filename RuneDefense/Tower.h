//
//  Tower.h
//  RuneDefense
//
//  Created by Tamas Demeter-Haludka on 7/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CCSprite.h"

@class Creep;

@interface Tower : CCSprite {    
	CCSprite *selSpriteRange;
	
	NSMutableArray *projectiles;
}

@property (nonatomic, assign) int experience;
@property (nonatomic, assign) int lvl;

@property (nonatomic, assign) int lvlup1;
@property (nonatomic, assign) int lvlup2;
@property (nonatomic, assign) int lvlupCost;
@property (nonatomic, assign) bool lvlupReady;

@property (nonatomic, assign) int range;
@property (nonatomic, assign) int damageMin;
@property (nonatomic, assign) int damageRandom;
@property (nonatomic, assign) float fireRate;
@property (nonatomic, assign) float freezeDur;
@property (nonatomic, assign) float splashDist;


@property (nonatomic, retain) CCSprite *nextProjectile;
@property (nonatomic, retain) Creep *target;

- (Creep *)getClosestTarget;

@end

@interface MachineGunTower : Tower {
    
}

+ (id)tower;

- (void)setClosestTarget:(Creep *)closestTarget;
- (void)towerLogic:(ccTime)dt;
- (void)creepMoveFinished:(id)sender;
- (void)finishFiring;

@end

@interface FreezeTower : Tower {
    
}

+ (id)tower;

- (void)setClosestTarget:(Creep *)closestTarget;
- (void)towerLogic:(ccTime)dt;
- (void)creepMoveFinished:(id)sender;
- (void)finishFiring;

@end

@interface CannonTower : Tower {
    
}

+ (id)tower;

- (void)setClosestTarget:(Creep *)closestTarget;
- (void)towerLogic:(ccTime)dt;
- (void)creepMoveFinished:(id)sender;
- (void)finishFiring;

@end
