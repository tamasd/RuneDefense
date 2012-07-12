//
//  Creep.m
//  Cocos2D Build a Tower Defense Game
//
//  Created by iPhoneGameTutorials on 4/4/11.
//  Copyright 2011 iPhoneGameTutorial.com All rights reserved.
//

#import "Tower.h"

@implementation Tower

@synthesize experience = experience;
@synthesize lvl = lvl;

@synthesize lvlup1 = lvlup1;
@synthesize lvlup2 = lvlup2;
@synthesize lvlupCost = lvlupCost;
@synthesize lvlupReady = lvlupReady;

@synthesize range = range;
@synthesize damageMin = damageMin;
@synthesize damageRandom = damageRandom;
@synthesize fireRate = fireRate;
@synthesize freezeDur = freezeDur;
@synthesize splashDist = splashDist;


@synthesize target = _target;
@synthesize nextProjectile = _nextProjectile;


- (Creep *)getClosestTarget {
	Creep *closestCreep = nil;
	double maxDistant = 99999;
	
	DataModel *m = [DataModel getModel];
	
	for (CCSprite *target in m._targets) {	
		Creep *creep = (Creep *)target;
		double curDistance = ccpDistance(self.position, creep.position);
		
		if (curDistance < maxDistant) {
			closestCreep = creep;
			maxDistant = curDistance;
		}
		
	}
	
	if (maxDistant < self.range)
		return closestCreep;
	
	return nil;
}


@end

@implementation MachineGunTower

+ (id)tower {
	
    MachineGunTower *tower = nil;
    if ((tower = [[[super alloc] initWithFile:@"MachineGunTurret.png"] autorelease])) {        
        BaseAttributes *baseAttributes = [BaseAttributes sharedAttributes];
        
        tower.damageMin = baseAttributes.baseMGDamage;
        tower.damageRandom = baseAttributes.baseMGDamageRandom;
        tower.range = baseAttributes.baseMGRange;
        [tower schedule:@selector(towerLogic:) interval:baseAttributes.baseMGFireRate];
        
		tower.experience = 0;
        tower.lvl = 1;
        tower.lvlup1 = baseAttributes.baseMGlvlup1;
        tower.lvlup2 = baseAttributes.baseMGlvlup2;
        tower.lvlupCost = baseAttributes.baseMGCost /2;
        tower.lvlupReady = NO;
        tower.freezeDur = 0;
        tower.splashDist = 0;
        
		tower.target = nil;
        
		
        [tower schedule:@selector(checkTarget) interval:0.5];
        [tower schedule:@selector(checkExperience) interval:0.5];
        
        
        
    }
	
    return tower;
    
}

-(id) init
{
	if ((self=[super init]) ) {
		//[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
	}
	return self;
}


-(void)setClosestTarget:(Creep *)closestTarget {
	self.target = closestTarget;
}

-(void)checkTarget {
    double curDistance = ccpDistance(self.position, self.target.position);
    if (self.target.hp <= 0 || curDistance > self.range){
        self.target = [self getClosestTarget];
    }
}

-(void)checkExperience {
    switch (self.lvl) {
        case 1:
            if (self.experience >= self.lvlup1 && self.lvlupReady == NO) {
                //Ready lvl up
                printf("Ready upgrade");
                
                [self setTexture:[[CCTextureCache sharedTextureCache] addImage:@"MGTowerUpgrade.png"]];
                
                self.lvlupReady = TRUE;
            }
            break;
        case 2:
            if (self.experience >= self.lvlup2) {
                //Ready lvl up 2
                self.lvlupReady = TRUE;
            }
        default:
            break;
    }
}
-(void)towerLogic:(ccTime)dt {
	
    if (self.target == nil) {
        self.target = [self getClosestTarget];
    }
	
	if (self.target != nil) {
		
		//rotate the tower to face the nearest creep
		CGPoint shootVector = ccpSub(self.target.position, self.position);
		CGFloat shootAngle = ccpToAngle(shootVector);
		CGFloat cocosAngle = CC_RADIANS_TO_DEGREES(-1 * shootAngle);
		
		float rotateSpeed = 0.25 / M_PI; // 1/4 second to roate 180 degrees
		float rotateDuration = fabs(shootAngle * rotateSpeed);    
		
		[self runAction:[CCSequence actions:
						 [CCRotateTo actionWithDuration:rotateDuration angle:cocosAngle],
						 [CCCallFunc actionWithTarget:self selector:@selector(finishFiring)],
						 nil]];		
        
        
        //printf("experience %i", self.experience);
	}
}

-(void)creepMoveFinished:(id)sender {
    
	DataModel * m = [DataModel getModel];
	
	CCSprite *sprite = (CCSprite *)sender;
	[self.parent removeChild:sprite cleanup:YES];
	
	[m._projectiles removeObject:sprite];
	
}

