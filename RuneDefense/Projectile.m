//
//  Projectile.m
//  Cocos2D Build a Tower Defense Game
//
//  Created by iPhoneGameTutorials on 4/4/11.
//  Copyright 2011 iPhoneGameTutorial.com All rights reserved.
//

#import "Projectile.h"

@implementation Projectile
@synthesize parentTower = parentTower;

+ (id)projectile: (id) sender {
	
    Projectile *projectile = nil;
    
    if ((projectile = [[[super alloc] initWithFile:@"Projectile.png"] autorelease])) {
        projectile.parentTower = sender;
    }    
    
    return projectile;
    
}

- (void) dealloc
{  
    [super dealloc];
}

@end

@implementation IceProjectile

+ (id)projectile : (id) sender{
	
    IceProjectile *projectile = nil;
    
    if ((projectile = [[[super alloc] initWithFile:@"IceProjectile.png"] autorelease])) {
        projectile.parentTower = sender;
    }    
    
    return projectile;
    
}

- (void) dealloc
{  
    [super dealloc];
}

@end

@implementation CannonProjectile

+ (id)projectile : (id) sender{
	
    CannonProjectile *projectile = nil;
    
    if ((projectile = [[[super alloc] initWithFile:@"CannonProjectile.png"] autorelease])) {
        projectile.parentTower = sender;
    }    
    
    return projectile;
    
}

- (void) dealloc
{  
    [super dealloc];
}

@end
