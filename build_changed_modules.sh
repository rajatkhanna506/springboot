#!/bin/bash

# Function to get changed modules
MAJOR_VERSION=4
PATCH_VERSION=0

# update version
Updateversion(){
local module=$1

# Assuming you are in the root directory of your project
projectRoot="C:/Spring/spring/learn-spring-framework"

# Specify the source module and its version.db file
echo "Changed in module $module"
	if [ -z "$module" ]; then
		sourceFile="${projectRoot}/current-minor-version.db"
	else
		sourceFile="${projectRoot}/${module}/current-minor-version.db"
	fi
echo "source file $sourceFile"
 MINOR_VERSION=`cat $sourceFile`
  #if [[ $GIT_BRANCH == *Develop* ]]
  #then
  #  GIT_BRANCH="Develop"
	#	MINOR_VERSION="$((MINOR_VERSION + 1))"
 # else
  #  GIT_BRANCH="master"
  #fi
  MINOR_VERSION="$((MINOR_VERSION + 1))"
  CURRENT_VERSION=$MAJOR_VERSION.$MINOR_VERSION.$PATCH_VERSION
  echo "Setting up Current Version: $CURRENT_VERSION"
		# checking string is empty or not
		if [ -z "$module" ]; then
			mvn -f pom.xml versions:set -DnewVersion=$CURRENT_VERSION -DgenerateBackupPoms=false
			#sed -i "s/<version>.*<\/version>/<version>${CURRENT_VERSION}<\/version>/" pom.xml
		else
			echo "child module"
			#mvn -f ${module}/pom.xml versions:set -DnewVersion=$CURRENT_VERSION -DgenerateBackupPoms=false
			

			sed -i "s/<version>.*<\/version>/<version>${CURRENT_VERSION}<\/version>/" ${module}/pom.xml -DgenerateBackupPoms=false
			
			mvn clean install -pl ${module}
		fi
		

}

commit_db_updates(){
  echo "Minor Version $MINOR_VERSION update to GitHub $GIT_BRANCH"
  git fetch && git checkout $GIT_BRANCH
  echo $MINOR_VERSION>current-minor-version.db
  git status
  git add .
  git commit -m "Updated release version file"
  git push origin $GIT_BRANCH --force
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

#echo "files Array: ${filesArray[@]}"

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
	fi
    #echo "File: $file"
done
echo "Updated Array: ${myArray[@]}"

for item in "${myArray[@]}"; do
	if [[ "$item" == *"learncore"* ]]; then
		#mvn versions:set -DnewVersion="4.200.0" -DgroupId=your_group_id -DartifactId=your_child_module_id
		Updateversion "learncore"
	elif [[ "$item" == *"learnredis"* ]]; then
		Updateversion "learnredis"
	else
	# for parent module
		Updateversion 
	fi
done


#commit_db_updates

