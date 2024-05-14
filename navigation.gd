extends CharacterBody2D

@export var nav_agent: NavigationAgent2D
@export var speed: float
@export var nav_region: NavigationRegion2D

func _ready():
    # call_deferred ensures that we wait until the
    # navigation server is ready before trying to
    # get a path to the target
    call_deferred("set_target")

func set_target():
    nav_agent.set_target_position(Vector2(100, 100))

func _process(_delta):
    if Input.is_action_just_pressed("bake_working"):
        bake_working()
    elif Input.is_action_just_pressed("bake_broken"):
        bake_broken()

func bake_working():
    var main_outline = nav_region.navigation_polygon.get_outline(0)
    nav_region.navigation_polygon.clear_outlines()
    nav_region.navigation_polygon.add_outline(main_outline)
    nav_region.bake_navigation_polygon()

func bake_broken():
    var nav_data = NavigationMeshSourceGeometryData2D.new()
    NavigationServer2D.parse_source_geometry_data(nav_region.navigation_polygon, nav_data, nav_region)
    NavigationServer2D.bake_from_source_geometry_data_async(nav_region.navigation_polygon, nav_data, _post_baking)

func _physics_process(_delta):
    if nav_agent.is_navigation_finished():
        return

    var next_path_position: Vector2 = nav_agent.get_next_path_position()
    var new_velocity: Vector2 = global_position.direction_to(next_path_position) * speed
    velocity = new_velocity
    move_and_slide()

func _post_baking():
    nav_region.queue_redraw()


func _on_path_changed():
    pass # Replace with function body.

func _on_navigation_finished():
    print('finshed')
