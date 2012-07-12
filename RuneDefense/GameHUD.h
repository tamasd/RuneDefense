//
//  GameHUD.h
//  RuneDefense
//
//  Created by Tamas Demeter-Haludka on 7/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class BaseAttributes;

@interface GameHUD : CCLayer {
	CCSprite *background;
	CCSprite *selSpriteRange;
    CCSprite *selSprite;
    NSMutableArray *movableSprites;
    int resources;
    CCLabelTTF *resourceLabel;
    CCLabelTTF *waveCountLabel;
    CCLabelTTF *newWaveLabel;
    CCProgressTimer *healthBar;
    BaseAttributes *baseAttributes;
}

@property (nonatomic, assign) int resources;
@property (nonatomic, assign) int waveCount;
@property (nonatomic, assign) float baseHpPercentage;

+ (GameHUD *)sharedHUD;
-(void) updateBaseHp:(int)amount;
-(void) updateResources:(int)amount;
-(void) updateResourcesNom;
-(void) updateWaveCount;
-(void) newWaveApproaching;
-(void) newWaveApproachingEnd;
+(void) resetGameHUD;
-(void) resetGameHUDLayer;

@end
