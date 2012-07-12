//
//  Wave.h
//  RuneDefense
//
//  Created by Tamas Demeter-Haludka on 7/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CCNode.h"

@class Creep;

@interface Wave : CCNode

@property (nonatomic, assign) float spawnRate;
@property (nonatomic) int redCreeps;
@property (nonatomic) int greenCreeps;
@property (nonatomic) int brownCreeps;
@property (nonatomic, retain) Creep *creepType;

- (id)initWithCreep:(Creep *)creep spawnRate:(float)spawnrate redCreeps:(int)redcreeps greenCreeps:(int)greencreeps brownCreeps:(int)browncreeps;

@end
