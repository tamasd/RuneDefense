//
//  TutorialLayer.m
//  Cocos2D Build a Tower Defense Game
//
//  Created by iPhoneGameTutorials on 4/4/11.
//  Copyright 2011 iPhoneGameTutorial.com All rights reserved.
//

// Import the interfaces
#import "TutorialScene.h"
#import "GameHUD.h"

#import "DataModel.h"

// Tutorial implementation
@implementation Tutorial

@synthesize tileMap = _tileMap;
@synthesize background = _background;

bool reset;

@synthesize currentLevel = _currentLevel;
+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	Tutorial *layer = [Tutorial node];
	
	// add layer as a child to scene
	[scene addChild: layer z:1];
	
	GameHUD * myGameHUD = [GameHUD sharedHUD];
	[scene addChild:myGameHUD z:2];
    
    CCLayer *menuLayer =[[[MenuLayer alloc]init ]autorelease];
    [scene addChild:menuLayer z:10];
    [[CCDirector sharedDirector] pause];
	
	DataModel *m = [DataModel getModel];
	m._gameLayer = layer;
	m._gameHUDLayer = myGameHUD;
	
	// return the scene
	return scene;
}

-(void)addWaves {
	DataModel *m = [DataModel getModel];
	
	Wave *wave = nil;
    wave = [[Wave alloc] initWithCreep:[FastRedCreep creep] SpawnRate:1.0 RedCreeps:0 GreenCreeps:0 BrownCreeps:0];
    [m._waves addObject:wave];
	wave = nil;
	wave = [[Wave alloc] initWithCreep:[FastRedCreep creep] SpawnRate:1.0 RedCreeps:5 GreenCreeps:0 BrownCreeps:0];
	[m._waves addObject:wave];
	wave = nil;
	wave = [[Wave alloc] initWithCreep:[FastRedCreep creep] SpawnRate:1.0 RedCreeps:5 GreenCreeps:3 BrownCreeps:0];
	[m._waves addObject:wave];
	wave = nil;	
    wave = [[Wave alloc] initWithCreep:[FastRedCreep creep] SpawnRate:0.8 RedCreeps:3 GreenCreeps:7 BrownCreeps:0];
	[m._waves addObject:wave];
	wave = nil;
	wave = [[Wave alloc] initWithCreep:[FastRedCreep creep] SpawnRate:1.2 RedCreeps:10 GreenCreeps:10 BrownCreeps:0];
	[m._waves addObject:wave];
    wave = nil;
    wave = [[Wave alloc] initWithCreep:[FastRedCreep creep] SpawnRate:1.5 RedCreeps:5 GreenCreeps:5 BrownCreeps:2];
	[m._waves addObject:wave];
	wave = nil;
}


// on "init" you need to initialize your instance
-(id) init {
    if((self = [super init])) {				
		self.tileMap = [CCTMXTiledMap tiledMapWithTMXFile:@"TileMap.tmx"];
        self.background = [_tileMap layerNamed:@"Background"];
		self.background.anchorPoint = ccp(0, 0);
		[self addChild:_tileMap z:0];
		
		[self addWaypoint];
		[self addWaves];
		
		// Call game logic about every second
        [self schedule:@selector(update:)];
		[self schedule:@selector(gameLogic:) interval:0.2];		
        
		reset = NO;
        
		self.currentLevel = 0;
		
		self.position = ccp(-258, -122);
		
		gameHUD = [GameHUD sharedHUD];
        baseAttributes = [BaseAttributes sharedAttributes];
        
    
        //[self loadMenu];
    }
    return self;
}

-(void) loadMenu{
    CCLayer *menuLayer =[[[MenuLayer alloc]init ]autorelease];
    [self.parent addChild:menuLayer z:10];
    [[CCDirector sharedDirector] pause];
}

+(void) resetGame{
    reset = YES;
}

