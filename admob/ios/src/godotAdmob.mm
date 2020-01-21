#include "godotAdmob.h"
#import "app_delegate.h"

#if VERSION_MAJOR == 3
#define CLASS_DB ClassDB
#else
#define CLASS_DB ObjectTypeDB
#endif

GodotAdmob::GodotAdmob() {
}

GodotAdmob::~GodotAdmob() {
}

void GodotAdmob::init(bool isReal, int instanceId) {
    rewarded = [AdmobRewarded alloc];
    [rewarded initialize:isReal :instanceId];
}

void GodotAdmob::loadRewardedVideo(const String &rewardedId) {
    NSString *idStr = [NSString stringWithCString:rewardedId.utf8().get_data() encoding: NSUTF8StringEncoding];
    [rewarded loadRewardedVideo:idStr];
}

void GodotAdmob::showRewardedVideo(const String &rewardedId) {
    NSString *idStr = [NSString stringWithCString:rewardedId.utf8().get_data() encoding: NSUTF8StringEncoding];
    [rewarded showRewardedVideo:idStr];
}

void GodotAdmob::_bind_methods() {
    CLASS_DB::bind_method("init",&GodotAdmob::init);
    CLASS_DB::bind_method("loadRewardedVideo",&GodotAdmob::loadRewardedVideo);
    CLASS_DB::bind_method("showRewardedVideo",&GodotAdmob::showRewardedVideo);
}
