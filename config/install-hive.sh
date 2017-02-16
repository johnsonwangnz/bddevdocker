#!/bin/bash

echo "Creating the metastore"
echo "Go to $HIVE_HOME first as the place to run schematool is important, decising where the metadata_db folder is created"

#Initialize Derby database
cd $HIVE_HOME

echo "Run schemal tool: "
bin/schematool -initSchema -dbType derby

echo -e "Meta store created.\n"

