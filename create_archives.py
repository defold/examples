#!/usr/bin/env python

import os
import shutil

IGNORED_DIRS = [ ".github", ".DS_store", ".git" ]
for category in os.listdir("."):
	if os.path.isfile(category) or category in IGNORED_DIRS:
		continue

	for name in os.listdir(category):
		path = os.path.join(category, name)
		if os.path.isfile(category) or category in IGNORED_DIRS:
			continue

		zip_name = category + "_" + name
		print("writing zip archive", zip_name)
		shutil.make_archive(zip_name, "zip", path)


