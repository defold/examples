components {
  id: "trail"
  component: "/particlefx/trail.particlefx"
  position {
    x: 90.0
    z: -0.1
  }
}
components {
  id: "play"
  component: "/particlefx/play.script"
}
embedded_components {
  id: "sprite"
  type: "sprite"
  data: "default_animation: \"pixel_blue\"\n"
  "material: \"/builtins/materials/sprite.material\"\n"
  "size {\n"
  "  x: 200.0\n"
  "  y: 40.0\n"
  "}\n"
  "size_mode: SIZE_MODE_MANUAL\n"
  "textures {\n"
  "  sampler: \"texture_sampler\"\n"
  "  texture: \"/textures/textures.atlas\"\n"
  "}\n"
  ""
}
embedded_components {
  id: "collisionobject"
  type: "collisionobject"
  data: "type: COLLISION_OBJECT_TYPE_DYNAMIC\n"
  "mass: 3.0\n"
  "friction: 0.4\n"
  "restitution: 0.0\n"
  "group: \"default\"\n"
  "mask: \"default\"\n"
  "embedded_collision_shape {\n"
  "  shapes {\n"
  "    shape_type: TYPE_BOX\n"
  "    position {\n"
  "    }\n"
  "    rotation {\n"
  "    }\n"
  "    index: 0\n"
  "    count: 3\n"
  "  }\n"
  "  data: 100.0\n"
  "  data: 20.0\n"
  "  data: 10.0\n"
  "}\n"
  "linear_damping: 0.05\n"
  "angular_damping: 0.2\n"
  ""
}
