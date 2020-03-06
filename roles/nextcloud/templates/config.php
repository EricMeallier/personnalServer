<?php
$CONFIG = array (
  'instanceid' => 'oc0xrmtxnmop',
  'passwordsalt' => 'XV94wQglyUSGZdNRxdgSRGrqt7zsj9',
  'secret' => 'QuBmfni3gRxejJmT28GlzsDmXAX+E4w2jITaMLSfq9Lm3gZT',
  'trusted_domains' => 
  array (
    0 => 'nextcloud.meallier.fr',
  ),
  'datadirectory' => '/opt/nextcloud/data',
  'dbtype' => 'pgsql',
  'version' => '18.0.1.3',
  'overwrite.cli.url' => 'https://nextcloud.meallier.fr',
  'dbname' => '{{postgresql.nextcloud.database}}',
  'dbhost' => 'localhost',
  'dbport' => '',
  'dbtableprefix' => 'oc_',
  'dbuser' => '{{postgresql.nextcloud.username}}',
  'dbpassword' => '{{postgresql.nextcloud.password}}',
  'installed' => true,
);