//
//  MenuScene.m
//  TowerDefenceTutorialPart9_(GameOver)
//
//  Created by Aiden Fry on 15/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MenuLayer.h"

@implementation MenuLayer

-(id)init{
    
    if ((self = [super init])) {
		CGSize winSize = [[CCDirector sharedDirector] winSize];
        
		CCSprite *background = [CCSprite spriteWithFile:@"MenuScreen.png"];
		background.position = ccp(winSize.width/2, winSize.height/2);
		[self addChild:background];
        
		CCMenuItemImage *rangeButton = [CCMenuItemImage itemFromNormalImage:@"Buy.png" selectedImage:@"Buy.png" target:self selector:@selector(startGame)];
        
        
		CCMenu *menu = [CCMenu menuWithItems:rangeButton, nil];
		menu.position = ccp(winSize.width/2-65, winSize.height/2-15);
		[menu alignItemsVerticallyWithPadding: 20.0f];
		[self addChild:menu];
	}
    
    return self;
}

-(void) startGame
{
    [GameHUD resetGameHUD];
    [Tutorial resetGame];
    [self.parent removeChild:self cleanup:TRUE];
    [[CCDirector sharedDirector] resume];
}

-(void) dealloc{
    [super dealloc];
}

@end