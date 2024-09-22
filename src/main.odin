package main

import "core:fmt"
import rl "vendor:raylib"

res_x :: 640
res_y :: 480

main :: proc() {
	rl.InitWindow(res_x,res_y,"asdf")

	for !rl.WindowShouldClose() {
		rl.BeginDrawing()
			rl.ClearBackground(rl.RAYWHITE)
			rl.DrawText("Hello", 0, 0, 20, rl.BLACK)
		rl.EndDrawing()
	}
	rl.CloseWindow()
}