- (void)finishFiring {
	
    if (self.target != NULL) {
        
        DataModel *m = [DataModel getModel];
        self.nextProjectile = [Projectile projectile: self];
        self.nextProjectile.position = self.position;
        
        [self.parent addChild:self.nextProjectile z:1];
        [m._projectiles addObject:self.nextProjectile];
        
        ccTime delta = 0.5;
        CGPoint shootVector = ccpSub(self.target.position, self.position);
        CGPoint normalizedShootVector = ccpNormalize(shootVector);
        CGPoint overshotVector = ccpMult(normalizedShootVector, 320);
        CGPoint offscreenPoint = ccpAdd(self.position, overshotVector);
        
        [self.nextProjectile runAction:[CCSequence actions:
                                        [CCMoveTo actionWithDuration:delta position:offscreenPoint],
                                        [CCCallFuncN actionWithTarget:self selector:@selector(creepMoveFinished:)],
                                        nil]];
        
        self.nextProjectile.tag = 1;		
        
        self.nextProjectile = nil;
    }
}

@end


@implementation FreezeTower

+ (id)tower {
	
    FreezeTower *tower = nil;
    if ((tower = [[[super alloc] initWithFile:@"FreezeTurret.png"] autorelease])) {
        BaseAttributes *baseAttributes = [BaseAttributes sharedAttributes];
        
        tower.damageMin = baseAttributes.baseFDamage;
        tower.damageRandom = baseAttributes.baseFDamageRandom;
        tower.range = baseAttributes.baseFRange;
        [tower schedule:@selector(towerLogic:) interval:baseAttributes.baseFFireRate];
        tower.freezeDur = baseAttributes.baseFFreezeDur;
        tower.splashDist = 0;
        
		tower.experience = 0;
        tower.lvl = 1;
        tower.lvlup1 = baseAttributes.baseFlvlup1;
        tower.lvlup2 = baseAttributes.baseFlvlup2;
        tower.lvlupCost = baseAttributes.baseFCost /2;
        tower.lvlupReady = NO;
        
        
		tower.target = nil;
        
		
        [tower schedule:@selector(checkTarget) interval:0.5];
        [tower schedule:@selector(checkExperience) interval:0.5];
		
		tower.target = nil;
		[tower schedule:@selector(towerLogic:) interval:2];
		
    }
	
    return tower;
    
}

-(id) init
{
	if ((self=[super init]) ) {
		//[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
	}
	return self;
}


-(void)setClosestTarget:(Creep *)closestTarget {
	self.target = closestTarget;
}

-(void)checkTarget {
    double curDistance = ccpDistance(self.position, self.target.position);
    if (self.target.hp <= 0 || curDistance > self.range){
        self.target = [self getClosestTarget];
    }
}

-(void)checkExperience {
    switch (self.lvl) {
        case 1:
            if (self.experience >= self.lvlup1 && self.lvlupReady == NO) {
                //Ready lvl up
                printf("Ready upgrade");
                
                [self setTexture:[[CCTextureCache sharedTextureCache] addImage:@"FreezeTurretUpgrade.png"]];
                
                self.lvlupReady = TRUE;
            }
            break;
        case 2:
            if (self.experience >= self.lvlup2) {
                //Ready lvl up 2
                self.lvlupReady = TRUE;
            }
        default:
            break;
    }
}

-(void)towerLogic:(ccTime)dt {
	
	self.target = [self getClosestTarget];
	
	if (self.target != nil) {
		
		//rotate the tower to face the nearest creep
		CGPoint shootVector = ccpSub(self.target.position, self.position);
		CGFloat shootAngle = ccpToAngle(shootVector);
		CGFloat cocosAngle = CC_RADIANS_TO_DEGREES(-1 * shootAngle);
		
		float rotateSpeed = 0.5 / M_PI; // 1/2 second to roate 180 degrees
		float rotateDuration = fabs(shootAngle * rotateSpeed);    
		
		[self runAction:[CCSequence actions:
						 [CCRotateTo actionWithDuration:rotateDuration angle:cocosAngle],
						 [CCCallFunc actionWithTarget:self selector:@selector(finishFiring)],
						 nil]];		
	}
}

-(void)creepMoveFinished:(id)sender {
    
	DataModel * m = [DataModel getModel];
	
	CCSprite *sprite = (CCSprite *)sender;
	[self.parent removeChild:sprite cleanup:YES];
	
	[m._projectiles removeObject:sprite];
	
}

- (void)finishFiring {
	
    if (self.target != NULL) {
        
        DataModel *m = [DataModel getModel];
        self.nextProjectile = [IceProjectile projectile: self];
        self.nextProjectile.position = self.position;
        
        [self.parent addChild:self.nextProjectile z:1];
        [m._projectiles addObject:self.nextProjectile];
        
        ccTime delta = 0.5;
        CGPoint shootVector = ccpSub(self.target.position, self.position);
        CGPoint normalizedShootVector = ccpNormalize(shootVector);
        CGPoint overshotVector = ccpMult(normalizedShootVector, 320);
        CGPoint offscreenPoint = ccpAdd(self.position, overshotVector);
        
        [self.nextProjectile runAction:[CCSequence actions:
                                        [CCMoveTo actionWithDuration:delta position:offscreenPoint],
                                        [CCCallFuncN actionWithTarget:self selector:@selector(creepMoveFinished:)],
                                        nil]];
        
        self.nextProjectile.tag = 2;		
        
        self.nextProjectile = nil;
    }
    
}