-(void) resetLayer{
    reset = NO;
    
    DataModel *m = [DataModel getModel];
    
    NSMutableArray *towersToDelete = [[NSMutableArray alloc] init];
	for (Tower *tower in m._towers) {
        [towersToDelete addObject:tower];
        [self removeChild:tower cleanup:YES];
    }
    for (Tower *tower in towersToDelete) {
        [self removeChild:tower cleanup:YES];
    }
    [towersToDelete release];

    for (Creep *target in m._targets) {
        [m._targets removeObject:target];
        [self removeChild:target.healthBar cleanup:YES];
        [self removeChild:target cleanup:YES];
    }
    NSMutableArray *projectilesToDelete = [[NSMutableArray alloc] init];
	for (Projectile *projectile in m._projectiles) {
        [projectilesToDelete addObject:projectile];
    }
    for (Projectile *projectile in projectilesToDelete) {
        [self removeChild:projectile cleanup:YES];
    }
    [projectilesToDelete release];

    [m._towers removeAllObjects];
    [m._targets removeAllObjects];
    [m._projectiles removeAllObjects];
    [m._waves removeAllObjects];
    [self addWaves];

    // Call game logic about every second
    [self schedule:@selector(update:)];
    [self schedule:@selector(gameLogic:) interval:0.2];		
    
    self.currentLevel = 0;
    
    self.position = ccp(-258, -122);
    self.isTouchEnabled = YES;
    
}

- (Wave *)getCurrentWave{
	
	DataModel *m = [DataModel getModel];	
	Wave * wave = (Wave *) [m._waves objectAtIndex:self.currentLevel];
	
	return wave;
}

- (Wave *)getNextWave{
	
	DataModel *m = [DataModel getModel];
    
//    printf("this level %i", self.currentLevel);
	if (self.currentLevel >= 5){
       
        //NSLog(@"you have reached the end of the game!");
        return NULL;
    }
    
	self.currentLevel++;
	
	
	 Wave * wave = (Wave *) [m._waves objectAtIndex:self.currentLevel];
	 
	 return wave;
}


-(void)waveWait
{
    [self unschedule:@selector(waveWait)];
    [self getNextWave];
    [gameHUD updateWaveCount];
    [gameHUD newWaveApproachingEnd];
}

-(void)addWaypoint {
	DataModel *m = [DataModel getModel];
	
	CCTMXObjectGroup *objects = [self.tileMap objectGroupNamed:@"Objects"];
	WayPoint *wp = nil;
	
	int wayPointCounter = 0;
	NSMutableDictionary *wayPoint;
	while ((wayPoint = [objects objectNamed:[NSString stringWithFormat:@"Waypoint%d", wayPointCounter]])) {
		int x = [[wayPoint valueForKey:@"x"] intValue];
		int y = [[wayPoint valueForKey:@"y"] intValue];
		
		wp = [WayPoint node];
		wp.position = ccp(x, y);
		[m._waypoints addObject:wp];
		wayPointCounter++;
	}
	
	NSAssert([m._waypoints count] > 0, @"Waypoint objects missing");
	wp = nil;
}

- (CGPoint) tileCoordForPosition:(CGPoint) position 
{
    //position = ccpAdd(position, ccp(0, 20));
	int x = position.x / self.tileMap.tileSize.width;
	int y = ((self.tileMap.mapSize.height * self.tileMap.tileSize.height) - position.y) / self.tileMap.tileSize.height;
	
	return ccp(x,y);
}

- (BOOL) canBuildOnTilePosition:(CGPoint) pos 
{
    pos = ccpAdd(pos, ccp(0, 20));
	CGPoint towerLoc = [self tileCoordForPosition: pos];
	int tileGid = [self.background tileGIDAt:towerLoc];
	NSDictionary *props = [self.tileMap propertiesForGID:tileGid];
	NSString *type = [props valueForKey:@"buildable"];
	
    
    bool occupied = NO;
    DataModel *m = [DataModel getModel];
    for (Tower *tower in m._towers) {
        CGRect towerRect = CGRectMake(tower.position.x - (tower.contentSize.width/2), 
                                      tower.position.y - (tower.contentSize.height/2), 
                                      tower.contentSize.width, 
                                      tower.contentSize.height);
        if (CGRectContainsPoint(towerRect, pos)) {
            occupied = YES;
        }
 
    }
    
	if([type isEqualToString: @"1"] && occupied == NO) {
		return YES;
	}
	
	return NO;
}

