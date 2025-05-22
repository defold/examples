embedded_components {
  id: "model"
  type: "model"
  data: "mesh: \"/assets/models/kenney_prototype-kit/target-a-square.glb\"\n"
  "name: \"{{NAME}}\"\n"
  "materials {\n"
  "  name: \"colormap\"\n"
  "  material: \"/assets/materials/unlit.material\"\n"
  "  textures {\n"
  "    sampler: \"texture0\"\n"
  "    texture: \"/assets/models/kenney_prototype-kit/Textures/colormap.png\"\n"
  "  }\n"
  "}\n"
  ""
  position {
    y: -0.25
  }
  rotation {
    y: 0.70710677
    w: 0.70710677
  }
}
embedded_components {
  id: "collisionobject"
  type: "collisionobject"
  data: "type: COLLISION_OBJECT_TYPE_STATIC\n"
  "mass: 0.0\n"
  "friction: 0.1\n"
  "restitution: 0.5\n"
  "group: \"target\"\n"
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
  "  data: 0.25\n"
  "  data: 0.25\n"
  "  data: 0.0625\n"
  "}\n"
  "event_collision: false\n"
  "event_contact: false\n"
  "event_trigger: false\n"
  ""
}
