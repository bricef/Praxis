package main

import (
	m "math"

	"github.com/bricef/ray-tracer/pkg/camera"
	"github.com/bricef/ray-tracer/pkg/color"
	"github.com/bricef/ray-tracer/pkg/entities"
	"github.com/bricef/ray-tracer/pkg/lighting"
	"github.com/bricef/ray-tracer/pkg/materials"
	"github.com/bricef/ray-tracer/pkg/math"
	"github.com/bricef/ray-tracer/pkg/scene"
	"github.com/bricef/ray-tracer/pkg/utils"
)

func main() {

	width, height := 1000, 500

	s := scene.NewScene()

	s.Add(
		lighting.NewPointLight(color.White).Translate(-5, 5, 2),
	)

	// s.Add(
	// 	entities.NewCube().
	// 		AddComponent(materials.Red()).
	// 		Translate(-3, 0, 0).
	// 		Scale(0.5, 0.5, 0.5),
	// 	entities.NewCube().
	// 		AddComponent(materials.Green()).
	// 		Translate(0, 0, 0).
	// 		RotateX(-m.Pi/6),
	// 	entities.NewCube().
	// 		AddComponent(materials.Blue()).
	// 		Translate(3, 0, 0).
	// 		RotateX(-m.Pi/6),
	// )

	s.Add(
		entities.NewTruncatedCylinder().
			AddComponent(materials.Red()).
			Translate(-3, 0, 0).
			Scale(0.5, 0.5, 0.5),
		entities.NewCappedCylinder().
			AddComponent(materials.Green()).
			// Translate(0, 0, 0).
			Scale(0.5, 0.5, 0.5),
		// RotateX(-m.Pi/6),
		entities.NewCappedCylinder().
			AddComponent(materials.Blue()).
			Translate(3, 0, 0).
			RotateX(-m.Pi/6),
	)

	c := camera.
		CameraFromFOV(width, height, utils.DegressToRadians(70)).
		SetTransform(
			math.ViewTransform(
				math.NewPoint(0, 5, -5),
				math.NewPoint(0, 0, 0),
				math.NewVector(0, 1, 0)),
		)
	s.Show()

	c.SaveFrame(s, "output/chapter13.png")
}