@end

@implementation CannonTower

+ (id)tower {
	
    CannonTower *tower = nil;
    if ((tower = [[[super alloc] initWithFile:@"CannonTurret.png"] autorelease])) {
        BaseAttributes *baseAttributes = [BaseAttributes sharedAttributes];
        
        tower.damageMin = baseAttributes.baseCDamage;
        tower.damageRandom = baseAttributes.baseCDamageRandom;
        tower.range = baseAttributes.baseMGRange;
        [tower schedule:@selector(towerLogic:) interval:baseAttributes.baseCFireRate];
        tower.freezeDur = 0;
        tower.splashDist = baseAttributes.baseCSplashDist;
        
		tower.experience = 0;
        tower.lvl = 1;
        tower.lvlup1 = baseAttributes.baseClvlup1;
        tower.lvlup2 = baseAttributes.baseClvlup2;
        tower.lvlupCost = baseAttributes.baseCCost /2;
        tower.lvlupReady = NO;
        
        
		tower.target = nil;
        
		
        [tower schedule:@selector(checkTarget) interval:0.5];
        [tower schedule:@selector(checkExperience) interval:0.5];
		
		tower.target = nil;
		[tower schedule:@selector(towerLogic:) interval:2];
		
    }
	
    return tower;
    
}

-(id) init
{
	if ((self=[super init]) ) {
		//[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
	}
	return self;
}


-(void)setClosestTarget:(Creep *)closestTarget {
	self.target = closestTarget;
}

-(void)checkTarget {
    double curDistance = ccpDistance(self.position, self.target.position);
    if (self.target.hp <= 0 || curDistance > self.range){
        self.target = [self getClosestTarget];
    }
}

-(void)checkExperience {
    switch (self.lvl) {
        case 1:
            if (self.experience >= self.lvlup1 && self.lvlupReady == NO) {
                //Ready lvl up
                printf("Ready upgrade");
                
                [self setTexture:[[CCTextureCache sharedTextureCache] addImage:@"CannonTurretUpgrade.png"]];
                
                self.lvlupReady = TRUE;
            }
            break;
        case 2:
            if (self.experience >= self.lvlup2) {
                //Ready lvl up 2
                self.lvlupReady = TRUE;
            }
        default:
            break;
    }
}

-(void)towerLogic:(ccTime)dt {
	
	self.target = [self getClosestTarget];
	
	if (self.target != nil) {
		
		//rotate the tower to face the nearest creep
		CGPoint shootVector = ccpSub(self.target.position, self.position);
		CGFloat shootAngle = ccpToAngle(shootVector);
		CGFloat cocosAngle = CC_RADIANS_TO_DEGREES(-1 * shootAngle);
		
		float rotateSpeed = 0.5 / M_PI; // 1/2 second to roate 180 degrees
		float rotateDuration = fabs(shootAngle * rotateSpeed);    
		
		[self runAction:[CCSequence actions:
						 [CCRotateTo actionWithDuration:rotateDuration angle:cocosAngle],
						 [CCCallFunc actionWithTarget:self selector:@selector(finishFiring)],
						 nil]];		
	}
}

-(void)creepMoveFinished:(id)sender {
    
	DataModel * m = [DataModel getModel];
	
	CCSprite *sprite = (CCSprite *)sender;
	[self.parent removeChild:sprite cleanup:YES];
	
	[m._projectiles removeObject:sprite];
	
}

- (void)finishFiring {
	
    if (self.target != NULL) {
        
        DataModel *m = [DataModel getModel];
        self.nextProjectile = [CannonProjectile projectile: self];
        self.nextProjectile.position = self.position;
        
        [self.parent addChild:self.nextProjectile z:1];
        [m._projectiles addObject:self.nextProjectile];
        
        ccTime delta = 0.5;
        CGPoint shootVector = ccpSub(self.target.position, self.position);
        CGPoint normalizedShootVector = ccpNormalize(shootVector);
        CGPoint overshotVector = ccpMult(normalizedShootVector, 320);
        CGPoint offscreenPoint = ccpAdd(self.position, overshotVector);
        
        [self.nextProjectile runAction:[CCSequence actions:
                                        [CCMoveTo actionWithDuration:delta position:offscreenPoint],
                                        [CCCallFuncN actionWithTarget:self selector:@selector(creepMoveFinished:)],
                                        nil]];
        
        self.nextProjectile.tag = 3;		
        
        self.nextProjectile = nil;
    }
    
}

@end
