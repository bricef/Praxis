package materials

import (
	"github.com/bricef/ray-tracer/pkg/color"
	"github.com/bricef/ray-tracer/pkg/core"
	"github.com/bricef/ray-tracer/pkg/material"
)

func Glass() core.Material {
	return material.NewMaterial().
		SetColor(color.New(0.1, 0.1, 0.1)).
		SetDiffuse(0.0).
		SetSpecular(1.0).
		SetShininess(300).
		SetTransparency(0.9).
		SetReflective(0.9).
		SetRefractiveIndex(1.5)
}

func DefaultMaterial() core.Material {
	return material.NewMaterial().
		SetColor(color.New(1, 0.9, 0.9)).
		SetSpecular(0.0).
		SetAmbient(0.7)
}

func Red() core.Material {
	return material.NewMaterial().
		SetColor(color.New(1, 0.2, 0.2)).
		SetSpecular(0.0).
		SetAmbient(0.7)
}

func Green() core.Material {
	return material.NewMaterial().
		SetColor(color.New(0.2, 1, 0.2)).
		SetSpecular(0.0).
		SetAmbient(0.7)
}

func Blue() core.Material {
	return material.NewMaterial().
		SetColor(color.New(0.2, 0.2, 1)).
		SetSpecular(0.0).
		SetAmbient(0.7)
}
