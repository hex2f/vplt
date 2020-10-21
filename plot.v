module vplt

import gg
import gx

const (
	grid_color = gx.gray
	axis_color = gx.black
)

struct Plot {
	renderer &Renderer
	x_range Range
	y_range Range
	grid_step_size f32
}

struct PlotConfig {
	x_range Range = Range{-3, 3}
	y_range Range = Range{-3, 3}
	grid_step_size f32 = 1.25
}

pub fn new_plot(renderer &Renderer, c PlotConfig) &Plot {
	p := &Plot{
		renderer: renderer,
		x_range: c.x_range,
		y_range: c.y_range,
		grid_step_size: c.grid_step_size
	}

	return p
}

pub fn (p Plot) draw() {
	x_scale := p.x_range.scale() 
	y_scale := p.y_range.scale() 
	x_step_size := (p.renderer.width - p.renderer.margin * 2) / (x_scale * p.grid_step_size)
	y_step_size := (p.renderer.height - p.renderer.margin * 2) / (y_scale * p.grid_step_size)

	x_steps := int(x_scale * p.grid_step_size)
	y_steps := int(y_scale * p.grid_step_size)

	

	for y in 0..y_steps {
		step := y / p.grid_step_size + p.y_range.min

		x1 := p.renderer.margin
		x2 := x_step_size * (x_scale + 1) + p.renderer.margin
		y1 := p.renderer.margin + y * y_step_size
		y2 := y1

		if step == 0 {
			p.renderer.gg.draw_line(x1, y1, x2, y2, axis_color)
		} else if y != 0 {
			p.renderer.gg.draw_line(x1, y1, x2, y2, grid_color)
		}

		if y != 0 {
			tw, th := p.renderer.gg.text_size('$step')
			p.renderer.gg.draw_text_def(int(x1 - 3 - tw), int(y2 - th/2 - 3), '$step')
		}
	}

	for x in 0..x_steps {
		step := x / p.grid_step_size + p.x_range.min

		x1 := p.renderer.margin + x * x_step_size
		x2 := x1
		y1 := p.renderer.margin
		y2 := y_step_size * (y_scale + 1) + p.renderer.margin

		if step == 0 {
			p.renderer.gg.draw_line(x1, y1, x2, y2, axis_color)
		} else if x != 0 {
			p.renderer.gg.draw_line(x1, y1, x2, y2, grid_color)
		}

		if x != 0 {
			tw, _ := p.renderer.gg.text_size('$step')
			p.renderer.gg.draw_text_def(int(x1 - tw/2), int(y2 + 2), '$step')
		}
	}
}