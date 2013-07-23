//
//  HelloWorldLayer.m
//  Cocos_iAd
//
//  Created by Gururaj T on 23/07/13.
//  Copyright gururaj.tallur@gmail.com 2013. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"
#import "MyiAd.h"

#pragma mark - HelloWorldLayer

// HelloWorldLayer implementation
@implementation HelloWorldLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) ) {
		
        mIAd = nil;

        
	 

		// ask director for the window size
		CGSize size = [[CCDirector sharedDirector] winSize];
	 		
		//
		// Leaderboards and Achievements
		//
		
		// Default font size will be 28 points.
		[CCMenuItemFont setFontSize:28];
		
		// to avoid a retain-cycle with the menuitem and blocks
		__block id copy_self = self;
		
		// Achievement Menu Item using blocks
		CCMenuItem *item_1 = [CCMenuItemFont itemWithString:@"Show iAd" block:^(id sender) {
			
			if(!mIAd)
            {
                mIAd = [[MyiAd alloc] init];
            }
			
		}];
		
		// Leaderboard Menu Item using blocks
		CCMenuItem *item_2 = [CCMenuItemFont itemWithString:@"Hide iAd" block:^(id sender) {
                if(mIAd)
                {
                    [mIAd RemoveiAd ];
                    
                    mIAd = nil;
                }
            }];

		
		CCMenu *menu = [CCMenu menuWithItems:item_1, item_2, nil];
		
		[menu alignItemsHorizontallyWithPadding:20];
		[menu setPosition:ccp( size.width/2, size.height/2 - 50)];
		
		// Add the menu to the layer
		[self addChild:menu];

	}
	return self;
}

-(void)onExit
{
    if(mIAd)
    {
        [mIAd RemoveiAd ];
        
        mIAd = nil;
    }
    
    [super onExit];
}



// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}

#pragma mark GameKit delegate

-(void) achievementViewControllerDidFinish:(GKAchievementViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}

-(void) leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}
@end
