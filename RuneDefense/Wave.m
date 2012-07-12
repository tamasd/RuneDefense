//
//  Wave.m
//  RuneDefense
//
//  Created by Tamas Demeter-Haludka on 7/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Wave.h"

@implementation Wave

@synthesize spawnRate, redCreeps, greenCreeps, brownCreeps, creepType;

- (id)initWithCreep:(Creep *)creep spawnRate:(float)spawnrate redCreeps:(int)redcreeps greenCreeps:(int)greencreeps brownCreeps:(int)browncreeps
{
    NSAssert(creep != nil, @"Invalid creep for wave.");
    
    if (self = [super init]) {
        self.creepType = creep;
        self.spawnRate = spawnrate;
        self.redCreeps = redcreeps;
        self.greenCreeps = greencreeps;
        self.brownCreeps = browncreeps;
    }
    
    return self;
}

@end
