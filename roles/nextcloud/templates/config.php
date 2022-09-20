<?php
$CONFIG = array (
  'instanceid' => '{{ nextcloud.instanceid }}',
  'passwordsalt' => '{{ nextcloud.passwordsalt }}',
  'secret' => '{{ nextcloud.secret }}',
  'trusted_domains' => 
  array (
    0 => 'nextcloud.meallier.fr',
  ),
  'datadirectory' => '/opt/nextcloud/data',
  'dbtype' => 'pgsql',
  'version' => '24.0.0',
  'overwrite.cli.url' => 'https://nextcloud.meallier.fr',
  'dbname' => '{{postgresql.nextcloud.database}}',
  'dbhost' => 'localhost',
  'dbport' => '',
  'dbtableprefix' => 'oc_',
  'dbuser' => '{{postgresql.nextcloud.username}}',
  'dbpassword' => '{{postgresql.nextcloud.password}}',
  'installed' => true,
);