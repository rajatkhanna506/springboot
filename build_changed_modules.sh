#!/bin/bash

# Function to get changed modules
getChangedModules() {
    local changedModules=()
    local changesetFile="changeset.txt"
    # Get the list of changed files
    git diff --name-only HEAD^ HEAD > "$changesetFile"
    # Extract module names from the changed files
    while IFS= read -r path; do
        if [[ "$path" == "module/"* ]]; then
            module=$(echo "$path" | cut -d'/' -f2)
            if [[ ! " ${changedModules[@]} " =~ " $module " ]]; then
                changedModules+=("$module")
            fi
        fi
    done < "$changesetFile"

    echo "${changedModules[@]}"
	
}

# Main script
declare -a filesArray
	echo "start checking changes"
	changedFiles=$(git diff --name-only HEAD^)
	echo $changedFiles
	rootPath=$(git rev-parse --show-toplevel)
	IFS=$'\n'
	while read -r file; do
    #completePath="${rootPath}/${file}"
	completePath="${file}"
    # Add the file to the array
    filesArray+=("${completePath}")
done <<< "$changedFiles"

# Print the array elements
for file in "${filesArray[@]}"; do
	if [[ "$file" == *"learncore"* ]]; then
		echo "learncore child module"
	elif [[ "$file" == *"learnredis"* ]]; then
		echo "learn redis child module"
	else
		echo "parent module"
	fi
    #echo "File: $file"
done
echo "now complete paths"
# Iterate through the changed files and print the complete paths
#IFS=$'\n'
#for file in $changedFiles; do
#    completePath="${rootPath}/${file}"
#    echo "Complete Path: ${completePath}"
 # Extract the root path
#    rootPathOfFile=$(dirname "${completePath}")

    # Print the result
#    echo "File: ${completePath}"
#    echo "Root Path: ${rootPathOfFile}"
#done
changedModules=($(getChangedModules))

if [ ${#changedModules[@]} -gt 0 ]; then
    for module in "${changedModules[@]}"; do
        echo "Building module: $module"
        cd "$module" || exit
        mvn clean install
        cd ..
    done
else
    echo "No changes detected. Skipping build."
fi