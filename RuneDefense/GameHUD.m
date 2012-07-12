//
//  GameHUD.m
//  RuneDefense
//
//  Created by Tamas Demeter-Haludka on 7/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameHUD.h"
#import "DataModel.h"
#import "baseAttributes.h"
#import "PauseLayer.h"

@implementation GameHUD

@synthesize resources, baseHpPercentage, waveCount;

bool resetGameHUD;

+ (GameHUD *)sharedHUD
{
    static GameHUD *sharedHUD = nil;
	@synchronized([GameHUD class])
	{
		if (!sharedHUD) {
			sharedHUD = [[GameHUD alloc] init];
        }
	}
	return sharedHUD;
}

-(id) init
{
	if ((self = [super init])) {
		
		CGSize winSize = [CCDirector sharedDirector].winSize;
        baseAttributes = [BaseAttributes sharedAttributes];
        [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGB565];
        background = [CCSprite spriteWithFile:@"hud.png"];
        background.anchorPoint = ccp(0,0);
        [self addChild:background];
        [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_Default];
		
        movableSprites = [[NSMutableArray alloc] init];
        NSArray *images = [NSArray arrayWithObjects:@"MachineGunTurret.png", @"FreezeTurret.png", @"CannonTurret.png", nil];  
        for(int i = 0; i < images.count; ++i) {
            NSString *image = [images objectAtIndex:i];
            CCSprite *sprite = [CCSprite spriteWithFile:image];
            float offsetFraction = ((float)(i+1))/(images.count+1);
            sprite.position = ccp(winSize.width*offsetFraction, 35);
            sprite.tag = i+1;
            [self addChild:sprite];
            [movableSprites addObject:sprite];
            
            //Set up and place towerCost labels
            CCLabelTTF *towerCost = [CCLabelTTF labelWithString:@"$" fontName:@"Marker Felt" fontSize:10];
            towerCost.position = ccp(winSize.width*offsetFraction, 15);
            towerCost.color = ccc3(0, 0, 0);
            [self addChild:towerCost z:1];
            
            //Set cost values
            switch (i) {
                case 0:
                    [towerCost setString:[NSString stringWithFormat:@"$ %i", (int)(baseAttributes.baseMGCost*baseAttributes.baseTowerCostPercentage)]];
                    break;
                case 1:
                    [towerCost setString:[NSString stringWithFormat:@"$ %i",(int)(baseAttributes.baseFCost*baseAttributes.baseTowerCostPercentage)]];
                    break;
                case 2:
                    [towerCost setString:[NSString stringWithFormat:@"$ %i",(int)(baseAttributes.baseCCost*baseAttributes.baseTowerCostPercentage)]];
                    break;
                    
                default:
                    break;
            }
        }
        
        
        //CGSize winSize = [CCDirector sharedDirector].winSize;
        
        // Set up Resources and Resource label
        resourceLabel = [CCLabelTTF labelWithString:@"Money $100" dimensions:CGSizeMake(150, 25) alignment:UITextAlignmentRight fontName:@"Marker Felt" fontSize:20];
        resourceLabel.position = ccp(30, (winSize.height - 15));
        resourceLabel.color = ccc3(255,80,20);
        [self addChild:resourceLabel z:1];
        
        resources = baseAttributes.baseStartingMoney;
        [self->resourceLabel setString:[NSString stringWithFormat: @"Money $%i",resources]];
        
        // Set up BaseHplabel
        CCLabelTTF *baseHpLabel = [CCLabelTTF labelWithString:@"Base Health" dimensions:CGSizeMake(150, 25) alignment:UITextAlignmentRight fontName:@"Marker Felt" fontSize:20];
        baseHpLabel.position = ccp((winSize.width - 185), (winSize.height - 15));
        baseHpLabel.color = ccc3(255,80,20);
        [self addChild:baseHpLabel z:1];
        
        // Set up wavecount label
        waveCount = 0;
        waveCountLabel = [CCLabelTTF labelWithString:@"Wave 1" dimensions:CGSizeMake(150, 25) alignment:UITextAlignmentRight fontName:@"Marker Felt" fontSize:20];
        waveCountLabel.position = ccp(((winSize.width/2) - 80), (winSize.height - 15));
        waveCountLabel.color = ccc3(100,0,100);
        [self addChild:waveCountLabel z:1];
        
        
        // Set up new Wave label
        newWaveLabel = [CCLabelTTF labelWithString:@"" dimensions:CGSizeMake(300, 50) alignment:UITextAlignmentRight fontName:@"TrebuchetMS-Bold" fontSize:30];
        newWaveLabel.position = ccp((winSize.width/2)-20, (winSize.height/2)+30);
        newWaveLabel.color = ccc3(255,50,50);
        [self addChild:newWaveLabel z:1];
        
        //Set up helth Bar
        //healthBar = [CCProgressTimer progressWithFile:@"health_bar_green.png"];
        healthBar = [CCProgressTimer progressWithSprite:[CCSprite spriteWithFile:@"health_bar_green.png"]];
        healthBar.type = kCCProgressTimerTypeBar;
        healthBar.percentage = baseHpPercentage;
        [healthBar setScale:0.5]; 
        healthBar.position = ccp(winSize.width - 55, winSize.height - 15);
        [self addChild:healthBar z:1];
        
        baseHpPercentage = 100;
        [healthBar setPercentage:baseHpPercentage];
        
        
        
        [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
        
        [self schedule:@selector(updateResourcesNom) interval: baseAttributes.baseMoneyRegenRate];
        
        [self schedule:@selector(update:)];
        
        resetGameHUD = NO;
        
        CCMenuItemImage *pauseButton = [CCMenuItemImage itemFromNormalImage:@"Pause.png" selectedImage:@"Pause.png" target:self selector:@selector(pauseGame)];
        pauseButton.scale = 0.13;
        
        CCMenu *menu = [CCMenu menuWithItems:pauseButton, nil];
		menu.position = ccp(winSize.width - 35, 35);
		[menu alignItemsVerticallyWithPadding: 20.0f];
		[self addChild:menu];
	}
    return self;
}
+(void) resetGameHUD
{
    resetGameHUD = YES;
}

-(void) resetGameHUDLayer
{
    resetGameHUD = NO;
    
    [healthBar setSprite:[CCSprite spriteWithFile:@"health_bar_green.png"]];
    [healthBar setScale:0.5]; 
    baseHpPercentage = 99;
    [healthBar setPercentage:baseHpPercentage];    
    [self updateBaseHp:+1];
    
    waveCount = 0;
    [waveCountLabel setString:[NSString stringWithFormat: @"Wave 1"]];
    
    resources = baseAttributes.baseStartingMoney;
    [resourceLabel setString:[NSString stringWithFormat: @"Money $%i",resources]];
}

-(void) pauseGame
{
    CCLayerColor *pauseLayer =[[[PauseLayer alloc]init]autorelease];
    [self.parent addChild:pauseLayer z:10];
    [[CCDirector sharedDirector] pause];
}

-(void) update:(ccTime) dt{
    
    if (resetGameHUD == YES) {
        [self resetGameHUDLayer];
    }
    
    for (CCSprite *sprite in movableSprites){
        switch (sprite.tag) {
            case 1:
                if (baseAttributes.baseMGCost*baseAttributes.baseTowerCostPercentage > resources)
                {
                    sprite.opacity = 50;
                    break;
                }
                else
                    sprite.opacity = 255;
                break;
            case 2:
                if (baseAttributes.baseFCost*baseAttributes.baseTowerCostPercentage > resources)
                {
                    sprite.opacity = 50;
                    break;
                }
                else
                    sprite.opacity = 255;
                break;
            case 3:
                if (baseAttributes.baseCCost*baseAttributes.baseTowerCostPercentage > resources)
                {
                    sprite.opacity = 50;
                    break;
                }
                else
                    sprite.opacity = 255;
                break;
            default:
                break;
        }
        
    }
}

-(void) updateBaseHp:(int)amount{
    baseHpPercentage += amount;
    
    if (baseHpPercentage <= 25) {
        [self->healthBar setSprite:[CCSprite spriteWithFile:@"health_bar_red.png"]];
        [self->healthBar setScale:0.5]; 
    }
    
    if (baseHpPercentage <= 0) {
        //Game Over Scenario
        //printf("Game Over\n");
        
        CCLayerColor *endGameLayer =[[[EndGame alloc]init:NO ]autorelease];
        [self.parent addChild:endGameLayer z:10];
        [[CCDirector sharedDirector] pause]; 
    }
    
    [self->healthBar setPercentage:baseHpPercentage];
}

-(void) updateResources:(int)amount{
    resources += amount;
    [self->resourceLabel setString:[NSString stringWithFormat: @"Money $%i",resources]];
}

-(void) updateResourcesNom{
    resources += baseAttributes.baseMoneyRegen;
    [self->resourceLabel setString:[NSString stringWithFormat: @"Money $%i",resources]];
}
-(void) updateWaveCount{
    waveCount++;
    [self->waveCountLabel setString:[NSString stringWithFormat: @"Wave %i",waveCount]];
}

-(void) newWaveApproaching{
    [newWaveLabel setString:[NSString stringWithFormat: @"HERE THEY COME!"]];
}
-(void) newWaveApproachingEnd{
    [newWaveLabel setString:[NSString stringWithFormat: @" "]];
}


- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {  
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    CCSprite * newSprite = nil;
    for (CCSprite *sprite in movableSprites) {
        if (CGRectContainsPoint(sprite.boundingBox, touchLocation)) { 
            if (sprite.opacity == 255) {
                
                
                DataModel *m = [DataModel getModel];
                m.gestureRecognizer.enabled = NO;
                
                selSpriteRange = [CCSprite spriteWithFile:@"Range.png"];
                
                switch (sprite.tag) {
                    case 1:
                        selSpriteRange.scale = (baseAttributes.baseMGRange/50);
                        break;
                    case 2:
                        selSpriteRange.scale = (baseAttributes.baseFRange/50);
                        break; 
                    case 3:
                        selSpriteRange.scale = (baseAttributes.baseCRange/50);
                        break;
                    default:
                        break;
                }
                [self addChild:selSpriteRange z:-1];
                selSpriteRange.position = sprite.position;
                
                newSprite = [CCSprite spriteWithTexture:[sprite texture]]; //sprite;
                newSprite.position = ccpAdd(sprite.position, ccp(0, 20));
                selSprite = newSprite;
                selSprite.tag = sprite.tag;
                [self addChild:newSprite];
                
			}
            break;
        }
    }     
	return YES;
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {  
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    
    CGPoint oldTouchLocation = [touch previousLocationInView:touch.view];
    oldTouchLocation = [[CCDirector sharedDirector] convertToGL:oldTouchLocation];
    oldTouchLocation = [self convertToNodeSpace:oldTouchLocation];
    
    CGPoint translation = ccpSub(touchLocation, oldTouchLocation);    
	
	if (selSprite) {
		CGPoint newPos = ccpAdd(selSprite.position, translation);
        selSprite.position = newPos;
		selSpriteRange.position = newPos;
		
		DataModel *m = [DataModel getModel];
		CGPoint touchLocationInGameLayer = [m.gameLayer convertTouchToNodeSpace:touch];
		
		BOOL isBuildable = (bool)[m.gameLayer canBuildOnTilePosition: touchLocationInGameLayer];
		if (isBuildable) {
			selSprite.opacity = 200;
		} else {
			selSprite.opacity = 50;		
		}
	}
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {  
	CGPoint touchLocation = [self convertTouchToNodeSpace:touch];	
	DataModel *m = [DataModel getModel];
    
	if (selSprite) {
		CGRect backgroundRect = CGRectMake(background.position.x, 
                                           background.position.y, 
                                           background.contentSize.width, 
                                           background.contentSize.height);
		
		if (!CGRectContainsPoint(backgroundRect, touchLocation)) {
			CGPoint touchLocationInGameLayer = [m.gameLayer convertTouchToNodeSpace:touch];
			[m.gameLayer addTower: touchLocationInGameLayer: selSprite.tag];
		}
		
		[self removeChild:selSprite cleanup:YES];
		selSprite = nil;		
		[self removeChild:selSpriteRange cleanup:YES];
		selSpriteRange = nil;			
	}
	
	m.gestureRecognizer.enabled = YES;
}
- (void) registerWithTouchDispatcher
{
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	[movableSprites release];
    movableSprites = nil;
	[super dealloc];
}

@end
