embedded_components {
  id: "sprite"
  type: "sprite"
  data: "default_animation: \"triangle_white\"\n"
  "material: \"/builtins/materials/sprite.material\"\n"
  "textures {\n"
  "  sampler: \"texture_sampler\"\n"
  "  texture: \"/assets/images/textures.atlas\"\n"
  "}\n"
  ""
}
embedded_components {
  id: "collisionobject"
  type: "collisionobject"
  data: "collision_shape: \"/assets/shapes/triangle_target.convexshape\"\n"
  "type: COLLISION_OBJECT_TYPE_STATIC\n"
  "mass: 0.0\n"
  "friction: 0.1\n"
  "restitution: 0.0\n"
  "group: \"target\"\n"
  "mask: \"target\"\n"
  ""
}
