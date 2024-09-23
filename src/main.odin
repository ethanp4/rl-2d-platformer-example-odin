package main

import "core:fmt"
import rl "vendor:raylib"

gravity :: 400
player_jump_velocity :: 350.
player_move_velocity :: 200.

Player :: struct {
	position: rl.Vector2,
	velocity: f32,
	canJump: bool	
}

EnvItem :: struct {
	rect: rl.Rectangle,
	blocking: i32,
	color: rl.Color
}

//procedure definitions
UpdatePlayer :: proc(player: ^Player, envItems: ^[]EnvItem, delta: f32) {} //no envitems length needs to be passed in
UpdateCameraCenter :: proc(camera: ^rl.Camera2D, player: ^Player, envItems: ^EnvItem, delta: f32, width: i32, height: i32) {}
UpdateCameraCenterInsideMap :: proc(camera: ^rl.Camera2D, player: ^Player, envItems: ^EnvItem, delta: f32, width: i32, height: i32) {}
UpdateCameraCenterSmoothFollow :: proc(camera: ^rl.Camera2D, player: ^Player, envItems: ^EnvItem, delta: f32, width: i32, height: i32) {}
UpdateCameraEvenOutOnLanding :: proc(camera: ^rl.Camera2D, player: ^Player, envItems: ^EnvItem, delta: f32, width: i32, height: i32) {}
UpdateCameraPlayerBoundsPush :: proc(camera: ^rl.Camera2D, player: ^Player, envItems: ^EnvItem, delta: f32, width: i32, height: i32) {}

main :: proc() {
	screenWidth :: 800
	screenHeight :: 450
	rl.InitWindow(screenWidth, screenHeight, "raylib [core] example - 2d camera")
	player : Player = { {400, 280}, 0, false }
	envItems : []EnvItem = {
		{{ 0, 0, 1000, 400 }, 0, rl.LIGHTGRAY },
		{{ 0, 400, 1000, 200 }, 1, rl.GRAY },
		{{ 300, 200, 400, 10 }, 1, rl.GRAY },
		{{ 250, 300, 100, 10 }, 1, rl.GRAY },
		{{ 650, 300, 100, 10 }, 1, rl.GRAY }
	}
	
	camera : rl.Camera2D = { 
		offset={cast(f32)screenWidth/2., cast(f32)screenHeight/2.}, 
		target=player.position, 
		rotation=0., 
		zoom=1. 
	}

	cameraUpdaters : []proc() = {
		UpdateCameraCenter,
		UpdateCameraCenterInsideMap,
		UpdateCameraCenterSmoothFollow,
		UpdateCameraEvenOutOnLanding,
		UpdateCameraPlayerBoundsPush
	}

	UpdatePlayer(&player, &envItems, 10)

	for !rl.WindowShouldClose() {
		rl.BeginDrawing()
			rl.ClearBackground(rl.RAYWHITE)
			rl.DrawText("Hello", 0, 0, 20, rl.BLACK)
		rl.EndDrawing()
	}
	rl.CloseWindow()
}

UpdatePlayer :: proc(player: ^Player, envItems: ^[]EnvItem, delta: f32) { //no length needs to be passed in
	envItemsLength := len(envItems)
	fmt.println(envItemsLength)
}
UpdateCameraCenter :: proc() {}

UpdateCameraCenterInsideMap :: proc() {}

UpdateCameraCenterSmoothFollow :: proc() {}

UpdateCameraEvenOutOnLanding :: proc() {}

UpdateCameraPlayerBoundsPush :: proc() {}