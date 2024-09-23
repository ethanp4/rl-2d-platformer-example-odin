package main

import "core:fmt"
import rl "vendor:raylib"

gravity :: 981
player_jump_velocity :: 500.
player_move_velocity :: 200.

Player :: struct {
	position: rl.Vector2,
	velocity: f32,
	canJump: bool	
}

EnvItem :: struct {
	rect: rl.Rectangle,
	blocking: bool, // originally "int", probably to represent layers?
	color: rl.Color
}

main :: proc() {
	using rl //using statement cant be in file scope 
	screenWidth :: 800
	screenHeight :: 450
	InitWindow(screenWidth, screenHeight, "raylib [core] example - 2d camera")
	player : Player = { {400, 280}, 0, false }
	envItems : []EnvItem = {
		{ { 0, 0, 1000, 400 }, false, LIGHTGRAY },
		{ { 0, 400, 1000, 200 }, true, GRAY },
		{ { 300, 200, 400, 10 }, true, GRAY },
		{ { 250, 300, 100, 10 }, true, GRAY },
		{ { 650, 300, 100, 10 }, true, GRAY }
	}
	
	camera : Camera2D = { 
		offset={cast(f32)screenWidth/2., cast(f32)screenHeight/2.}, 
		target=player.position, 
		rotation=0.0, 
		zoom=1.0
	}

	// the type is literally []proc(camera: ^Camera2D, player: ^Player, envItems: ^EnvItem, delta: f32, width: f32, height: f32)
	cameraUpdaters : []proc(camera: ^Camera2D, player: ^Player, envItems: ^[]EnvItem, delta: f32, screenWidth: f32, screenHeight: f32) = {
		UpdateCameraCenter,
		UpdateCameraCenterInsideMap,
		UpdateCameraCenterSmoothFollow,
		UpdateCameraEvenOutOnLanding,
		UpdateCameraPlayerBoundsPush
	}

	cameraOption := 0;

	cameraDescriptions : []cstring = {
		"Follow player center",
		"Follow player center, but clamp to map edges",
		"Follow player center; smoothed",
		"Follow player center horizontally; update player center vertically after landing",
		"Player push camera on getting too close to screen edge"
	}

	SetTargetFPS(60)

	for !WindowShouldClose() {
		deltaTime := GetFrameTime()

		UpdatePlayer(&player, &envItems, deltaTime)

		camera.zoom += GetMouseWheelMove()*0.05
		camera.zoom = Clamp(camera.zoom, 0.25, 3.0)

		if IsKeyPressed(.R) {
			camera.zoom = 1.0
			player.position = { 400, 280 }
		}

		if IsKeyPressed(.C) { cameraOption = (cameraOption + 1)&len(cameraUpdaters) }

		cameraUpdaters[cameraOption](&camera, &player, &envItems, deltaTime, screenWidth, screenHeight)

		BeginDrawing()
			ClearBackground(LIGHTGRAY)

			BeginMode2D(camera)
				for ei in envItems { DrawRectangleRec(ei.rect, ei.color) }

				playerRect: Rectangle = {player.position.x - 20, player.position.y - 40, 40, 40}
				DrawRectangleRec(playerRect, RED)

				DrawCircleV(player.position, 5, GOLD)
			EndMode2D()

			DrawText("Controls:", 20, 20, 10, BLACK);
			DrawText("- Right/Left to move", 40, 40, 10, DARKGRAY);
			DrawText("- Space to jump", 40, 60, 10, DARKGRAY);
			DrawText("- Mouse Wheel to Zoom in-out, R to reset zoom", 40, 80, 10, DARKGRAY);
			DrawText("- C to change camera mode", 40, 100, 10, DARKGRAY);
			DrawText("Current camera mode:", 20, 120, 10, BLACK);
			DrawText(cameraDescriptions[cameraOption], 40, 140, 10, DARKGRAY);

		EndDrawing()

	}
	CloseWindow()
}

isColliding :: proc(ei : EnvItem, player: ^Player, delta: f32) -> bool {
	using ei
	res := ei.blocking && 
		rect.x <= player.position.x &&	
		rect.x + rect.width >= player.position.x && 
		rect.y >= player.position.y && 
		rect.y <= player.position.y + player.velocity*delta
	return res
}

//procedure definitions
UpdatePlayer :: proc(player: ^Player, envItems: ^[]EnvItem, delta: f32) {//no envitems length needs to be passed in
	using rl
	if IsKeyDown(KeyboardKey.LEFT) { player.position.x -= player_move_velocity*delta}
	if IsKeyDown(KeyboardKey.RIGHT) { player.position.x += player_move_velocity*delta }
	if IsKeyDown(KeyboardKey.SPACE) && player.canJump {
		player.velocity = -player_jump_velocity
		player.canJump = false
	}

	hitObstacle := false
	for ei in envItems { // check collision of envItems
		if (isColliding(ei, player, delta)) {
			hitObstacle = true
			player.velocity = 0.0
			player.position.y = ei.rect.y //send player to top of rect
			break //dont need to keep checking for collision
		}
	}

	if !hitObstacle {
		player.position.y += player.velocity*delta
		player.velocity += gravity*delta
		player.canJump = false
	} else {
		player.canJump = true
	}
}

UpdateCameraCenter :: proc(camera: ^rl.Camera2D, player: ^Player, envItems: ^[]EnvItem, delta: f32, screenWidth: f32, screenHeight: f32) {
	camera.offset = { screenWidth/2, screenHeight/2 }
	camera.target = player.position
}
UpdateCameraCenterInsideMap :: proc(camera: ^rl.Camera2D, player: ^Player, envItems: ^[]EnvItem, delta: f32, screenWidth: f32, screenHeight: f32) {

}
UpdateCameraCenterSmoothFollow :: proc(camera: ^rl.Camera2D, player: ^Player, envItems: ^[]EnvItem, delta: f32, screenWidth: f32, screenHeight: f32) {

}
UpdateCameraEvenOutOnLanding :: proc(camera: ^rl.Camera2D, player: ^Player, envItems: ^[]EnvItem, delta: f32, screenWidth: f32, screenHeight: f32) {

}
UpdateCameraPlayerBoundsPush :: proc(camera: ^rl.Camera2D, player: ^Player, envItems: ^[]EnvItem, delta: f32, screenWidth: f32, screenHeight: f32) {

}
