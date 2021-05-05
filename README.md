# SSL test

Quick Nginx-based test for SSL certificates.

Dockerized version of NGinx just starts and use provided (generated) SSL certificates from LetsEncrypt to show everything is OK with SSL.

Step-by-step instruction:

### 1. Get the code
Checkout the latest code: `git clone https://github.com/divlv/ssl
`
### 2. Adjust the source
Edit `wildcard_ssl.sh` file. Change the **HOST** value to your desired domain name (**root** domain name, e.g. `example.com`, **not** `anything.example.com` !)

### 3. Get the certificate(s)
 Execute the `wildcard_ssl.sh` script. Remember, we should have 2 certificate requests: for `example.com` itdself (root domain) **and** for `*.example.com`. The interactive output may look like this:

 ```
 root@server:/opt/ssl# ./wildcard_ssl.sh
Saving debug log to /var/log/letsencrypt/letsencrypt.log
Plugins selected: Authenticator manual, Installer None
Obtaining a new certificate
Performing the following challenges:
dns-01 challenge for example.com
dns-01 challenge for example.com

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
NOTE: The IP of this machine will be publicly logged as having requested this
certificate. If you're running certbot in manual mode on a machine that is not
your server, please ensure you're okay with that.

Are you OK with your IP being logged?
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
(Y)es/(N)o: Y

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Please deploy a DNS TXT record under the name
_acme-challenge.example.com with the following value:

KGHH78FTR22khasaddasd886HJHGDFHJGHFDJM40t7F

Before continuing, verify the record is deployed.
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Press Enter to Continue

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Please deploy a DNS TXT record under the name
_acme-challenge.example.com with the following value:

DdksjuFFjssdfhhhfdk234lodlfis2hsk5d7zkB2_D0

Before continuing, verify the record is deployed.
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

!!!!!!!!!! DEPLOY THE RECORDS AND WAIT 2-3 MINUTES HERE... !!!!!!!!!!

Press Enter to Continue
Waiting for verification...
Cleaning up challenges

IMPORTANT NOTES:
 - Congratulations! Your certificate and chain have been saved at:
...
 ```

### **IMPORTANT!**

Wait at least 2-3 minutes after you add 2 TXT-records for your domain (with the same prexix):
- TXT: _acme-challenge.example.com KGHH78FTR22khasaddasd886HJHGDFHJGHFDJM40t7F **and**
- TXT: _acme-challenge.example.com DdksjuFFjssdfhhhfdk234lodlfis2hsk5d7zkB2_D0

(This is allowed by DNS server)

Especially, if you're testing stuff, remember, LetsEncrypt doesn't see the TXT updates immediately.

Make a pause in your process after creating the second TXT record by LetsEncrypt request (see the script log above).

BTW, if you're using **Terraform** with **Azure**, the following syntax will do the job:
```
resource "azurerm_dns_txt_record" "letsencryptverify" {
  name                = "_acme-challenge"
  zone_name           = azurerm_dns_zone.my_dns_zone.name
  resource_group_name = my-resource-group-name
  ttl                 = 300

  record {
    value = "M-J2d8jjksd2xza-b1jaw7TnaTaiKekyCCkhj72GGhts"
  }

  record {
    value = "kk8hdjw96--RJ3Ct95yaf6R1vFEEzkviAk2hje9hskHs"
  }
}
```


### 4. Start the web service

Execute `https` script. Sample output provided below:

```
root@server:/opt/ssl# ./https
/docker-entrypoint.sh: /docker-entrypoint.d/ is not empty, will attempt to perform configuration
/docker-entrypoint.sh: Looking for shell scripts in /docker-entrypoint.d/
/docker-entrypoint.sh: Launching /docker-entrypoint.d/10-listen-on-ipv6-by-default.sh
10-listen-on-ipv6-by-default.sh: info: Getting the checksum of /etc/nginx/conf.d/default.conf
10-listen-on-ipv6-by-default.sh: info: Enabled listen on IPv6 in /etc/nginx/conf.d/default.conf
/docker-entrypoint.sh: Launching /docker-entrypoint.d/20-envsubst-on-templates.sh
/docker-entrypoint.sh: Launching /docker-entrypoint.d/30-tune-worker-processes.sh
/docker-entrypoint.sh: Configuration complete; ready for start up
```

Just to check, e.g. your firewall of whatever, you may use `http` script - this is simple web service script for port 80 without SSL certificates.


### 5. Verify

Go to https://example.com with your browser and check the certificate is in place.

If you have any subdomain configured to the same IP-address, e.g. for this particular machine, you may go to https://subdomain.example.com and confirm the certificate is operational too.

eof