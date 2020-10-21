module vplt

import gg
import gx
import os

const (
	win_width  = 500
	win_height = 500
)

struct Renderer {
mut:
	gg    &gg.Context
	plots  []&Plot
	width  int
	height int
	margin int = 30
}

pub fn create_renderer() &Renderer {
	mut renderer := &Renderer{
		gg: 0
		width: win_width
		height: win_height
	}
	renderer.gg = gg.new_context({
		bg_color: gx.white
		width: win_width
		height: win_height
		use_ortho: true
		create_window: true
		window_title: 'vplt'
		frame_fn: renderer_frame
		user_data: renderer
		font_path: os.resource_abs_path('./vplt/RobotoMono-Regular.ttf')
	})

	plot := new_plot(renderer, {})
	renderer.plots << plot

	renderer.gg.run()
	
	return renderer
}

fn renderer_frame(renderer &Renderer) {
	renderer.gg.begin()
	renderer.renderer_draw()
	renderer.gg.end()
}

fn (renderer &Renderer) renderer_draw() {
	for plot in renderer.plots {
		plot.draw()
	}
}