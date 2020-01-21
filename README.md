Godot-Google-Admob-ios
======
This is support Godot 3.2+ (It may work with different versions but has not been tested below 3.2)
Google Admob module for [Godot Engine](https://github.com/okamstudio/godot). (Only ios)

- Banner (I'm lazy and don't apply.)
- Interstitial (I'm lazy and don't apply.)
- Rewarded Video 

이 저장소는 https://github.com/Shin-NiL/godot-admob 의 이슈 `Multiple locks on web thread not allowed` 를 해결하기 위해 Google AdMob 의 새로운 API 로 구현한 ios 전용 광고 모듈 입니다.

따라서, 최대한 Shin-NiL 저장소의 모듈과 인터페이스를 유지하도록 하였습니다. 그래도 완전히 같지는 않습니다. 이제는 여러개의 보상형 광고를 사용할 수 있기 때문에 약간의 수정이 필요합니다. 그리고 Google AdMob의 지침에 따라 새 API의 적용방식이 조금은 더 번거롭습니다.

This repository is an advertising module dedicated to iOS implemented with Google AdMob's new API to resolve the issue ‘Multiple locks on web thread not allowed’ on https://github.com/Shin-NiL/godot-admob.

Therefore, the interface with the module in the Shin-NiL repository is maintained as much as possible. But it's not exactly the same. There are now several compensatory ads available, so some modifications are required. And the application of the new API is a little more cumbersome, following Google AdMob's instructions.


How to Use
-----

- Clone or download this repository.
- Drop the "admob" directory inside the "modules" directory on the [Godot source](https://github.com/okamstudio/godot).
- [Compile the iOS export template](https://docs.godotengine.org/en/latest/development/compiling/compiling_for_ios.html).
- [Exporting to iOS](http://docs.godotengine.org/en/stable/getting_started/workflow/export/exporting_for_ios.html).

And you can change some of the settings in the xcode project to [use the new API in Google Admob](https://developers.google.com/admob/ios/quick-start?hl=en).
- Import the framework files in the "lib" folder into your Xcode project.
- Add the -ObjC linker flag to Other Linker Flags in your project's build settings
- In your app's Info.plist file, add a GADApplicationIdentifier key with a string value of your AdMob app ID.
```
<key>GADApplicationIdentifier</key>
<string>ca-app-pub-XXXXXXXXXXXXX~XXXXXXXX</string>
```

Example Code
----
The following methods are available: (Maintains the module interface of the Shin-NiL.)

```
extends Node

var admob = null
var isReal = false

const RVIDEO_1: String = "ca-app-pub-XXXXXXXXXXXXXX/XXXXXXX1"
const RVIDEO_2: String = "ca-app-pub-XXXXXXXXXXXXXX/XXXXXXX2"
const RVIDEO_3: String = "ca-app-pub-XXXXXXXXXXXXXX/XXXXXXX3"

func _ready():
	if Engine.has_singleton("AdMob") and OS.get_name() == "iOS":
		admob = Engine.get_singleton("AdMob")
		admob.init(isReal, get_instance_id())
	
	loadRewardedVideos([RVIDEO_1, RVIDEO_2, RVIDEO_3])

# Support multiple rewards.
func loadRewardedVideos(adRewardedIds: PoolStringArray):
	for rewardedId in adRewardedIds:
		loadRewardedVideo(rewardedId)

func loadRewardedVideo(adRewardedId: String):
	if admob != null:
		admob.loadRewardedVideo(adRewardedId)

func showRewardedVideo(adRewardedId: String):
	if admob != null:
		admob.showRewardedVideo(adRewardedId)

func _on_rewarded_video_ad_failed_to_load():
	print("Rewarded loaded failure")

func _on_rewarded_video_ad_loaded():
	print("Rewarded loaded success")

func _on_rewarded_video_ad_dismiss():
	print("Rewarded Dismissed.")

func _on_rewarded(currency, amount, playedRewardedID):
	print("Reward: " + currency + ", " + str(amount) + ", " + playedRewardedID)
```
