extends Node

@export var mob_scene: PackedScene
@export var coin_scene: PackedScene
var score

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# new_game()
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func game_over() -> void:
	$ScoreTimer.stop()
	$MobTimer.stop()
	$CoinTimer.stop()
	$HUD.show_game_over()
	$DeathSound.play()
	$Music.stop()
	
func new_game():
	# 播放音乐
	$Music.play()
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	# 将上局比赛的小怪清除
	get_tree().call_group("mobs", "queue_free")
	get_tree().call_group("coins", "queue_free")


func _on_mob_timer_timeout() -> void:
	# 创建怪物场景的实例
	var mob = mob_scene.instantiate()
	# 选择Path2D上的随机位置
	var mob_spawn_location = get_node("MobPath/MobSpawnLocation")
	mob_spawn_location.progress_ratio = randf()
	# 设置怪物的方向垂直于路径方向。
	var direction = mob_spawn_location.rotation + PI / 2
	# 设置怪物的位置在这个随机位置上
	mob.position = mob_spawn_location.position
	# 为怪物的方向添加随机性
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction
	# 随机生成怪物的速度，并且旋转
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)
	# 将怪物的实例添加进场景中
	add_child(mob)

func _on_score_timer_timeout() -> void:
	score += 1
	$HUD.update_score(score)


func _on_start_timer_timeout() -> void:
	# 开启计时器
	$MobTimer.start()
	$ScoreTimer.start()
	$CoinTimer.start()


func _on_player_collect() -> void:
	score += 5
	$HUD.update_score(score)
	# 收集完毕清除金币


func _on_coin_timer_timeout() -> void:
	# 创建怪物场景的实例
	var coin = coin_scene.instantiate()
	# 选择Path2D上的随机位置
	var coin_spawn_location = get_node("MobPath/MobSpawnLocation")
	coin_spawn_location.progress_ratio = randf()
	# 设置怪物的方向垂直于路径方向。
	var direction = coin_spawn_location.rotation + PI / 2
	# 设置怪物的位置在这个随机位置上
	coin.position = coin_spawn_location.position
	# 为怪物的方向添加随机性
	direction += randf_range(-PI / 4, PI / 4)
	coin.rotation = direction
	# 随机生成怪物的速度，并且旋转
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	coin.linear_velocity = velocity.rotated(direction)
	# 将怪物的实例添加进场景中
	add_child(coin)
