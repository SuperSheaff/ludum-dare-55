class_name StateMachine
extends Node

# Main state machine object

signal state_changed(prev_state, new_state)

@export var _entity: Node
@export var _initial_state: State

var _states: Dictionary = {}
var _state = null
var _state_name = ""
	

func _ready():
	for state in get_children():
		state._entity = _entity
		state._fsm = self
		_states[state.name] = state
		
	if _initial_state:
		_state = _initial_state
		_state_name = _initial_state.name


func _process(delta):
	if _state:
		_state.process(delta)
	
	
func set_state(new_state: String):	
	if not _states.has(new_state):	# Invalid state
		return FAILED
		
	# Could put a check here to see if already in state to avoid spam
	
	emit_signal("state_changed", _state_name, new_state)
	
	if _state:
		_state.exit_state()
		
	_state = _states[new_state]
	_state_name = _state.name
	_state.enter_state()
	return OK
	
	
	


