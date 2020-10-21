module vplt

import math

struct Range {
	min int
	max int
}

fn (r Range) scale() int {
	return int(r.max - r.min)
}