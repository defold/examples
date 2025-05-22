components {
  id: "coin"
  component: "/example/coin.script"
}
embedded_components {
  id: "model"
  type: "model"
  data: "mesh: \"/assets/models/kenney_prototype-kit/coin.glb\"\n"
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
  rotation {
    y: 0.70710677
    w: 0.70710677
  }
}
