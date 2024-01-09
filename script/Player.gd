extends Area2D

# 声明变量
@export var speed = 400
var screen_size
signal hit
signal collect

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# 游戏开始时候隐藏玩家
	hide()
	# 查看游戏窗口大小
	screen_size = get_viewport_rect().size


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var velocity = Vector2.ZERO
	# 检查输入
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	# 设定移动方向
	if velocity.length() > 0:
		# 移动中播放动画
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
	# 沿着给定方向移动
	position += velocity * delta
	# 限制不许移动到屏幕边界外，即player的位置必须在0,0和屏幕大小个区间内
	position = position.clamp(Vector2.ZERO, screen_size)
	
	# 让玩家的动画更加适配，比如行走的动画进行翻转
	if velocity.x != 0:
		# 如果x方向上有移动，设置动画为walk
		$AnimatedSprite2D.animation = "walk"
		# 不进行垂直翻转
		$AnimatedSprite2D.flip_v = false
		# 如果x速度小于0，水平翻转
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "up"
		# y速度大于0，垂直翻转
		$AnimatedSprite2D.flip_v = velocity.y > 0
	

# 当其他物体接触玩家
func _on_body_entered(body: Node2D) -> void:
	var body_groups = body.get_groups()
	for group in body_groups:
		if group.begins_with("mob"):
			# 玩家受击后消失
			hide()
			# 发送受击事件
			hit.emit()
			# 为这个节点设置延迟。必须延迟，因为我们不能在一次物理调用中改变物理属性
			# 如果在引擎的碰撞处理过程中禁用区域的碰撞形状可能会导致错误。使用 set_deferred() 告诉 Godot 等待可以安全地禁用形状时再这样做
			$CollisionShape2D.set_deferred("disabled", true)
		elif group.begins_with("coin"):
			#print("coins body", body)
			collect.emit()
			# 收集到金币释放金币
			body.free()


func start(pos):
	# 用于在游戏开始时重置玩家位置
	position = pos
	show()
	$CollisionShape2D.disabled = false
