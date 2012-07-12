//
//  DataModel.h
//  RuneDefense
//
//  Created by Tamas Demeter-Haludka on 7/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface DataModel : NSObject {
    
}

@property (nonatomic, retain) CCLayer *gameLayer;
@property (nonatomic, retain) CCLayer *gameHUDLayer;
@property (nonatomic, retain) NSMutableArray *projectiles;
@property (nonatomic, retain) NSMutableArray *towers;
@property (nonatomic, retain) NSMutableArray *targets;
@property (nonatomic, retain) NSMutableArray *waypoints;
@property (nonatomic, retain) NSMutableArray *waves;
@property (nonatomic, retain) UIPanGestureRecognizer *gestureRecognizer;

+ (DataModel *)getModel;

@end
