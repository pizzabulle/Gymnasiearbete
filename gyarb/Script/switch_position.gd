extends Node

signal realm_changed()
signal restart()

var saved_position :=Vector2.ZERO
var normal_realm: bool = true
var level_nr : int = 0
var saved_velocity: Vector2 = Vector2(0,0)
var saved_time: float = 0.0
