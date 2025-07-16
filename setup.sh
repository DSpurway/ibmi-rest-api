#set bash as the default shell, and so make running that script easy, we can run
/QOpenSys/pkgs/bin/chsh -s /QOpenSys/pkgs/bin/bash

################################
## 0. ClONE REPO
################################
#install git
/QOpenSys/pkgs/bin/yum install git

#clone the repo
# TODO: (replace with public version)
git clone https://github.ibm.com/acm-us/agentic-wxo-ibmi

################################
## 1. SETUP DATABASE
################################
#assumes
#1. VSCode is installed locally, with extension "IBM i Development Pack"
#2. Connection to TechZone Environment is established
#3. working directory is lpar-ibm/home/CECUSER

# Install database objects (using VSCode)
# TODO: run via bash?
sql/create.sql

# Insert/load data (using VSCode)
# TODO: run via bash?
sql/insert.sql

# Modify sql object authority (run on IBM i ssh term)
. sql/sqlobject.sh



################################
## 2. INSTALL SQL WEB SERVICE
################################
#assumes
#1. /home/CECUER has the "webservice-config" directory with files

# Create web service server
/QIBM/ProdData/OS/WebServices/bin/createWebServicesServer.sh -server PLCYWEBSVC -startingPort 10000 -userid cecuser

# Install the SQL web service
/QIBM/ProdData/OS/WebServices/bin/installWebService.sh -server PLCYWEBSVC -markupLanguage /home/CECUSER/webservice-config/policy.xml -propertiesFile /home/CECUSER/webservice-config/policy.properties

# Configure with TLS, disable HTTPS port
# Leave these sub-steps for students to execute in the lab (will be documented in Lab Guide)



################################
## 3. CONVERT SWAGGER TO OPENAPI
################################
# Leave these sub-steps for students to execute in the lab (will be documented in Lab Guide)

# Download Swagger to local laptop
# http://p1282-pvm4.p1282.cecc.ihost.com:2001/HTTPAdmin/SwaggerViewer?WebServiceName=policy

# Convert to OpenAPI 3.0
# Go to: https://editor.swagger.io/
# File > Clear Editor
# Copy/Paste contents of swagger json
# When prompted to convert to YAML, press "Cancel"
# Edit > Convert to OpenAPI 3.0
# Click on the "Convert" button
# Copy/Paste contents to a local file (i.e. policy-3_0.yaml)

# Convert to JSON
# Go to: https://jsonformatter.org/yaml-to-json
# Replace the LEFT panel with the contents of policy-3-0.yaml
# Click on "YAML to JSON"
# Copy/Paste contents of RIGHT panel to a local file (i.e. policy-3_0.json)
