shader_type canvas_item;

uniform vec3 tint_color = vec3(1.0, 0.0, 0.0);

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);

    if (tex_color.a < 0.01) {
        COLOR = tex_color;
    }

    // Multiplicamos el color original por el tinte (estilo Photoshop Multiply)
    vec3 multiplied = tex_color.rgb * tint_color;

    COLOR = vec4(multiplied, tex_color.a);
}
