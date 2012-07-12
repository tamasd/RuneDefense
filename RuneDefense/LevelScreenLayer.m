//
//  LevelScreenLayer.m
//  RuneDefense
//
//  Created by Tamas Demeter-Haludka on 7/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LevelScreenLayer.h"
#import "MapScreenLayer.h"

@implementation LevelScreenLayer

+ (CCScene *)scene
{
    // 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	LevelScreenLayer *layer = [LevelScreenLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

- (id)init
{
    if (self = [super init]) {
        CGSize size = [[CCDirector sharedDirector] winSize];
        CCMenuItem *firstLevel = [CCMenuItemImage itemWithNormalImage:@"castle.png" selectedImage:@"castle.png" block:^(id sender){
            [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[MapScreenLayer node] withColor:ccWHITE]];
        }];
        
        CCMenu *menu = [CCMenu menuWithItems:firstLevel, nil];
        [menu alignItemsVerticallyWithPadding:20];
        [menu setPosition:ccp(size.width/2 + 100, size.height / 2)];
        
        [self addChild:menu];
    }
    return self;
}

@end
