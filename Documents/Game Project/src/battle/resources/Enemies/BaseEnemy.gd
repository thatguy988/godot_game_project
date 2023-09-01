extends Resource

@export var name : String = "Enemy"
@export var sprite: Sprite2D = null
@export var texture: Texture = null
@export var health: int
@export var max_health: int
@export var magic_points: int
@export var max_magic_points: int
@export var attack_power: int
@export var strength : String 
@export var weakness : String 
@export var magic_attack_power: int
@export var healing_power: int
@export var alive: bool = true
@export var magic_spells: Array