-(void)addTower: (CGPoint)pos: (int)towerTag{
	DataModel *m = [DataModel getModel];
	
	Tower *target = nil;
    pos = ccpAdd(pos, ccp(0, 20));

	CGPoint towerLoc = [self tileCoordForPosition: pos];
    
	
	int tileGid = [self.background tileGIDAt:towerLoc];
	NSDictionary *props = [self.tileMap propertiesForGID:tileGid];
	NSString *type = [props valueForKey:@"buildable"];
	
	
	bool occupied = NO;
    for (Tower *tower in m._towers) {
        CGRect towerRect = CGRectMake(tower.position.x - (tower.contentSize.width/2), 
                                      tower.position.y - (tower.contentSize.height/2), 
                                      tower.contentSize.width, 
                                      tower.contentSize.height);
        if (CGRectContainsPoint(towerRect, pos)) {
            occupied = YES;
            return;
        }
    }
    
	if([type isEqualToString: @"1"] && occupied == NO) {

        printf("money %i", gameHUD.resources);
        
        switch (towerTag) {
            case 1:
                if (gameHUD.resources >= (int)(baseAttributes.baseMGCost*baseAttributes.baseTowerCostPercentage)) {
                    target = [MachineGunTower tower];
                    [gameHUD updateResources:-(int)(baseAttributes.baseMGCost*baseAttributes.baseTowerCostPercentage)];
                }
                else
                    return;
                break;
            case 2:
                if (gameHUD.resources >= (int)(baseAttributes.baseFCost*baseAttributes.baseTowerCostPercentage)) {
                    target = [FreezeTower tower];
                    [gameHUD updateResources:-(int)(baseAttributes.baseFCost*baseAttributes.baseTowerCostPercentage)];
                }
                else
                    return;
                break;
            case 3:
                if (gameHUD.resources >= (int)(baseAttributes.baseCCost*baseAttributes.baseTowerCostPercentage)) {
                    target = [CannonTower tower]; //To change later
                    [gameHUD updateResources:-(int)(baseAttributes.baseCCost*baseAttributes.baseTowerCostPercentage)];
                }
                else
                    return;
                break;
            default:
                break;
        
        }
        
		target.position = ccp((towerLoc.x * 32) + 16, self.tileMap.contentSize.height - (towerLoc.y * 32) - 16);
		[self addChild:target z:1];
		
		target.tag = 1;
		[m._towers addObject:target];
		
	} else {
		NSLog(@"Tile Not Buildable");
	}
	
}

-(void)addTarget {
    
	DataModel *m = [DataModel getModel];
	Wave * wave = [self getCurrentWave];
	if (wave.redCreeps <= 0 && wave.greenCreeps <= 0 && wave.brownCreeps <= 0) {
        return; //
	}
	
	//wave.totalCreeps--;
	
    Creep *target = nil;
    int creepChoice = (arc4random() % 3);
    int layer;
    switch (creepChoice) {
        case 0:
            if (wave.redCreeps > 0) {
                target = [FastRedCreep creep];
                target.tag = 1;
                wave.redCreeps--;
                layer = 1;
            }
            else {
                [self addTarget];
                return;
            }
            break;
        case 1:
            if (wave.greenCreeps >0) {
                target = [StrongGreenCreep creep];
                target.tag = 2;
                wave.greenCreeps--;
                layer = 1;
            }
            else {
                [self addTarget];
                return;
            }
            break;
        case 2:
            if (wave.brownCreeps >0) {
                target = [BossBrownCreep creep];
                target.tag = 3;
                wave.brownCreeps--;
                layer = 2;
            }
            else{
                [self addTarget];
                return;
            }
            break;
        default:
            break;
    }
	
	WayPoint *waypoint = [target getCurrentWaypoint];
	target.position = waypoint.position;	
	waypoint = [target getNextWaypoint ];
	[self addChild:target z:layer];
	
    target.healthBar = [CCProgressTimer progressWithSprite:[CCSprite spriteWithFile:@"health_bar_red.png"]];
    target.healthBar.type = kCCProgressTimerTypeBar;
    target.healthBar.percentage = 100;
    [target.healthBar setScale:0.1]; 
    target.healthBar.position = ccp(target.position.x,(target.position.y+20));
    [self addChild:target.healthBar z:3];
    
    float moveDuration = target.moveDuration;
    
	id actionMove = [CCMoveTo actionWithDuration:moveDuration position:waypoint.position];
	id actionMoveDone = [CCCallFuncN actionWithTarget:self selector:@selector(FollowPath:)];
	[target runAction:[CCSequence actions:actionMove, actionMoveDone, nil]];
	
	// Add to targets array
	[m._targets addObject:target];
    return;
}

