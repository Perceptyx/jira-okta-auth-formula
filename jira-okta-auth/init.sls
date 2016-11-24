{%- from 'jira-okta-auth/conf/settings.sls' import jira_okta with context %}



okta-config-jira:
  file.managed:
    - name: {{ jira_okta.jira_dir }}/conf/okta-config-jira.xml
    - makedirs: True
    - contents: {{ jira_okta.okta_config_jira }}
    - listen_in:
      -  module: okta-jira-restart 

okta-authenticator-replace:
    file.replace:
     - name: {{ jira_okta.jira_dir }}/atlassian-jira/WEB-INF/classes/seraph-config.xml
     - pattern: '<authenticator class="com.atlassian.jira.security.login.JiraSeraphAuthenticator"/>\n'
     - repl: |
          <authenticator class="com.atlassian.jira.authenticator.okta.OktaJiraAuthenticator"> <init-param> <param-name>okta.config.file</param-name> <param-value>/path/to/your/okta-config-jira.xml</param-value> </init-param> </authenticator>
     - listen_in:
       -  module: okta-jira-restart 

okta-authenticator-replace-2:
    file.replace:
     - name: {{ jira_okta.jira_dir }}/atlassian-jira/WEB-INF/classes/seraph-config.xml
     - pattern: '<authenticator [^\n]*</authenticator>\n'
     - repl: |
          <authenticator class="com.atlassian.jira.authenticator.okta.OktaJiraAuthenticator"> <init-param> <param-name>okta.config.file</param-name> <param-value>{{ jira_okta.jira_dir }}/conf/okta-config-jira.xml</param-value> </init-param> </authenticator>
     - listen_in:
       -  module: okta-jira-restart 

okta-login_url-replace:
  file.replace:
    - name: {{ jira_okta.jira_dir }}/atlassian-jira/WEB-INF/classes/seraph-config.xml
    - pattern:  '<param-name>login.url<\/param-name>([^\n]*\n[^<]*)<param-value>[^<]*<\/param-value>'
    - repl: '<param-name>login.url</param-name>\1<param-value>{{ jira_okta.login_url }}</param-value>'
    - listen_in:
      -  module: okta-jira-restart 

okta-link_login_url-replace:
  file.replace:
    - name: {{ jira_okta.jira_dir }}/atlassian-jira/WEB-INF/classes/seraph-config.xml
    - pattern:  '<param-name>link.login.url<\/param-name>([^\n]*\n[^<]*)<param-value>[^<]*<\/param-value>'
    - repl: '<param-name>link.login.url</param-name>\1<param-value>{{ jira_okta.login_url }}</param-value>'
    - listen_in:
      -  module: okta-jira-restart 

okta-logout_url-replace:
  file.replace:
    - name: {{ jira_okta.jira_dir }}/atlassian-jira/WEB-INF/classes/seraph-config.xml
    - pattern:  '<param-name>logout.url<\/param-name>([^\n]*\n[^<]*)<param-value>[^<]*<\/param-value>'
    - repl: '<param-name>logout.url</param-name>\1<param-value>{{ jira_okta.logout_url }}</param-value>'
    - listen_in:
      -  module: okta-jira-restart 

{% if not salt['file.directory_exists' ]('{{ jira_okta.jira_dir }}/atlassian-jira/WEB-INF/lib/{{ jira_okta.jar_filename }}') %}
okta-jar-copy:
  file.managed:
    - name: {{ jira_okta.jira_dir }}/atlassian-jira/WEB-INF/lib/{{ jira_okta.jar_filename }}
    - source: {{ jira_okta.jar_dir_url }}{{ jira_okta.jar_filename}}
    - skip_verify: true
    - user: jira
    - require:
      - module: okta-jira-stop
    - listen_in:
      -  module: okta-jira-restart   
{% endif %}

okta-jira-restart:
  module.wait:
    - name: service.restart
    - m_name: jira

okta-jira-stop:
  module.wait:
    - name: service.stop
    - m_name: jira  






