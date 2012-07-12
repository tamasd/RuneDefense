//
//  Creep.m
//  RuneDefense
//
//  Created by Tamas Demeter-Haludka on 7/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Creep.h"
#import "Waypoint.h"
#import "DataModel.h"
#import "GameHUD.h"
#import "baseAttributes.h"

@implementation Creep

@synthesize hp, moveDuration, currentWaypoint, totalHP, healthBar, lastWaypoint, dataFile;

- (id)copyWithZone:(NSZone *)zone
{
    Creep *copy = [[[self class] allocWithZone:zone] initWithCreep:self];
    return copy;
}

- (Creep *)initWithCreep:(Creep *)copyFrom
{
    if ((self = [[[Creep alloc] initFromDataFile:copyFrom.dataFile] autorelease])) {
        self.currentWaypoint = copyFrom.currentWaypoint;
        self.hp = copyFrom.hp;
    }
    [self retain];
    return self;
}

- (Creep *)initFromDataFile:(NSString *)plistName
{
    Creep *creep = nil;
    
    self.dataFile = plistName;
    
    NSString *errorDesc = nil;
    NSPropertyListFormat format;
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSApplicationDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:plistName];
    NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
    NSDictionary *plist = (NSDictionary *)[NSPropertyListSerialization propertyListFromData:plistXML
                                                                           mutabilityOption:NSPropertyListMutableContainersAndLeaves
                                                                                     format:&format
                                                                           errorDescription:&errorDesc];
    if (!plist) {
        NSLog(@"Error reading plist at %@: %@, format: %d", plistPath, errorDesc, format);
    }
    
    if (plist && (creep = [super initWithFile:[plist objectForKey:@"image"]])) {
        creep.hp = [[plist objectForKey:@"hp"] intValue];
        creep.moveDuration = [[plist objectForKey:@"moveDuration"] intValue];
        creep.currentWaypoint = 0;
    }
    [rootPath release];
    [plistPath release];
    [plistXML release];
    [plist release];
    [errorDesc release];
    return creep;
}

- (Waypoint *)getCurrentWaypoint
{
    DataModel *m = [DataModel getModel];
    Waypoint *waypoint = [m.waypoints objectAtIndex:self.currentWaypoint];
    return waypoint;
}

- (Waypoint *)getNextWaypoint
{
    DataModel *m = [DataModel getModel];
    
    self.currentWaypoint++;
	
	if (self.currentWaypoint >= m.waypoints.count){
        self.currentWaypoint--;
        gameHUD = [GameHUD sharedHUD];
        if (gameHUD.baseHpPercentage > 0) {
            BaseAttributes *baseAttributes = [BaseAttributes sharedAttributes];;
            [gameHUD updateBaseHp:- baseAttributes.baseCreepDamage];
        }
        
        Creep *target = (Creep *) self;
        
        NSMutableArray *endtargetsToDelete = [[NSMutableArray alloc] init];
        [endtargetsToDelete addObject:target];
        for (CCSprite *target in endtargetsToDelete) {
            [m.targets removeObject:target];
            [self.parent removeChild:target cleanup:YES];
        }
        return NULL;
    }
	
	Waypoint *waypoint = (Waypoint *) [m.waypoints objectAtIndex:self.currentWaypoint];
	
	return waypoint;
}

- (Waypoint *)getLastWaypoint
{
	
	DataModel *m = [DataModel getModel];
    
	self.lastWaypoint = self.currentWaypoint -1;
	
	Waypoint *waypoint = (Waypoint *) [m.waypoints objectAtIndex:self.lastWaypoint];
	
	return waypoint;
}

- (float) moveDurScale
{
    
    DataModel *m = [DataModel getModel];
    
    Waypoint *waypoint0 = (Waypoint *) [m.waypoints objectAtIndex:0];
    Waypoint *waypoint1 = (Waypoint *) [m.waypoints objectAtIndex:1];
    firstDistance = ccpDistance(waypoint0.position, waypoint1.position);    
    
    Waypoint *waypoint2 = (Waypoint *) [m.waypoints objectAtIndex:(self.currentWaypoint-1)];
    Waypoint *waypoint3 = (Waypoint *) [m.waypoints objectAtIndex:(self.currentWaypoint)];
    float thisDistance = ccpDistance(waypoint2.position, waypoint3.position);
    
    float moveScale = thisDistance/firstDistance;
    
    return (self.moveDuration * moveScale);
}


-(void)creepLogic:(ccTime)dt {
	
	
	// Rotate creep to face next waypoint
	Waypoint *waypoint = [self getCurrentWaypoint ];
	
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
    healthBar.percentage = ((float)self.hp/(float)self.totalHP) *100;
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
        creep.hp = creep.totalHP = baseAttributes.baseRedCreepHealth;
        creep.moveDuration = baseAttributes.baseRedCreepMoveDur;
		creep.currentWaypoint = 0;
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
        creep.hp = creep.totalHP = baseAttributes.baseGreenCreepHealth;
        creep.moveDuration = baseAttributes.baseGreenCreepMoveDur;
		creep.currentWaypoint = 0;
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
        creep.hp = creep.totalHP = baseAttributes.baseBrownCreepHealth;
        creep.moveDuration = baseAttributes.baseBrownCreepMoveDur;
		creep.currentWaypoint = 0;
        
    }
    [creep schedule:@selector(creepLogic:) interval:0.2];
    [creep schedule:@selector(healthBarLogic:)];      
    
	return creep;
}

@end