-(void)FollowPath:(id)sender {
    
	Creep *creep = (Creep *)sender;
	
	WayPoint * waypoint = [creep getNextWaypoint];

	int moveDuration = [creep moveDurScale];
    
	id actionMove = [CCMoveTo actionWithDuration:moveDuration position:waypoint.position];
    
	id actionMoveDone = [CCCallFuncN actionWithTarget:self selector:@selector(FollowPath:)];
	[creep stopAllActions];
	[creep runAction:[CCSequence actions:actionMove, actionMoveDone, nil]];
}

-(void)ResumePath:(id)sender {
    Creep *creep = (Creep *)sender;
    
    WayPoint * cWaypoint = [creep getCurrentWaypoint];//destination
    WayPoint * lWaypoint = [creep getLastWaypoint];//startpoint
    
    float waypointDist = fabsf(cWaypoint.position.x - lWaypoint.position.x);
    float creepDist = fabsf(cWaypoint.position.x - creep.position.x);
    float distFraction = creepDist / waypointDist;
    float durScale = [creep moveDurScale];
    float moveDuration = durScale * distFraction; //Time it takes to go from one way point to another * the fraction of how far is left to go (meaning it will move at the correct speed)
    id actionMove = [CCMoveTo actionWithDuration:moveDuration position:cWaypoint.position];   
    id actionMoveDone = [CCCallFuncN actionWithTarget:self selector:@selector(FollowPath:)];
	[creep stopAllActions];
	[creep runAction:[CCSequence actions:actionMove, actionMoveDone, nil]];
}

-(void)gameLogic:(ccTime)dt {
    
    
	
//	DataModel *m = [DataModel getModel];
	Wave * wave = [self getCurrentWave];
	static double lastTimeTargetAdded = 0;
    double now = [[NSDate date] timeIntervalSince1970];
   if(lastTimeTargetAdded == 0 || now - lastTimeTargetAdded >= wave.spawnRate) {
        [self addTarget];
        lastTimeTargetAdded = now;
    }
	
}

