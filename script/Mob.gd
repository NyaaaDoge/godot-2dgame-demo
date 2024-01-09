extends RigidBody2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# 获取所有动画名字，以数组返回
	var mob_types = $AnimatedSprite2D.sprite_frames.get_animation_names()
	# 随机播放动画，在列表中选择一个名称(数组索引以 0 起始). randi() % n 会在 0 and n-1 之中选择一个随机整数.
	$AnimatedSprite2D.play(mob_types[randi() % mob_types.size()])
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# 当超出屏幕时调用释放函数结束生命周期
func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	queue_free()
