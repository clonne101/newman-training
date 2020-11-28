#!/bin/bash

# import libs
source "$(pwd)/libs/printer.sh";
source "$(pwd)/libs/spinner.sh";

# set global variables
REQUIRED_PACKAGES="node npm newman";

# Announce
printer "============RUNNING NEWMAN TEST============\n" "success";

# print ascii
cat newman_ascii;

# start runtime spinner
start_spinner "";

# check if required packages are installed
function check_requirements()
{

  printer "\nChecking required packages\n" "info";
  
  for i in $REQUIRED_PACKAGES
    do
      if ! which $i > /dev/null; then
        
        printer "${i^^} is missing from your system, installing now\n" "warning";
        
        if [ $i == "node" ]; then

          printer "Installing node version 14\n" "info";
          sudo apt-get install build-essential && curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash - && sudo apt-get install -y nodejs && node --version && npm --version
        
        elif [ $i == "newman" ]; then
          
          printer "Installing newman from postman, forced\n" "info";
          sudo npm install -g newman newman-reporter-csv newman-reporter-html newman-reporter-htmlextra --force
        
        fi
      fi
  done

  printer "Packages are installed, proceeding now\n" "success";

}

# clean newman reporters
function remove_newman_reporters()
{
  printer "Removing existing newman test summaries\n" "info";
  sudo rm -rf newman/*.json newman/*.csv newman/*.html
}

# Run postman newman test tool
function run_newman()
{
  printer "\nRunning newman postman tests\n" "info";

  for collection in collection/*.json;
    do
      file_store_name=$(basename -- "$collection");
      file_store_name="${file_store_name%.*}";
      
      printer "Handling collection - $collection\n" "info";
      printer "Runner command: newman run $collection --bail --insecure --ignore-redirects --verbose\n" "success";
      newman run $collection --bail --insecure --ignore-redirects --verbose --reporters cli,json,csv,htmlextra --reporter-htmlextra-export "$(pwd)/newman/$file_store_name-summary.html" --reporter-json-export "$(pwd)/newman/$file_store_name-summary.json" --reporter-csv-export "$(pwd)/newman/$file_store_name-summary.csv"
      printer "\nDone running tests for - $collection\n" "success";
  done

  printer "\nAll Done now, check your {newman} folder for your report\n";
}

# This method boots up all required methods procedurally and stops spinner
function init()
{
  check_requirements
  remove_newman_reporters
  run_newman

  stop_spinner $?
}

# initilize shell methods
init