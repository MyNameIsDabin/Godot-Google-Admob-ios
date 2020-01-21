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

# upport multiple rewards.
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
