//
//  Creep.m
//  Cocos2D Build a Tower Defense Game
//
//  Created by iPhoneGameTutorials on 4/4/11.
//  Copyright 2011 iPhoneGameTutorial.com All rights reserved.
//

#import "Creep.h"

@implementation Creep

@synthesize hp = _curHp;
@synthesize moveDuration = _moveDuration;
@synthesize totalHp = _totalHp;

@synthesize curWaypoint = _curWaypoint;
@synthesize lastWaypoint = _lastWaypoint;
@synthesize healthBar = healthBar;



- (id) copyWithZone:(NSZone *)zone {
	Creep *copy = [[[self class] allocWithZone:zone] initWithCreep:self];
	return copy;
}

- (Creep *) initWithCreep:(Creep *) copyFrom {
    if ((self = [[[super alloc] initWithFile:@"Enemy1.png"] autorelease])) {
        self.hp = copyFrom.hp;
        self.moveDuration = copyFrom.moveDuration;
        self.curWaypoint = copyFrom.curWaypoint;
        
        
	}
	[self retain];
	return self;
}

- (WayPoint *)getCurrentWaypoint{
	
	DataModel *m = [DataModel getModel];
	
	WayPoint *waypoint = (WayPoint *) [m._waypoints objectAtIndex:self.curWaypoint];
	
	return waypoint;
}

- (WayPoint *)getNextWaypoint{
	
	DataModel *m = [DataModel getModel];
    
	self.curWaypoint++;
	
	if (self.curWaypoint >= m._waypoints.count){
        self.curWaypoint--;
        gameHUD = [GameHUD sharedHUD];
        if (gameHUD.baseHpPercentage > 0) {
            BaseAttributes *baseAttributes = [BaseAttributes sharedAttributes];;
            [gameHUD updateBaseHp:- baseAttributes.baseCreepDamage];
        }
        
        Creep *target = (Creep *) self;
        
        NSMutableArray *endtargetsToDelete = [[NSMutableArray alloc] init];
        [endtargetsToDelete addObject:target];
        for (CCSprite *target in endtargetsToDelete) {
            [m._targets removeObject:target];
            [self.parent removeChild:target cleanup:YES];
        }
        return NULL;
    }
	
	WayPoint *waypoint = (WayPoint *) [m._waypoints objectAtIndex:self.curWaypoint];
	
	return waypoint;
}

- (WayPoint *)getLastWaypoint{
	
	DataModel *m = [DataModel getModel];
    
	self.lastWaypoint = self.curWaypoint -1;
	
	WayPoint *waypoint = (WayPoint *) [m._waypoints objectAtIndex:self.lastWaypoint];
	
	return waypoint;
}

- (float) moveDurScale
{
    
    DataModel *m = [DataModel getModel];
    
    WayPoint *waypoint0 = (WayPoint *) [m._waypoints objectAtIndex:0];
    WayPoint *waypoint1 = (WayPoint *) [m._waypoints objectAtIndex:1];
    firstDistance = ccpDistance(waypoint0.position, waypoint1.position);    
    
    WayPoint *waypoint2 = (WayPoint *) [m._waypoints objectAtIndex:(self.curWaypoint-1)];
    WayPoint *waypoint3 = (WayPoint *) [m._waypoints objectAtIndex:(self.curWaypoint)];
    float thisDistance = ccpDistance(waypoint2.position, waypoint3.position);
    
    float moveScale = thisDistance/firstDistance;
    
    return (self.moveDuration * moveScale);
}


-(void)creepLogic:(ccTime)dt {
	
	
	// Rotate creep to face next waypoint
	WayPoint *waypoint = [self getCurrentWaypoint ];
	
	CGPoint waypointVector = ccpSub(waypoint.position, self.position);
	CGFloat waypointAngle = ccpToAngle(waypointVector);
	CGFloat cocosAngle = CC_RADIANS_TO_DEGREES(-1 * waypointAngle);
	
	float rotateSpeed = 0.5 / M_PI; // 1/2 second to roate 180 degrees
	float rotateDuration = fabs(waypointAngle * rotateSpeed);    
	
	[self runAction:[CCSequence actions:
					 [CCRotateTo actionWithDuration:rotateDuration angle:cocosAngle],
					 nil]];		
}

-(void)healthBarLogic:(ccTime)dt {
    
    //Update health bar pos and percentage.
    healthBar.position = ccp(self.position.x, (self.position.y+20));
    healthBar.percentage = ((float)self.hp/(float)self.totalHp) *100;
    if (healthBar.percentage <= 0) {
        [self removeChild:healthBar cleanup:YES];
    }
}

@end

@implementation FastRedCreep

+ (id)creep {
    
    FastRedCreep *creep = nil;
    if ((creep = [[[super alloc] initWithFile:@"Enemy1.png"] autorelease])) {
        BaseAttributes* baseAttributes = [BaseAttributes sharedAttributes];
        creep.hp = creep.totalHp = baseAttributes.baseRedCreepHealth;
        creep.moveDuration = baseAttributes.baseRedCreepMoveDur;
		creep.curWaypoint = 0;
    }
	
	[creep schedule:@selector(creepLogic:) interval:0.2];
    [creep schedule:@selector(healthBarLogic:)];

	
    return creep;
}

@end

@implementation StrongGreenCreep

+ (id)creep {
    
    StrongGreenCreep *creep = nil;
    if ((creep = [[[super alloc] initWithFile:@"Enemy2.png"] autorelease])) {
        BaseAttributes* baseAttributes = [BaseAttributes sharedAttributes];
        creep.hp = creep.totalHp = baseAttributes.baseGreenCreepHealth;
        creep.moveDuration = baseAttributes.baseGreenCreepMoveDur;
		creep.curWaypoint = 0;
    }
	
	[creep schedule:@selector(creepLogic:) interval:0.2];
    [creep schedule:@selector(healthBarLogic:)];

	return creep;
}

@end

@implementation BossBrownCreep

+ (id)creep {
    
    BossBrownCreep *creep = nil;
    if ((creep = [[[super alloc] initWithFile:@"Enemy3.png"] autorelease])) {
        BaseAttributes* baseAttributes = [BaseAttributes sharedAttributes];
        creep.hp = creep.totalHp = baseAttributes.baseBrownCreepHealth;
        creep.moveDuration = baseAttributes.baseBrownCreepMoveDur;
		creep.curWaypoint = 0;
        
    }
    [creep schedule:@selector(creepLogic:) interval:0.2];
    [creep schedule:@selector(healthBarLogic:)];      
    
	return creep;
}

@end