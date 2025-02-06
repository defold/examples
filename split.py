#!/usr/bin/env python

import os
import shutil
import re


def replace_in_file(filename, old, new, flags=None):
    with open(filename) as f:
        if flags is None:
            content = re.sub(old, new, f.read())
        else:
            content = re.sub(old, new, f.read(), flags=flags)

    with open(filename, "w") as f:
        f.write(content)



output_dir = "foo"
os.makedirs(output_dir, exist_ok=True)




examples_dir = "examples"

categories = os.listdir(examples_dir)

for category in categories:
	category_path = os.path.join(examples_dir, category)
	if os.path.isfile(category_path):
		continue
	if category == "_main":
		continue
	print("category", category)
	for example in os.listdir(category_path):
		print("  example", example)

		example_out_dir = os.path.join(output_dir, category + "_" + example)
		os.makedirs(example_out_dir, exist_ok=True)

		shutil.copytree("assets", os.path.join(example_out_dir, "assets"), dirs_exist_ok=True)
		shutil.copytree("input", os.path.join(example_out_dir, "input"), dirs_exist_ok=True)
		shutil.copyfile("game.project", os.path.join(example_out_dir, "game.project"))
		shutil.copyfile("all.texture_profiles", os.path.join(example_out_dir, "all.texture_profiles"))
		shutil.copyfile(".gitignore", os.path.join(example_out_dir, ".gitignore"))

		example_src = os.path.join(examples_dir, category, example)
		example_dst = os.path.join(example_out_dir, "example")
		shutil.copytree(example_src, example_dst, dirs_exist_ok=True)

		replace_in_file(os.path.join(example_out_dir, "game.project"), r"/examples/main.collectionc", r"/example/" + example + ".collectionc")

		for file in os.listdir(example_dst):
			file_path = os.path.join(example_dst, file)
			name, ext = os.path.splitext(file)
			if os.path.isdir(file_path):
				continue
			if ext in [".png", ".wav", ".ogg", ".jpg"]:
				continue
			# /examples/animation/basic_tween/
			src = r"/examples/" + category + "/" + example + "/"
			tgt = r"/example/"
			replace_in_file(file_path, src, tgt)

			if ext == ".md":
				replace_in_file(file_path, r"title", r"tags: " + category + "\ntitle")
