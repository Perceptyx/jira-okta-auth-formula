Jira Okta Auth
==================

Formula for installikg okta auth for jira/jira servicedesk.
This is working with [Jira servicedesk formula](https://github.com/marek-knappe/jira-servicedesk-formula) but could work with any deployment.
The only prerequirments would be working 
``` service jira (status|start|stop|restart) ```


See the full [Salt Formulas installation and usage instructions](http://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html)

Unfortunatelly this formula cannot be assigned to vanilla instalation of jira, so don't put it in your highstate. You need first install and configure your jira (add admin user/enter name of jira system) and then you can add okta auth and use admin credentials for user provisioning.

What I'm doing is putting my jira-service-desk-formula into highstate, installing it, and then run:

```salt 'role:jira' state.apply jira-okta-auth```

Also if you want after configuring your jira you can add it to highstate (will work every time after jira is configured). Also it need to be run when your jira is upgraded (it's putting .xml and jar into /data/jira dir which is erased while upgrading jira)

## Available states
- [jira-okta-auth](#jira)


### jira-okta-auth
Installing okta auth for jira



Configuration
=============

## Jira required settings

### jira_okta:okta_config_jira
Your XML <configuration> from OKTA site

### jira_okta:login_url
login.url and link.login.url from OKTA site
example: https://company.okta.com/app/jira_onprem/code/sso/saml?RelayState=${originalurl}

### jira_okta:logout_url
logout.url from OKTA site
example: https://company.okta.com

### jira_okta:jar_dir_url
Jira JAR dir url.
example: https://company-admin.okta.com/static/toolkits/


### jira_okta:jar_filename
Filename of jar plugin
example: okta-jira-2.0.3.jar
    !Remember that jira_dir_url + jira_filename should give you proper url of JAR file
    
### jira_okta:jira_dir
Dir where u have your jira installed
example: /opt/jira