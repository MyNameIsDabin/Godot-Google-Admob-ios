#import "app_delegate.h"
#import <GoogleMobileAds/GADRewardedAdDelegate.h>
#import <GoogleMobileAds/GADRewardedAd.h>

#define REWARDED_TEST_ID (@"ca-app-pub-3940256099942544/1712485313")

@interface AdmobRewarded: NSObject <GADRewardedAdDelegate> {
    NSMutableDictionary *rewardedIds;
    NSString *playedID;
    bool isReal;
    int instanceId;
    ViewController *rootController;
}

- (void)initialize:(BOOL)is_real: (int)instance_id;
- (GADRewardedAd *)createAndLoadRewardedAdForAdUnit:(NSString *) adUnitId;
- (void)loadRewardedVideo:(NSString*)rewardedId;
- (void)showRewardedVideo:(NSString*)rewardedId;

@end
