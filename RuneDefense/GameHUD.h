//
//  GameHUD.h
//  Cocos2D Build a Tower Defense Game
//
//  Created by iPhoneGameTutorials on 4/4/11.
//  Copyright 2011 iPhoneGameTutorial.com All rights reserved.
//

#import "cocos2d.h"
#import "baseAttributes.h"

//#import "PauseLayer.h"

@interface GameHUD : CCLayer {
	CCSprite * background;
	
	CCSprite * selSpriteRange;
    CCSprite * selSprite;
    NSMutableArray * movableSprites;
    int resources;
    CCLabelTTF *resourceLabel;
    CCLabelTTF *waveCountLabel;
    CCLabelTTF *newWaveLabel;
    float baseHpPercentage;
    CCProgressTimer *healthBar;
    BaseAttributes *baseAttributes;
    
    int waveCount;

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