- (void)update:(ccTime)dt {
    
    if (reset == YES) {
        [self resetLayer];
    }

	DataModel *m = [DataModel getModel];
	NSMutableArray *projectilesToDelete = [[NSMutableArray alloc] init];

	for (Projectile *projectile in m._projectiles) {
		
		CGRect projectileRect = CGRectMake(projectile.position.x - (projectile.contentSize.width/2), 
										   projectile.position.y - (projectile.contentSize.height/2), 
										   projectile.contentSize.width, 
										   projectile.contentSize.height);
        
		NSMutableArray *targetsToDelete = [[NSMutableArray alloc] init];
        
		for (CCSprite *target in m._targets) {
            
			CGRect targetRect = CGRectMake(target.position.x - (target.contentSize.width/2), 
										   target.position.y - (target.contentSize.height/2), 
										   target.contentSize.width, 
										   target.contentSize.height);
            
			if (CGRectIntersectsRect(projectileRect, targetRect)) {
                
				[projectilesToDelete addObject:projectile];
                Creep *creep = (Creep *)target;
                Creep *thisCreep;
                Tower *parentTower = (Tower *) projectile.parentTower;
                int thisHitDamage;
                CGRect splashRect;
                switch (projectile.tag) {
                    case 1:
                        thisHitDamage = (rand()%baseAttributes.baseMGDamageRandom)+parentTower.damageMin;
                        creep.hp -= thisHitDamage;
                        
                        parentTower.experience += thisHitDamage;
                        break;
                        
                    case 2:
                        thisHitDamage = (rand()%baseAttributes.baseFDamageRandom)+parentTower.damageMin;
                        creep.hp -= thisHitDamage;
                        parentTower.experience += thisHitDamage;
                        
                        id actionFreeze = [CCMoveTo actionWithDuration:parentTower.freezeDur position:creep.position];    
                        id actionMoveResume = [CCCallFuncN actionWithTarget:self selector:@selector(ResumePath:)];  
                        [creep stopAllActions];
                        [creep runAction:[CCSequence actions:actionFreeze, actionMoveResume, nil]];
                        break;
                        
                    case 3:
                        thisHitDamage = (rand()%baseAttributes.baseFDamageRandom)+parentTower.damageMin;
                        parentTower.experience += thisHitDamage;
                        splashRect = CGRectMake(projectile.position.x - (parentTower.splashDist), 
                                                projectile.position.y - (parentTower.splashDist), 
                                                (parentTower.splashDist*2), 
                                                (parentTower.splashDist*2));
                        for (CCSprite *target in m._targets) {
                            CGRect thistargetRect = CGRectMake(target.position.x - (target.contentSize.width/2), 
                                                               target.position.y - (target.contentSize.height/2), 
                                                               target.contentSize.width, 
                                                               target.contentSize.height);
                            if (CGRectIntersectsRect(splashRect, thistargetRect)) {
                                thisCreep = (Creep *) target;
                                thisCreep.hp -= thisHitDamage;
                                if (thisCreep.hp <= 0) {
                                    
                                    [targetsToDelete addObject:target];
                                    [gameHUD updateResources: rand()%(baseAttributes.baseMoneyDropped)];
                                    [self removeChild:thisCreep.healthBar cleanup:YES];
                                    
                                }
                            }
                        }
                        break;
                    default:
                        break;
                }
                
                if (creep.hp <= 0) {
                    
                    [targetsToDelete addObject:target];
                    [gameHUD updateResources: rand()%(baseAttributes.baseMoneyDropped)];
                    [self removeChild:creep.healthBar cleanup:YES];
                    
                }
                break;
                
			}						
						
		}
		
		for (CCSprite *target in targetsToDelete) {
			[m._targets removeObject:target];
			[self removeChild:target cleanup:YES];	
            
		}
		
		[targetsToDelete release];
	}
	
	for (CCSprite *projectile in projectilesToDelete) {
		[m._projectiles removeObject:projectile];
		[self removeChild:projectile cleanup:YES];
	}
	[projectilesToDelete release];
    
    
    Wave *wave = [self getCurrentWave];
    if ([m._targets count] ==0 && wave.redCreeps <= 0 && wave.greenCreeps <= 0 && wave.brownCreeps <= 0) {
        if (self.currentLevel == 5) {
            CCLayerColor *endGameLayer =[[[EndGame alloc]init:YES]autorelease];
            [self.parent addChild:endGameLayer z:10];
            [[CCDirector sharedDirector] pause]; 
        }
        else{
        [self schedule:@selector(waveWait) interval:3.0];
        [gameHUD newWaveApproaching];
        }
    }
}


- (CGPoint)boundLayerPos:(CGPoint)newPos {
    CGSize winSize = [CCDirector sharedDirector].winSize;
    CGPoint retval = newPos;
    retval.x = MIN(retval.x, 0);
    retval.x = MAX(retval.x, -_tileMap.contentSize.width+winSize.width); 
    retval.y = MIN(0, retval.y);
    retval.y = MAX(-_tileMap.contentSize.height+winSize.height, retval.y); 
    return retval;
}

- (void)handlePanFrom:(UIPanGestureRecognizer *)recognizer {
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {    
        
        CGPoint touchLocation = [recognizer locationInView:recognizer.view];
        touchLocation = [[CCDirector sharedDirector] convertToGL:touchLocation];
        touchLocation = [self convertToNodeSpace:touchLocation];                
        
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {    
        
        CGPoint translation = [recognizer translationInView:recognizer.view];
        translation = ccp(translation.x, -translation.y);
        CGPoint newPos = ccpAdd(self.position, translation);
        self.position = [self boundLayerPos:newPos];  
        [recognizer setTranslation:CGPointZero inView:recognizer.view];    
        
    } else if (recognizer.state == UIGestureRecognizerStateEnded) {
               
		float scrollDuration = 0.2;
		CGPoint velocity = [recognizer velocityInView:recognizer.view];
		CGPoint newPos = ccpAdd(self.position, ccpMult(ccp(velocity.x, velocity.y * -1), scrollDuration));
		newPos = [self boundLayerPos:newPos];

		[self stopAllActions];
		CCMoveTo *moveTo = [CCMoveTo actionWithDuration:scrollDuration position:newPos];            
		[self runAction:[CCEaseOut actionWithAction:moveTo rate:1]];            
        
    }        
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	[super dealloc];
}

@end
