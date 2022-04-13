draw_primitive_begin_texture(pr_trianglestrip, 0);
draw_vertex_texture(0, 0, 0, 0);
draw_vertex_texture(2048, 0, 1, 0);
draw_vertex_texture(0, 2048, 0, 1);
draw_vertex_texture(2048, 2048, 1, 1);
draw_primitive_end();
/*
if mouse_wheel_up() {
	pos += 768;	
} else if mouse_wheel_down() {
	pos -= 768;
}

draw_text(32,32-(pos),str);
