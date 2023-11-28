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


isParentModule() {
mvn -f ${MODULE_NAME}/pom.xml versions:set -DnewVersion=${NEW_VERSION}

    if grep -q '<packaging>pom</packaging>' pom.xml; then
		echo "parent moudle deployment"
        return 0 # true
		
    else
		echo "NOT a parent moudle deployment"
        return 1 # false
    fi
	# old code but remove deprocess but have to update child version as well
}

# Function to add data to the array if not present
addToMyArray() {
    local data=$1
    # Check if the data is not already in the array
    if [[ ! " ${myArray[@]} " =~ " $data " ]]; then
        myArray+=("$data")
        echo "Added '$data' to the array."
    else
        echo "'$data' is already in the array. Not added."
    fi
}

# Main script
declare -a filesArray
declare -a myArray
	echo "start checking changes"
	changedFiles=$(git diff --name-only HEAD^)
	#echo $changedFiles
	#rootPath=$(git rev-parse --show-toplevel)
	IFS=$'\n'
	while read -r file; do
    #completePath="${rootPath}/${file}"
	completePath="${file}"
    # Add the file to the array
    filesArray+=("${completePath}")
done <<< "$changedFiles"

echo "files Array: ${filesArray[@]}"

# Print the array elements
for file in "${filesArray[@]}"; do
	if [[ "$file" == *"learncore"* ]]; then
		echo "learn core child module"
		addToMyArray "learncore"
	elif [[ "$file" == *"learnredis"* ]]; then
		echo "learn redis child module"
		addToMyArray "learnredis"
	else
		echo "parent module"
		addToMyArray "parentmodule"
		#isParentModule
	fi
    #echo "File: $file"
done
echo "now complete paths"
echo "Updated Array: ${myArray[@]}"

for item in "${myArray[@]}"; do
	if [[ "$item" == *"learnredis"* ]]; then
		#mvn versions:set -DnewVersion="4.200.0" -DgroupId=your_group_id -DartifactId=your_child_module_id
		mvn -f ${item}/pom.xml versions:set -DnewVersion="4.200.0"
	fi
done

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