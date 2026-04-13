extends Node

signal realm_changed()
signal restart()
# All sparad info under spelets gångs
var saved_position :=Vector2.ZERO
var normal_realm: bool = true
var level_nr : int = 0
var saved_velocity: Vector2 = Vector2(0,0)
var saved_time: float = 0.0
var start_pos :=Vector2.ZERO
