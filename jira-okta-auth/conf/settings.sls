{% set p  = salt['pillar.get']('jira_okta', {}) %}
{% set g  = salt['grains.get']('jira_okta', {}) %}




{%- set default_okta_config_jira      = '<configuration> PLEASE SETUP okta-config-jira</configuration>' %}
{%- set default_login_url             = 'https://yordomain.oktapreview.com/app/jira_onprem/PLEASE_SETUP_THAT' %}
{%- set default_logout_url            = 'https://yordomain.oktapreview.com/' %}
{%- set default_jar_dir_url               = 'https://xxx.oktapreview.com/static/toolkits/' %}
{%- set default_jar_filename               = 'okta-jira-2.0.3.jar' %}


{%- set default_jira_dir              = '/opt/jira' %}

{%- set okta_config_jira        = g.get('okta_config_jira', p.get('okta_config_jira',   default_okta_config_jira)) %}
{%- set login_url               = g.get('login_url',        p.get('login_url',          default_login_url)) %}
{%- set logout_url              = g.get('logout_url',       p.get('logout_url',         default_logout_url)) %}
{%- set jar_dir_url             = g.get('jar_dir_url',      p.get('jar_dir_url',        default_jar_dir_url)) %}
{%- set jar_filename            = g.get('jar_filename',     p.get('jar_filename',       default_jar_filename)) %}
{%- set jira_dir                = g.get('jira_dir',         p.get('jira_dir',           default_jira_dir)) %}




{%- set jira_okta = {} %}
{%- do jira_okta.update( { 
                      'okta_config_jira'        : okta_config_jira,
                      'login_url'       : login_url,
                      'logout_url'     : logout_url,
                      'jar_dir_url'       : jar_dir_url,
                      'jar_filename'	: jar_filename,
                      'jira_dir'           : jira_dir,
                  }) %}