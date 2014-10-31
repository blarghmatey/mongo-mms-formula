{% from "mongo-mms/map.jinja" import mongo_mms with context %}

install_mms_agent:
  pkg.installed:
    - sources:
        - mongodb-mms-automation-agent-manager: {{ mongo_mms.pkg_source }}

mongod_user:
  user.present:
    - name: mongod
    - system: True

config_group_id:
  file.replace:
    - name: /etc/mongodb-mms/automation-agent.config
    - pattern: ^.*?mmsGroupId.*?$
    - repl: mmsGroupId={{ salt['pillar.get']('mongo_mms:group_id') }}
    - append_if_not_found: True

config_api_key:
  file.replace:
    - name: /etc/mongodb-mms/automation-agent.config
    - pattern: ^.*?mmsApiKey.*?$
    - repl: mmsApiKey={{ salt['pillar.get']('mongo_mms:api_key') }}
    - append_if_not_found: True

make_data_dir:
  file.directory:
    - name: /data
    - owner: mongod

start_mms_agent:
  service.runing:
    - enable: True
    - name: mongodb-mms-automation-agent