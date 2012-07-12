//
//  StartScreenLayer.m
//  RuneDefense
//
//  Created by Tamas Demeter-Haludka on 7/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "StartScreenLayer.h"
#import "LevelScreenLayer.h"

@interface StartScreenLayer ()

- (void)addLabel:(CGSize)winsize;
- (void)addButtons:(CGSize)winsize;

@end

@implementation StartScreenLayer

+ (CCScene *)scene
{
    // 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	StartScreenLayer *layer = [StartScreenLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

- (id)init
{
    if (self = [super init]) {
        CGSize size = [[CCDirector sharedDirector] winSize];
        
        [CCMenuItemFont setFontSize:28];
        
        [self addLabel:size];
        [self addButtons:size];
    }
    
    return self;
}

#pragma mark Drawing methods

- (void)addLabel:(CGSize)winsize
{
    CCLabelTTF *label = [CCLabelTTF labelWithString:@"RuneDefense" fontName:@"Marker Felt" fontSize:64];
    [label setPosition:ccp(winsize.width/2, winsize.height/2)];
    [self addChild:label];
}

- (void)addButtons:(CGSize)winsize
{
    CCMenuItem *itemStartGame = [CCMenuItemFont itemWithString:@"Start Game" block:^(id sender) {
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[LevelScreenLayer scene] withColor:ccWHITE]];
    }];
    
    CCMenu *menu = [CCMenu menuWithItems:itemStartGame, nil];
    [menu alignItemsHorizontallyWithPadding:20];
    [menu setPosition:ccp(winsize.width/2, winsize.height/2 - 50)];
    
    [self addChild:menu];
}


#pragma mark GameKit

- (void)achievementViewControllerDidFinish:(GKAchievementViewController *)viewController
{
    
}

- (void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
    
}

@end
