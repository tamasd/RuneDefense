//
//  Projectile.h
//  Cocos2D Build a Tower Defense Game
//
//  Created by iPhoneGameTutorials on 4/4/11.
//  Copyright 2011 iPhoneGameTutorial.com All rights reserved.
//

#import "cocos2d.h"
#import "Tower.h"
#import "DataModel.h"

@interface Projectile : CCSprite {
    CCSprite *parentTower;
}
@property (nonatomic, assign) CCSprite *parentTower;
+ (id)projectile: (id) sender;

@end

@interface IceProjectile : Projectile {
}
+ (id)projectile: (id) sender;

@end

@interface CannonProjectile : Projectile {
}
+ (id)projectile: (id) sender;

@end