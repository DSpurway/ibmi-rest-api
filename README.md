# Install a SQL web Service on IBM i

This repo contains the instructions and steps to setup an SQL web service on IBM i on-premise.

Based on the following IBM Developer tutorial series by Nadir Amra:

* [Part 1: Building a REST service with ingetrated web services server for IBM i](https://developer.ibm.com/tutorials/i-rest-web-services-server1/)

* [Part 2: Building a REST service with ingetrated web services server for IBM i](https://developer.ibm.com/tutorials/i-rest-web-services-server2/)

* [Part 3: Building a REST service with ingetrated web services server for IBM i](https://developer.ibm.com/tutorials/i-rest-web-services-server3/)

* [Create REST APIs based on SQL statements](https://developer.ibm.com/tutorials/creating-rest-apis-based-on-sql-statements/)


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
% git clone https://github.com/acmthinks/ibmi-rest-api
% cd ibmi-rest-api
```

## 1. Setup IBM i on-premise environment
The IBM i on-premise environment must have a database, database table (with data) and a running web services server running on a secure endpoint. In the spirit of modern developer experiences, we will use VSCode to connect to the IBM i, setup the database table, and create an SQL web service that will serve REST API requests.

### 1.1 Prepare database tables
These steps are to be executed in the secure shell session (ssh). Setup scripts have been provided to expedite the creation of the schema, tables, and data loads.
1. TODO -- @David (run scripts)

### 1.2 Create a web service and REST API
These steps will take the existing datbase tables and wrap them in a SQL web service to serve requests for REST API calls. The existing ssh connection will be used to execute these steps.
1. TODO -- @David (run scripts)
2. Validate REST API via web browser

### 1.3 Configure the HTTP Server for TLS
The HTTP Server must be configured to serve requests on port 443 with the TLS protocol. Configure the HTTP Server for TLS.
1. Logon to the IBM Web Administration for i console authenticate with the `cecuser` credentials specified in the TechZone reservation: `http://<techzone_ibmi_hostname>:2001/HTTPAdmin`

2. Under the **HTTP Tasks and Wizards** dropdown click on **Configure TLS**. Click **Next**.

3. Change the TLS port to `443`. Click **Next**.

4. **Specify the system certificate store password** by using the password provided in the TechZone environment for `cecuser`. Click **Next**.

5. **Specify digital certificate for server** and select the radio button **Issue a new certificate by local CA**. Click **Next**.

6. **Specify the local certificate authority password** by using the password provided in the TechZone environment for `cecuser`. Click **Next**.

7. **Restart the server immediately after the wizard**. Click **Next**.

    > Note: this will restart the HTTP Server and the Web Services Server, immediately.

8. Click **Finish**.

9. The HTTP Server and the Web Services Server will both restart. It may take a minute or two to recycle.

### 1.4 Test the HTTP Server with TLS
The REST API should now be operational as an endpoint.

1. Using the IP address specified in the TechZone environment, test the HTTP Server. Be sure to use `https` as the protocol in your web browser.

    [https://<techzone_ibmi_ip>:443/](https://<techzone_ibmi_ip>:443/)

    > You will most likely get a browser security exception explaining that the site is "not secure". This is because we configured the HTTP Server with a self-signed certificate. Since this is a learning lab, it is ok to **proceed** and accept the risk. You should see the sample web page render in your browser.

2. Test the REST API by using the IP address specified in the TechZone environment and the web services context root. Be sure to use `https` as the protocol in your web browser.

    [https://<techzone_ibmi_ip>:443/web/services/students](https://<techzone_ibmi_ip>:443/web/services/students)

    > You should see records returned in your browser window, displayed in JSON format

### 1.5 Configure OpenAPI
The new web service has a Swagger API definition that is generated. It is useful to have the API definition of the web service in an OpenAPI format for consuming applications to call. Convert the Swagger API document to the OpenAPI 3.0 specification.

Convert Swagger 2.0 JSON —> OpenAPI 3.0 JSON
1. In the IBM Web Administration for i console, click on the Application Server tab

2. Click on the **Managed Deployed Services** buton and click on **Download Swagger** for the new REST API service just created. The browser will display a Swagger 2.0 API document in JSON format.

3. Download the Swagger 2.0 json (Save as swagger_2.0.json).

4. Convert the Swagger 2.0 json file (students.json) to  OpenAPI 3.0 yaml using [editor.swagger.io](editor.swagger.io) (save as students.yaml). Use the Edit menu to convert to OpenAPI 3. The conversion will leave you with an OpenAPI file in yaml.

5. Convert the OpenAPI 3.0 yaml file (students.yaml) to OpenAPI 3.0 json using jsonformatter.org/yaml-to-json (copy and paste into a new file, students.json)
