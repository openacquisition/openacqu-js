#!/bin/bash

# Remove any old transpiling directory
rm -rf ./johntalton

# Make a new directory and download the zipped release packages
mkdir ./johntalton
curl -L -o ./johntalton/mcp2221.zip https://github.com/johntalton/mcp2221/archive/refs/tags/v4.0.4.zip
curl -L -o ./johntalton/i2c-bus-mcp2221.zip https://github.com/johntalton/i2c-bus-mcp2221/archive/refs/tags/v4.2.1.zip/
curl -L -o ./johntalton/and-other-delights.zip https://github.com/johntalton/and-other-delights/archive/refs/tags/v8.6.6.zip

# Unzip the release packages
cd ./johntalton
unzip ./mcp2221.zip
unzip ./i2c-bus-mcp2221.zip
unzip ./and-other-delights.zip

# Transpile the mcp2221 package and move it to the I2C project
cd ./mcp2221-4.0.4
tsc
mv ./lib ../i2c-bus-mcp2221-4.2.1/mcp2221
cd ..

# Transpile the and-other-delights package and move it to the I2C project
cd ./and-other-delights-8.6.6
tsc
mv ./lib ../i2c-bus-mcp2221-4.2.1/and-other-delights
cd ..

# Set the paths to the module references in the I2C project source and transpile it
cd ./i2c-bus-mcp2221-4.2.1/src/utils
find . -type f -exec sed -i 's/@johntalton/..\/../g' {} +
cd ..
find . -type f -exec sed -i 's/@johntalton/../g' {} +
cd ..
tsc
mv ./lib ./i2c-bus-mcp2221

# Move the final JavaScript libraries down a level
mv ./mcp2221 ../mcp2221
mv ./and-other-delights ../and-other-delights
mv ./i2c-bus-mcp2221 ../i2c-bus-mcp2221

cd ..

# Clean up all the intermediary files
rm ./*.zip
rm -rf ./mcp2221-4.0.4
rm -rf ./and-other-delights-8.6.6
rm -rf ./i2c-bus-mcp2221-4.2.1

# Clean the TypeScript out of the library directories 
find . -type f -name "*.ts" -delete
find . -type f -name "*.map" -delete
find . -type f -name "*.tsbuildinfo" -delete
