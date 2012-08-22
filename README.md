Description
===========
sSMTP cookbook for chef.  Installs sSMTP and sets up one or more configuration files for it.

Requirements
============
Tested on Ubuntu 12.04

Attributes
==========
* `node['ssmtp']['root_user']`          - The user that gets all mail for userids less than 1000. Disabled if blank
* `node['ssmtp']['mailhub']`            - The host to send mail to
* `node['ssmtp']['rewrite_domain']`     - The domain from which the mail seems to come, for user authentication
* `node['ssmtp']['hostname']`           - The FQDN of the host
* `node['ssmtp']['from_line_override']` - Whether or not the From: header may override the default domain
* `node['ssmtp']['use_tls']`            - Does sSMTP use TLS to talk to the mailhub?
* `node['ssmtp']['use_starttls']`       - Does sSMTP send EHLO/STARTLS before SSL negotiation?
* `node['ssmtp']['tls_cert']`           - File name of an RSA cert to user for TLS, if required
* `node['ssmtp']['auth_user']`          - User to use for SMTP Auth with mailhub, optional
* `node['ssmtp']['auth_pass']`          - Password to use for SMTP Auth
* `node['ssmtp']['auth_method']`        - Authorization method to use, one of "plain-text" or "cram-md5"

Usage
=====
Setup the default attributes, optionally setup databag items, and execute the cookbook.

If more than one ssmtp configuration is require (for multiple mail providers/accounts), create an "ssmpt" data bag, populating it with databag items containing the attributes you want merged into the defaults.  Each databag item will create an individual ssmtp configuration file placed in /etc/ssmtp/, according to the item name.

Data bag items should be of the form:

{
  "id": "ssmtp",
  "root_user": "root",
  "rewrite_domain": "example.com",
  "hostname":"mail.example.com",
  "from_line_override": true,
  "use_tls": true,
  "use_starttls": false,
  "tls_cert": "certname.pem",
  "auth_user":"username",
  "auth_pass":"password",
  "auth_method":"cram-md5",
}
