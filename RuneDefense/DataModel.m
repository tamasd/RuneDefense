//
//  DataModel.m
//  RuneDefense
//
//  Created by Tamas Demeter-Haludka on 7/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DataModel.h"

@implementation DataModel

@synthesize gameLayer, waves, waypoints, targets, gestureRecognizer, gameHUDLayer, projectiles, towers;

+ (DataModel *)getModel
{
    static DataModel *model = nil;
    if (!model) {
        model = [[DataModel alloc] init];
    }
    return model;
}

-(void)encodeWithCoder:(NSCoder *)coder
{
    
}

-(id)initWithCoder:(NSCoder *)coder
{
    
	return self;
}

- (id) init
{
	if ((self = [super init])) {
		projectiles = [[NSMutableArray alloc] init];
		towers = [[NSMutableArray alloc] init];
		targets = [[NSMutableArray alloc] init];
		
		waypoints = [[NSMutableArray alloc] init];
		
		waves = [[NSMutableArray alloc] init];
	}
	return self;
}

- (void)dealloc
{	
	self.gameLayer = nil;
	self.gameHUDLayer = nil;
	self.gestureRecognizer = nil;
	
	[projectiles release];
	projectiles = nil;
	
	[towers release];
	towers = nil;
	
	[targets release];
	targets = nil;	
	
	[waypoints release];
	waypoints = nil;
	
	[waves release];
	waves = nil;	
	[super dealloc];
}

@end
