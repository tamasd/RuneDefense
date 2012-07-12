//
//  Creep.h
//  Cocos2D Build a Tower Defense Game
//
//  Created by iPhoneGameTutorials on 4/4/11.
//  Copyright 2011 iPhoneGameTutorial.com All rights reserved.
//

#import "cocos2d.h"
#import "SimpleAudioEngine.h"
#import "Projectile.h"
#import "DataModel.h"
#import "Creep.h"


@interface Tower : CCSprite {
    int experience;
    int lvl;
    
    int lvlup1;
    int lvlup2;
    int lvlupCost;
    bool lvlupReady;
    
	int range;
    int damageMin;
    int damageRandom;
    float fireRate;
    float freezeDur;
    float splashDist;
    
    Creep *_target; 
    
	//Creep * _target;
	CCSprite * selSpriteRange;
	
	NSMutableArray *_projectiles;
	CCSprite *_nextProjectile;
    
    BaseAttributes *baseAttributes;
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


@property (nonatomic, retain) CCSprite * nextProjectile;
@property (nonatomic, retain) Creep * target;

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
