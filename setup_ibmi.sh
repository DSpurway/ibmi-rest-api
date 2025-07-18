#!/bin/bash

echo "Testing if git is installed..."
/QOpenSys/pkgs/bin/git --version &> /dev/null
return_code=$?
echo "Return code recieved:" $return_code
if [ $return_code = 0 ]; then
        echo "git installed already"
else
        echo "Need to install git..."
        /QOpenSys/pkgs/bin/yum -q install git
fi

echo "Checking for pre-cloned repo..."
ls -al ~/ibmi-rest-api &> /dev/null
return_code=$?
echo "Return code recieved:" $return_code
if [ $return_code = 0 ]; then
        echo "~/ibmi-rest-api exists already, so repo probably already cloned."
else
        echo "~/ibmi-rest-api does not yet exist, so cloning repo..."
        /QOpenSys/pkgs/bin/git clone https://github.com/acmthinks/ibmi-rest-api
fi

home_dir=$HOME
#sql_conf_dir="$home_dir"/ibmi-rest-api/sql

#echo "Starting off by creating a schema and tables using the file" "$sql_conf_dir"/create.sql
#system "RUNSQLSTM SRCSTMF('"$sql_conf_dir"/create.sql')"

echo "Reading CSV dataset enhanced_health_insurance_claims.csv..."
SQL_TABLE_DETAILS="$(/QOpenSys/pkgs/bin/python CSV2DB2_create_table.py)"
echo "Gathered these details from dataset to build table in Db2 for i:" $SQL_TABLE_DETAILS
echo "Creating schema and table from that detail..."
SQL_BUILD_STRING=$'CREATE SCHEMA CLAIMS;\n\nCREATE TABLE CLAIMS/HEALTH/n(/n'
SQL_BUILD_STRING+=$SQL_TABLE_DETAILS
SQL_BUILD_STRING+=$'  PRIMARY KEY (ClaimID)\n)\nRCDFMT policyr;'
system "RUNSQLSTM SRCSTMF('"$SQL_BUILD_STRING"')"

#echo "Inserting data using the file" "$sql_conf_dir"/insert.sql
#system "RUNSQLSTM SRCSTMF('"$sql_conf_dir"/insert.sql')"

#echo "Changing object authority of web service files"
#. "$sql_conf_dir"/sqlobject.sh

# create web service server
#echo "Creating web service..."
#/QIBM/ProdData/OS/WebServices/bin/createWebServicesServer.sh -server PLCYWEBSVC -startingPort 10000 -userid cecuser

# Install the SQL web service
#echo "Installing SQL web service..."
#web_conf_dir="$home_dir"/ibmi-rest-api/webservice-config
#echo "Using this Markup Language file:" "$web_conf_dir"/policy.xml
#echo "and this Properties file:" "$web_conf_dir"/policy.properties

#/QIBM/ProdData/OS/WebServices/bin/installWebService.sh -server PLCYWEBSVC -markupLanguage "$web_conf_dir"/policy.xml -propertiesFile "$web_conf_dir"/policy.properties

# Configure with TLS, disable HTTPS port
#echo "Now need to configure TLS and disable HTTPS port. Work to be done..."
