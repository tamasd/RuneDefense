//
//  BaseAttributes.m
//  TowerDefenseTutorialPart7
//
//  Created by Aiden Fry on 01/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BaseAttributes.h"

@implementation BaseAttributes

@synthesize baseHealth = baseHealth;
@synthesize baseStartingMoney = baseStartingMoney;
@synthesize baseMoneyRegen = baseMoneyRegen;
@synthesize baseMoneyRegenRate = baseMoneyRegenRate;
@synthesize baseMoneyDropped = baseMoneyDropped;
@synthesize baseTowerCostPercentage = baseTowerCostPercentage;

@synthesize baseMGCost = baseMGCost;
@synthesize baseMGDamage = baseMGDamage;
@synthesize baseMGDamageRandom = baseMGDamageRandom;
@synthesize baseMGFireRate = baseMGFireRate;
@synthesize baseMGRange = baseMGRange;
@synthesize baseMGlvlup1 = baseMGlvlup1;
@synthesize baseMGlvlup2 = baseMGlvlup2;

@synthesize baseFCost = baseFCost;
@synthesize baseFDamage = baseFDamage;
@synthesize baseFDamageRandom = baseFDamageRandom;
@synthesize baseFFireRate = baseFFireRate;
@synthesize baseFFreezeDur = baseFFreezeDur;
@synthesize baseFRange = baseFRange;
@synthesize baseFlvlup1 = baseFlvlup1;
@synthesize baseFlvlup2 = baseFlvlup2;

@synthesize baseCCost = baseCCost;
@synthesize baseCDamage = baseCDamage;
@synthesize baseCDamageRandom = baseCDamageRandom;
@synthesize baseCFireRate = baseCFireRate;
@synthesize baseCSplashDist = baseCSplashDist;
@synthesize baseCRange = baseCRange;
@synthesize baseClvlup1 = baseClvlup1;
@synthesize baseClvlup2 = baseClvlup2;


@synthesize baseRedCreepHealth = baseRedCreepHealth;
@synthesize baseRedCreepMoveDur = baseRedCreepMoveDur;
@synthesize baseRedCreepKilledScore = baseRedCreepKilledScore;
@synthesize baseGreenCreepHealth = baseGreenCreepHealth;
@synthesize baseGreenCreepMoveDur = baseGreenCreepMoveDur;
@synthesize baseGreenCreepKilledScore = baseGreenCreepKilledScore;
@synthesize baseBrownCreepHealth = baseBrownCreepHealth;
@synthesize baseBrownCreepMoveDur = baseBrownCreepMoveDur;
@synthesize baseBrownCreepKilledScore = baseBrownCreepKilledScore;
@synthesize baseCreepDamage = baseCreepDamage;


static BaseAttributes *_sharedAttributes = nil;

+ (BaseAttributes *)sharedAttributes
{
	@synchronized([BaseAttributes class])
	{
		if (!_sharedAttributes)
			[[self alloc] init];
		return _sharedAttributes;
	}
	// to avoid compiler warning
	return nil;
}

+(id)alloc
{
	@synchronized([BaseAttributes class])
	{
		NSAssert(_sharedAttributes == nil, @"Attempted to allocate a second instance of a singleton.");
		_sharedAttributes = [super alloc];
		return _sharedAttributes;
	}
	// to avoid compiler warning
	return nil;
}


-(id) init
{
    if ((self=[super init]) ) {
        baseHealth = 100;
        
        baseStartingMoney = 500;
        baseMoneyRegen = 25;// Affects how much money is regenerated
        baseMoneyRegenRate = 5.0; // How fast in seconds
        baseMoneyDropped = 8;//Affects how much money is dropped by a creep (maximum +1)
        baseTowerCostPercentage = 1; //Makes all towers cheaper/more expensive 1 = same, 0.5 = half etc.
        
        baseMGCost = 100;
        baseMGDamage = 10;//Damage (minimum)
        baseMGDamageRandom = 10;//Random amount for extra hit points
        baseMGFireRate = 0.5;
        baseMGRange = 150;
        baseMGlvlup1 = 300;
        baseMGlvlup2 = 450;
        
        baseFCost = 125;
        baseFDamage = 0;//Damage (minimum)
        baseFDamageRandom = 5;//Random amount for extra hit points
        baseFFireRate = 0.75;
        baseFFreezeDur = 0.20;
        baseFRange = 100;
        baseFlvlup1 = 50;
        baseFlvlup2 = 75;
        
        baseCCost = 200;
        baseCDamage = 40;//Damage (minimum)
        baseCDamageRandom = 20;//Random amount for extra hit points
        baseCFireRate = 4.0;
        baseCSplashDist = 50;
        baseCRange = 200;
        baseClvlup1 = 500;
        baseClvlup2 = 750;
        
        baseRedCreepHealth = 100; // RED
        baseRedCreepMoveDur = 4.5;
        baseRedCreepKilledScore = 10;
        
        baseGreenCreepHealth = 300; // GREEN
        baseGreenCreepMoveDur = 7.0;  
        baseGreenCreepKilledScore = 15;

        
        baseBrownCreepHealth = 2000; // BROWN
        baseBrownCreepMoveDur = 10;
        baseBrownCreepKilledScore = 200;
        
        baseCreepDamage = 20; // The Ammount a creep hurts your base.

    }
    
    return self;
}
@end
