//
//  EndGame.m
//  TowerDefenceTutorialPart9(EndGame)
//
//  Created by Aiden Fry on 15/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EndGame.h"


@implementation EndGame

-(id) init:(bool) win
{
	if( (self=[super initWithColor:ccc4(150,50,50,255)])) {
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        
        self.isTouchEnabled = YES;

        GameHUD *gameHUD;
        gameHUD = [GameHUD sharedHUD];

        CCLabelTTF *endGameLabel = [CCLabelTTF labelWithString:@"" dimensions:CGSizeMake(150, 40) alignment:UITextAlignmentRight fontName:@"Marker Felt" fontSize:30];
        endGameLabel.position = ccp((winSize.width/2-10), (winSize.height - 30));
        endGameLabel.color = ccc3(255,80,20);
        [self addChild:endGameLabel z:1];
        
        if (win == NO){
        [endGameLabel setString:[NSString stringWithFormat: @"You Loose!"]];
        }
        else 
        {
            [endGameLabel setString:[NSString stringWithFormat: @"You Win!"]];

        }
        CCLabelTTF *welldoneLabel = [CCLabelTTF labelWithString:@"" dimensions:CGSizeMake(300, 40) alignment:UITextAlignmentRight fontName:@"Marker Felt" fontSize:30];
        welldoneLabel.position = ccp((winSize.width/2-30), (winSize.height/2 + 75));
        welldoneLabel.color = ccc3(255,80,20);
        [self addChild:welldoneLabel z:1];
        
        [welldoneLabel setString:[NSString stringWithFormat: @"You reached wave %i",gameHUD.waveCount]];        
        
        CCLabelTTF *restartLabel = [CCLabelTTF labelWithString:@"Restart?" dimensions:CGSizeMake(300, 40) alignment:UITextAlignmentRight fontName:@"Marker Felt" fontSize:30];
        restartLabel.position = ccp((winSize.width/2 - 150), (winSize.height/2));
        restartLabel.color = ccc3(255,80,20);
        [self addChild:restartLabel z:1];
        
        CCLabelTTF *menuLabel = [CCLabelTTF labelWithString:@"Menu" dimensions:CGSizeMake(300, 40) alignment:UITextAlignmentRight fontName:@"Marker Felt" fontSize:30];
        menuLabel.position = ccp((winSize.width/2 - 150), (winSize.height/2-50));
        menuLabel.color = ccc3(255,80,20);
        [self addChild:menuLabel z:1];
        
        CCMenuItemImage *replayButton;        
        CCMenuItemImage *menuButton;
        CCMenu *menu;
        
            replayButton = [CCMenuItemImage itemFromNormalImage:@"Buy.png" selectedImage:@"Buy.png" target:self selector:@selector(replayLevel)];
            
        menuButton = [CCMenuItemImage itemFromNormalImage:@"Buy.png" selectedImage:@"Buy.png" target:self selector:@selector(returnToMenu)];
                menu = [CCMenu menuWithItems: replayButton, menuButton, nil];

		menu.position = ccp((winSize.width/2 + 50), (winSize.height/2-22));
		[menu alignItemsVerticallyWithPadding: 5.0f];
		[self addChild:menu];
        
        [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:10 swallowsTouches:YES];
        
	}	
	return self;
}

-(void) replayLevel
{
//Reset the game and start from the begining. 

    [GameHUD resetGameHUD];
    [Tutorial resetGame];
    [self.parent removeChild:self cleanup:TRUE];
    [[CCDirector sharedDirector] resume];
}

-(void) returnToMenu
{
    CCLayer *menuLayer =[[[MenuLayer alloc]init ]autorelease];
    [self.parent addChild:menuLayer z:10];
    [self.parent removeChild:self cleanup:TRUE];
}

-(void) dealloc{
    [super dealloc];
}

@end
