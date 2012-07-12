//
//  BaseAttributes.h
//  TowerDefenseTutorialPart7
//
//  Created by Aiden Fry on 01/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseAttributes : NSObject
{
    //GUI & Money attributes
    int baseHealth;
    int baseStartingMoney;
    int baseMoneyRegen;
    float baseMoneyRegenRate;
    int baseMoneyDropped;
    float baseTowerCostPercentage;
    
    //MG tower attributes
    int baseMGCost;
    int baseMGDamage;
    int baseMGDamageRandom;
    float baseMGFireRate;
    int baseMGRange;
    int baseMGlvlup1;
    int baseMGlvlup2;
    
    //Freeze tower attributes
    int baseFCost;
    int baseFDamage;
    int baseFDamageRandom;
    float baseFFireRate;
    int baseFRange;
    int baseFlvlup1;
    int baseFlvlup2;
    float baseFFreezeDur;
    
    //Cannon tower attributes
    int baseCCost;
    int baseCDamage;
    int baseCDamageRandom;
    float baseCFireRate;
    int baseCRange;
    int baseClvlup1;
    int baseClvlup2;
    float baseCSplashDist;
    
    //Creep attributes
    int baseRedCreepHealth;
    float baseRedCreepMoveDur;
    int baseRedCreepKilledScore;

    int baseGreenCreepHealth;
    float baseGreenCreepMoveDur;
    int baseGreenCreepKilledScore;

    int baseBrownCreepHealth;
    float baseBrownCreepMoveDur;
    int baseBrownCreepKilledScore;
    
    int baseCreepDamage;

}

@property (nonatomic, assign) int baseHealth;
@property (nonatomic, assign) int baseStartingMoney;
@property (nonatomic, assign)int baseMoneyRegen;
@property (nonatomic, assign)float baseMoneyRegenRate;
@property (nonatomic, assign)int baseMoneyDropped;
@property (nonatomic, assign)float baseTowerCostPercentage;

@property (nonatomic, assign)int baseMGCost;
@property (nonatomic, assign)int baseMGDamage;
@property (nonatomic, assign)int baseMGDamageRandom;
@property (nonatomic, assign)float baseMGFireRate;
@property (nonatomic, assign)int baseMGRange;
@property (nonatomic, assign)int baseMGlvlup1;
@property (nonatomic, assign)int baseMGlvlup2;

@property (nonatomic, assign)int baseFCost;
@property (nonatomic, assign)int baseFDamage;
@property (nonatomic, assign)int baseFDamageRandom;
@property (nonatomic, assign)float baseFFireRate;
@property (nonatomic, assign)float baseFFreezeDur;
@property (nonatomic, assign)int baseFRange;
@property (nonatomic, assign)int baseFlvlup1;
@property (nonatomic, assign)int baseFlvlup2;

@property (nonatomic, assign)int baseCCost;
@property (nonatomic, assign)int baseCDamage;
@property (nonatomic, assign)int baseCDamageRandom;
@property (nonatomic, assign)float baseCFireRate;
@property (nonatomic, assign)float baseCSplashDist;
@property (nonatomic, assign)int baseCRange;
@property (nonatomic, assign)int baseClvlup1;
@property (nonatomic, assign)int baseClvlup2;


@property (nonatomic, assign)int baseRedCreepHealth;
@property (nonatomic, assign)float baseRedCreepMoveDur;
@property (nonatomic, assign) int baseRedCreepKilledScore;

@property (nonatomic, assign)int baseGreenCreepHealth;
@property (nonatomic, assign)float baseGreenCreepMoveDur;
@property (nonatomic, assign) int baseGreenCreepKilledScore;

@property (nonatomic, assign)int baseBrownCreepHealth;
@property (nonatomic, assign)float baseBrownCreepMoveDur;
@property (nonatomic, assign) int baseBrownCreepKilledScore;

@property (nonatomic, assign) int baseCreepDamage;


+ (BaseAttributes *)sharedAttributes;

@end

