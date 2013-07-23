//
//  HelloWorldLayer.h
//  Cocos_iAd
//
//  Created by Gururaj T on 23/07/13.
//  Copyright gururaj.tallur@gmail.com 2013. All rights reserved.
//


#import <GameKit/GameKit.h>

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

@class MyiAd;

// HelloWorldLayer
@interface HelloWorldLayer : CCLayer <GKAchievementViewControllerDelegate, GKLeaderboardViewControllerDelegate>
{
    MyiAd               *mIAd;

}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

@end
