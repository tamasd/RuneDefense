//
//  Wave.h
//  Cocos2D Build a Tower Defense Game
//
//  Created by iPhoneGameTutorials on 4/4/11.
//  Copyright 2011 iPhoneGameTutorial.com All rights reserved.
//

#import "cocos2d.h"

#import "Creep.h"

@interface Wave : CCNode {
	float _spawnRate;
	int _redCreeps;
    int _greenCreeps;
    int _brownCreeps;

	Creep * _creepType;
}

@property (nonatomic) float spawnRate;
@property (nonatomic) int redCreeps;
@property (nonatomic) int greenCreeps;
@property (nonatomic) int brownCreeps;

@property (nonatomic, retain) Creep *creepType;

- (id) initWithCreep:(Creep *)creep SpawnRate:(float)spawnrate RedCreeps:(int)redcreeps GreenCreeps: (int)greencreeps BrownCreeps: (int)browncreeps;

@end
