#import "AdmobRewarded.h"
#include "reference.h"

@implementation AdmobRewarded

- (void)initialize:(BOOL)is_real: (int)instance_id {
    [[GADMobileAds sharedInstance] startWithCompletionHandler:nil];
    playedID = REWARDED_TEST_ID;
    rewardedIds = [[NSMutableDictionary alloc]init];
    isReal = is_real;
    instanceId = instance_id;
    rootController = [AppDelegate getViewController];
}

- (void)loadRewardedVideo:(NSString*) rewardedId {
    GADRewardedAd *rewardedAd;
    if (isReal) {
        rewardedAd = [self createAndLoadRewardedAdForAdUnit:rewardedId];
    } else {
        rewardedAd = [self createAndLoadRewardedAdForAdUnit:REWARDED_TEST_ID];
    }
    [rewardedIds setObject:rewardedAd forKey:rewardedId];
}

- (GADRewardedAd *)createAndLoadRewardedAdForAdUnit:(NSString *) adUnitId {
    GADRewardedAd *rewardedAd = [[GADRewardedAd alloc] initWithAdUnitID:adUnitId];
    GADRequest *request = [GADRequest request];
    [rewardedAd loadRequest:request completionHandler:^(GADRequestError * _Nullable error) {
        if (error) {
            NSLog(@"Loading Failed");
            Object *obj = ObjectDB::get_instance(instanceId);
            obj->call_deferred("_on_rewarded_video_ad_failed_to_load", (int)error.code);
        } else {
            NSLog([@"Loading Succeeded: " stringByAppendingString:adUnitId]);
            Object *obj = ObjectDB::get_instance(instanceId);
            obj->call_deferred("_on_rewarded_video_ad_loaded");
        }
    }];
    return rewardedAd;
}

- (void) showRewardedVideo:(NSString*) rewardedId {
    GADRewardedAd* rewardedAd = [rewardedIds objectForKey:rewardedId];
    if (rewardedAd.isReady) {
        NSLog(@"Calling showRewardedVideo");
        if (playedID != rewardedId) {
            [playedID release];
            playedID = [rewardedId copy]; //for Test Ads.
        }
        [rewardedAd presentFromRootViewController:rootController delegate:self];
    } else {
        NSLog(@"Ad wasn't ready");
    }
}

/// Tells the delegate that the user earned a reward.
- (void)rewardedAd:(GADRewardedAd *)rewardedAd userDidEarnReward:(GADAdReward *)reward {
    // TODO: Reward the user.
    NSString *reqPlayedID = isReal ? rewardedAd.adUnitID : playedID;
    NSString *rewardMessage = [NSString stringWithFormat:@"Reward received with currency %@ , amount %lf , id %@", reward.type, [reward.amount doubleValue], reqPlayedID];
    NSLog(rewardMessage);
    Object *obj = ObjectDB::get_instance(instanceId);
    obj->call_deferred("_on_rewarded", [reward.type UTF8String], reward.amount.doubleValue, [reqPlayedID UTF8String]);
}

/// Tells the delegate that the rewarded ad was presented.
- (void)rewardedAdDidPresent:(GADRewardedAd *)rewardedAd {
    NSLog(@"rewardedAdDidPresent:");
}

/// Tells the delegate that the rewarded ad failed to present.
- (void)rewardedAd:(GADRewardedAd *)rewardedAd didFailToPresentWithError:(NSError *)error {
    NSLog(@"rewardedAd:didFailToPresentWithError");
    Object *obj = ObjectDB::get_instance(instanceId);
    obj->call_deferred("_on_rewarded_video_ad_failed_to_load", (int)error.code);
}

/// Tells the delegate that the rewarded ad was dismissed.
- (void)rewardedAdDidDismiss:(GADRewardedAd *)rewardedAd {
    NSLog(@"rewardedAdDidDismiss:");
    [self loadRewardedVideo:rewardedAd.adUnitID];
    Object *obj = ObjectDB::get_instance(instanceId);
    obj->call_deferred("_on_rewarded_video_ad_dismiss");
}

@end
