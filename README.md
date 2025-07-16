# Install a SQL web Service on IBM i

This repo contains the instructions and steps to setup an SQL web service on IBM i on-premise.

Based on the following IBM Developer tutorial series by Nadir Amra:

* [Part 1: Building a REST service with ingetrated web services server for IBM i]([https://developer.ibm.com/tutorials/i-rest-web-services-server1/)

* [Part 2: Building a REST service with ingetrated web services server for IBM i]([https://developer.ibm.com/tutorials/i-rest-web-services-server2/)

* [Part 3: Building a REST service with ingetrated web services server for IBM i]([https://developer.ibm.com/tutorials/i-rest-web-services-server3/)

* [Create REST APIs based on SQL statements](https://developer.ibm.com/tutorials/creating-rest-apis-based-on-sql-statements/])


## Architecture
![architecture](images/ibm-i-rest-api-on-prem.png)
* The IBM i - on-premise environment will host a database table with a web services server. A REST API endpoint will accept secure API request over port 443 using TLS.

---
## Provision these TechZone Environments

This lab requires IBM TechZone environments be provisioned:
1. **IBM i - on-premise**

    TechZone Environment: [IBM i PowerVM POWER9 LPAR](https://techzone.ibm.com/collection/on-premises-power-systems-aix-ibm-i-and-linux-base-images/journey-ibm-i)
    * vCPU: `2`
    * Memory: `4 GB`
    * Operating System: `[IBMi V7R5 TR]`
    * Additional Disk: `None`

2. **Systems Landing VM**

    TechZone Environment: [Systems Landing VM](https://techzone.ibm.com/collection/tx25-dev/journey-vmware-on-ibm-cloud-environments)
    * IBM Personal Communications
    * IBM Access Client Solutions
    * Microsoft Visual Studio Code
    * PuTTY, PuTTYgen
    * Web Browsers
    * Cisco AnyConnect VPN
    * OpenVPN

For the purposes of this lab, the "Systems Landing VM" environment can be substituted by any machine that has a web browser, an ssh client, and VSCode.
*** IBMers only! The Systems Landing VM is not necessary and connectivity with a device that has w3 connectivity with VPN connections should suffice. ***


## Configuring the SSH tunnel
Opening a SSH tunnel is different if you run on a [Windows](#configuring-the-ssh-tunnel-on-a-windows-machine) or [Linux/Mac OS](#configuring-the-ssh-tunnel-on-a-linuxmac-machine) machine. Choose the right method below.

### Configuring the SSH tunnel on a Windows machine
1. Install PuTTY onto your system including PuTTYgen to manipulate SSH keys.

2. Save the project SSH private key into a file on your laptop using VSCode, Notepad or Notepad++ (do not use MS Word or OpenOffice). You can name this file `private-key.txt`. The private SSH key is provided through the project kit or directly within your TechZone reservation page details. To help you identify the private key, it starts with
`-----BEGIN RSA PRIVATE KEY-----`

3. Convert the SSH key into a compatible PuTTY SSH key. Open PuTTYGen. Open menu Convertions -> Import Key and open the file `private-key.txt` you just saved.

4. Save the Putty private key using button Save Private Key and confirm that you save it WITHOUT a passphrase. You can name the file `putty-private-key.ppk`. You can then close PuTTYGen.

5. Open PuTTY and configure the IP address/Hostname. Make sure you use the public external IP address provided in your reservation . Keep port 22 and Connection type SSH.

6. Load the private key into PuTTY. Expand the left menu Connection -> SSH -> Auth and use the Browse button to load your Putty private key `putty-private-key.ppk`.

7. (Optional) Save your configuration to avoid doing all this again next time. Go back to the left menu Session, provide a name in Saved Sessions and click Save. Later on you click on your saved sessions name and use the Load button to reload your configuration.

8. Open the SSH connection using the Open button. Answer Yes to the security alert window.

9. Enter your system login. Check your reservation details. It should be cecuser. Your connection is now opened.


### Configuring the SSH tunnel on a Linux/Mac machine
1. Save the project SSH private key into a file on your laptop using the editor of your choice (avoid MS Word or OpenOffice). You can name this file `private-key.txt`. The private SSH key is provided through the project kit or directly within your TechZone reservation page details. To help you identify the private key, it starts with
`-----BEGIN RSA PRIVATE KEY-----`

2. Open a terminal and enter the following command. Replace:
* the IP address with the public External IP address provided in your reservation details
* the location of the `private-key.txt` file after the `-i` parameter
* `cecuser` if you are provided with a different account
If your local user is root you can remove `sudo`.

```shell
sudo ssh -i ~/Desktop/private-key.txt cecuser@<techzone_primary_ip_address>
```

If you kept `sudo`, the password that the command prompts you is your local user password.

---

## Install
1. Clone this repo
```shell
% git clone https://github.com/acmThinks/ibmi-rest-api
% cd ibmi-rest-api
```

## 1. Setup IBM i on-premise environment
The IBM i on-premise environment must have a database, database table (with data) and a running web services server running on a secure endpoint. In the spirit of modern developer experiences, we will use VSCode to connect to the IBM i, setup the database table, and create an SQL web service that will serve REST API requests.

### 1.1 Prepare database table
These steps are to be executed in VSCode and will create a table and populate the table with test data.
1. Download the IBM i Development Pack
    > Includes RPGLE Free, IBMi Languages, Code for IBM i, Code for IBM i Walkthroughs, RPGLE, Error Lens, TODO Hightlight, DB2 for i, etc.

2. On the dropdown list titled **SERVERS** click on the plus sign to add a new server connection
    * Enter connection name e.g IBM i Machine
    * Enter Host/IP Address (IP Address from the IBM i LPAR)
    * Enter username *e.g cecuser
    * Click on the **Select File** button to attach your attach your .pem file as a Private Key
    * Save and connect

3. Once conected, go to your **Db2 for i** VS Code extension to created a new SQL Document. Under the dropdown list titled SQL Job Manager *Open a new SQL Document*.
    a. Create database schema and tables. Open the file `sql/create.sql` in the VSCode SQL Document window, and click the *Play*  button in the upper right hand corner and select *Run all statements*.
    b. Insert records into database tables. Open the file `sql/insert.sql` in the VSCode SQL Document window, and click the *Play*  button in the upper right hand corner and select *Run all statements*.
    c. Select records to validate database. Open the file `sql/select.sql` in the VSCode SQL Document window, and click the *Play*  button in the upper right hand corner and select *Run all statements*. Output should include tabular data.

### 1.2 TODO Create the REST API
These steps will take the existing datbase tables and wrap them in a SQL web serviceto serve requests for REST API calls. The existing ssh connection will be used to execute these steps.

1. In VSCode, toggle back to your IBM i extension, and under the User Library List dropdown option, click the plus icon to add a new library list. Use the created one from your SQL command STUDENTSRC. Right click on that library and **Set as current library**

2. Under the **IFS Browser** dropdown option, you should be able to see IFS Directory `/home/CECUSER`. Right click on that and add a new directory titled `rpgcode`. In your new directory upload the RPG code from the git repo cloned on your local machine (`studentpr.rpgleinc` and `studentrsc.rpgle` files)

3. On the `studentpr.rpgle` file, right click and select **Run Action**. Select the `RPG Module` option and overwrite (copy/paste) with this command:
    ```
    CRTRPGMOD MODULE(STUDENTRSC/studentrsc) SRCSTMF('/home/CECUSER/rpgcode/studentrsc.rpgle') OPTION(*EVENTF) DBGVIEW(*SOURCE) TGTCCSID(37)
    ```
    Press **Enter**

4. On the `studentpr.rpgle` file, right click on **Run Action** again. Select the `Create Service Program` option and overwrite (copy/paste) with this command:
    ```
    CRTSRVPGM SRVPGM(STUDENTRSC/STUDENTRSC) EXPORT(*ALL)
    ```
    Press **Enter**

### 1.3 Setup the Web Services Server
This guide walks you through the steps to create a Web Services Server using the Web Administration GUI.

TODO: describe how to navigate to the "Web Administration for i"
1. Open the Wizard
    * From the left-hand menu, click on `Common Tasks and Wizard`
    * Select `Create Web Services Server`

2. Enter Server Details
    * Provide a unique name for the server:
        * **Server Name** (i.e. `APISERVER`)
        * **Server Description** (i.e. `Web services server which hosts the "students" REST API`)
    * Make sure the "Create HTTP server" checkbox is selected

3. Configure Network Settings
    * Leave all default port numbers
    * Skip to Step 4 of 5

4. Specify Server User ID
    * On Step 4 of 5, enter a user ID for the server (e.g., `cecuser`).

5. Review and Create
    * Review the summary page
    * Click **Finish** to create the server

6. Next Steps
    * Click on the Application Server tab at the top to continue with additional configuration.
Your Web Services Server is now initialized and ready for further setup.

### 1.4 Install the REST API (Student Database web service)
The next set of steps describe how to create a new web service that will provide a REST API interface to the database table.

TODO: describe how to navigate to the "Navigator for IBM i"

1. Click on the **Actions** button and select **Manage Node**.
On the menu on the left, scroll down to your Bookmarks and select **Web Administrator for i**
Click on the **Manage Deployed Services** button and select the **Deploy** button.

2. Specify the path to the ILE program or service program

    > Note: you'll need to specify it in the format NAME.LIB/LIBRARY.LIB/PROGRAM.SRVPGM
    >
    > e.g /QSYS.LIB/STUDENTRSC.LIB/STUDENTRSC.SRVPGM

    Specify a Name for Service

3. Populate the following fields:
    a. Resource Name: `students`
    b. Service Description: `Agentic AI for i`
    c. URI path template: `\`
Press Next until Step 4

4. To configure exported proceddures, set the **Usage** of each paramter exactly as shown below to ensure the web service functions correctly.

    * **UNTICK**  the box for **Detect transient fields (length and it-null fields)**
    * **UNTICK** the box for **User parameter name as element name for data structures**

    | Procedure Name	| Parameter Name	| Usage	| Data Type | Count |
    | --- | --- | --- | --- | --- |
    | REMOVE | studentID | `input` | char | |
    | | httpStatus | `output` | int | |
    | UPDATE | student | `input` | struct | |
    | | httpStatus | `output` | int | |
    |CREATE | student | `input` | struct | |
    | | httpStatus | `output` | int | |
    | | httpHeaders | `output` | char | `10`|
    | GETBYID | studentID | `input` | char | |
    | | student | `output` | struct | |
    | | httpStatus | `output` | int | |
    | | httpHeaders | `output` | char | `10`|
    | GETALL | students_LENGTH | `output` | int | |
    | | students | `output` | struct | `students_LENGTH` |
    | | httpStatus | `output` | int | |
    | | httpHeaders | `output` | char | `10` |

Be sure to tick **ALL** the checkboxes for the procedures to export as web services.
5. Click *Next* through the remaining Step 5 screens

6. For each procedure to export as a web service, set the resource method information.
    a. **REMOVE**

    | Procedure Name | REMOVE |
    | --- | ---|
    | URI path template for resource | / |
    | HTTP request method | `DELETE` |
    | URI path template for method | `{id: \w{9}}` |
    | HTTP response code output parameter | `httpStatus` |
    | HTTP header array output parameter | `*NONE` |
    | HTTP header information | `*NONE` |
    | Error response output parameter | `*NONE` |
    | Allowed input media types | `*ALL` |
    | Returned output media types | `*JSON` |
    | Identifier for input wrapper element | `removeInput` |
    | Identifier for output wrapper element | `removeResult` |

    * **TICK** the box for **Wrap output parameters**
    * **UNTICK** the box for **Wrap input parameters**

    Input parameter mappings:

    | Parameter Name | Data type | Input source | Identifier | Default Value |
    | ---| ---| ---| --- | --- |
    | studentID | char | `*PATH_PARAM` | `id` | `*NONE` |

    b. **UPDATE**

    | Procedure Name | UPDATE |
    | --- | ---|
    | URI path template for resource | / |
    | HTTP request method | `PUT` |
    | URI path template for method | `*NONE` |
    | HTTP response code output parameter | `httpStatus` |
    | HTTP header array output parameter | `*NONE` |
    | HTTP header information | `*NONE` |
    | Error response output parameter | `*NONE` |
    | Allowed input media types | `*JSON` |
    | Returned output media types | `*JSON` |
    | Identifier for input wrapper element | `updateInput` |
    | Identifier for output wrapper element | `updateResult` |

    * **TICK** the box for **Wrap output parameters**
    * **UNTICK** the box for **Wrap input parameters**

    Input parameter mappings:

    | Parameter Name | Data type | Input source | Identifier | Default Value |
    | ---| ---| ---| --- | --- |
    | student | struct | `*NONE` | | |

    c. **CREATE**

    | Procedure Name | CREATE |
    | --- | ---|
    | URI path template for resource | / |
    | HTTP request method | `POST` |
    | URI path template for method | `*NONE` |
    | HTTP response code output parameter | `httpStatus` |
    | HTTP header array output parameter | `httpHeaders` |
    | HTTP header information | `*NONE` |
    | Error response output parameter | `*NONE` |
    | Allowed input media types | `*JSON` |
    | Returned output media types | `*JSON` |
    | Identifier for input wrapper element | `createInput` |
    | Identifier for output wrapper element | `createResult` |

    * **TICK** the box for **Wrap output parameters**
    * **UNTICK** the box for **Wrap input parameters**

    Input parameter mappings:

    | Parameter Name | Data type | Input source | Identifier | Default Value |
    | ---| ---| ---| --- | --- |
    | student | struct | `*NONE` | | |

    d. **GETBYID**

    | Procedure Name | GETBYID |
    | --- | ---|
    | URI path template for resource | / |
    | HTTP request method | `GET` |
    | URI path template for method | `{id: \w{9}}` |
    | HTTP response code output parameter | `httpStatus` |
    | HTTP header array output parameter | `httpHeaders` |
    | HTTP header information | `*NONE` |
    | Error response output parameter | `*NONE` |
    | Allowed input media types | `*ALL` |
    | Returned output media types | `*JSON` |
    | Identifier for input wrapper element | `getByIDInput` |
    | Identifier for output wrapper element | `getByIDResult` |

    * **TICK** the box for **Wrap output parameters**
    * **UNTICK** the box for **Wrap input parameters**

    Input parameter mappings:

    | Parameter Name | Data type | Input source | Identifier | Default Value |
    | ---| ---| ---| --- | --- |
    | studentID | char | `*PATH_PARAM` | `id` | `*NONE` |

    e. **GETALL**

    | Procedure Name | GETALL |
    | --- | ---|
    | URI path template for resource | / |
    | HTTP request method | `GET` |
    | URI path template for method | `*NONE` |
    | HTTP response code output parameter | `httpStatus` |
    | HTTP header array output parameter | `httpHeaders` |
    | HTTP header information | `*NONE` |
    | Error response output parameter | `*NONE` |
    | Allowed input media types | `*ALL` |
    | Returned output media types | `*JSON` |
    | Identifier for input wrapper element | `getAllInput` |
    | Identifier for output wrapper element | `getAllResult` |

    * **TICK** the box for **Wrap output parameters**

7. Specify User ID for this Service
Select "Specify an existing user ID"
Enter the user ID: `cecuser` (this is the default user from the TechZone environment)
**TICK** the box **Update the server's user ID to have *USE authority to this user ID**

8. In the Library List section, select the following entry: `STUDENTRSC`

9. Click **Next** through the remaining steps until you reach the **Finish** screen.
Review the summary and confirm that all configurations are correct before clicking Finish to complete the web service export process.

### 1.5 Configure the HTTP Server
The HTTP Server must be configured to serve requests on port 443 with the TLS protocol. Configure the HTTP Server for TLS.
1. Validate HTTP Server configuration

    On the menu tab click on the **HTTP Server** option, then proceed on the hamburger menu on the left hand side of the screen. Click on **General Server Configuration**. Under the **Server IP addresses and ports to listen on** section. Click on the *Add* button and ensure that the HTTP Server accepts all requests on port 443 (the default port for TLS)

    | IP address | Port | Protocol |
    |--- | --- | --- |
    | `*` | `443` | |


### 1.6 Configure Transport Layer Security (TLS)

1. Under the **HTTP Tasks and Wizards** dropdown click on **Configure TLS**. Click **Next**.

2. Change the TLS port to `443`. Click **Next**.

3. **Specify the system certificate store password** by using the password provided in the TechZone environment for `cecuser`. Click **Next**.

4. **Specify digital certificate for server** and select the radio button **Issue a new certificate by local CA**. Click **Next**.

5. **Specify the local certificate authority password** by using the password provided in the TechZone environment for `cecuser`. Click **Next**.

6. **Restart the server immediately after the wizard**. Click **Next**.

    > Note: this will restart the HTTP Server and the Web Services Server, immediately.

7. Click **Finish**.

8. The HTTP Server and the Web Services Server will both restart. It may take a minute or two.

### 1.7 Test the HTTP Server with TLS
The Student REST API should now be operational as an endpoint.

1. (Optional) Upload a sample web page to test the HTTP Server. From the local repo `/www/APISERVER/htdocs` upload the file `index.html` to the IBM i, using the Integrated File System.

2. Using the IP address specified in the TechZone environment, test the HTTP Server. Be sure to use `https` as the protocol in your web browser.

    [https://<techzone_ip>:443/](https://<techzone_primary_ip_address>:443/)

    > You will most likely get a browser security exception explaining that the site is "not secure". This is because we configured the HTTP Server with a self-signed certificate. Since this is a learning lab, it is ok to **proceed** and accept the risk. You should see the sample web page render in your browser.

3. Test the student REST API by using the IP address specified in the TechZone environment and the web services context root. Be sure to use `https` as the protocol in your web browser.

    [https://<techzone_ip>:443/web/services/students](https://<techzone_primary_ip_address>:443/web/services/students)

    > You should see 3 student records returned in your browser window, displaye in JSON format

## 2. Configure OpenAPI
On the **Managed Deployed Services** screen click on **Download Swagger** for the new REST API service you just created.
You must convert the Swagger API document to the OpenAPI 3.0 specification for watsonx Orchestrate to use your API.

Convert Swagger 2.0 JSON —> OpenAPI 3.0 JSON
1. Download the Swagger 2.0 json from the Web Administrator for I (Save as students2_0.json). Towards the top of file, replace the URL in the "servers" section with the **primary ip address** of your TechZone environment and be sure to add the `:443` port number in the url. It should look something like this:
```json
  "host": "169.54.122.34:443",
  "schemes": [ "https" ],
  "basePath": "/web/services/students",
```

2. Convert the Swagger 2.0 json file (students.json) to  OpenAPI 3.0 yaml using [editor.swagger.io](editor.swagger.io) (save as students.yaml). Use the Edit menu to convert to OpenAPI 3. The conversion will leave you with an OpenAPI file in yaml.

3. Convert the OpenAPI 3.0 yaml file (students.yaml) to OpenAPI 3.0 json using jsonformatter.org/yaml-to-json (copy and paste into a new file, students.json)
