#!/bin/bash

# Check if path is specified as an argument
if [ -z "$1" ]; then
  echo "Please specify the path to the folder containing the images."
  exit 1
fi

# Print the provided path
echo "Provided path: $1"

# Check if the path exists
if [ ! -d "$1" ]; then
  echo "The specified path does not exist or is not a directory."
  exit 1
fi

# Set the path to your OpenPose installation (Windows path)
OPENPOSE_ROOT="D:\\GitHub\\InstantAvatar\\openpose"
OPENPOSE_PATH="${OPENPOSE_ROOT}\\bin\\OpenPoseDemo.exe"

# Set the path to the absolute folder containing the images (WSL path)
IMAGE_FOLDER=$(realpath "$1")

# Print the absolute image folder path
echo "Absolute image folder path: $IMAGE_FOLDER"

# Convert WSL paths to Windows paths
WINDOWS_IMAGE_FOLDER=$(wslpath -w "$IMAGE_FOLDER")
WINDOWS_JSON_OUTPUT_FOLDER=$(wslpath -w "$IMAGE_FOLDER/../openpose_json")
WINDOWS_IMAGE_OUTPUT_FOLDER=$(wslpath -w "$IMAGE_FOLDER/../openpose_output")

# Print the converted Windows paths
echo "Windows image folder path: $WINDOWS_IMAGE_FOLDER"
echo "Windows JSON output folder path: $WINDOWS_JSON_OUTPUT_FOLDER"
echo "Windows image output folder path: $WINDOWS_IMAGE_OUTPUT_FOLDER"

# Create output directories if they do not exist
mkdir -p "$IMAGE_FOLDER/../openpose_json"
mkdir -p "$IMAGE_FOLDER/../openpose_output"

# Change to OpenPose root directory
cd /mnt/d/GitHub/InstantAvatar/openpose || exit

# Run OpenPose Windows executable from WSL
cmd.exe /c "$OPENPOSE_PATH --image_dir $WINDOWS_IMAGE_FOLDER --display 0 --write_json $WINDOWS_JSON_OUTPUT_FOLDER --write_images $WINDOWS_IMAGE_OUTPUT_FOLDER --write_images_format jpg --render_pose 1 --render_threshold 0.5 --number_people_max 1 --model_pose BODY_25"

# Change back to the original directory
cd - || exit

# Run the Python script to convert JSON to NPY (assuming the script is compatible with WSL)
python ./scripts/custom/convert_openpose_json_to_npy.py --json_dir "$IMAGE_FOLDER/../openpose_json/"