# == Define: cirrus_elasticsearch::settings
#
#  This define allows you to insert, update or delete elasticsearch settings.
#
# === Parameters
#
# [*ensure*]
#   String. Controls if the managed resources shall be <tt>present</tt> or
#   <tt>absent</tt>. If set to <tt>absent</tt>:
#
# [*content*]
#   Contents of the template ( json )
#   Value type is string
#   Default value: undef
#   This variable is optional
#
# [*host*]
#   Host name or IP address of the ES instance to connect to
#   Value type is string
#   Default value: localhost
#   This variable is optional
#
# [*port*]
#   Port number of the ES instance to connect to
#   Value type is number
#   Default value: 9200
#   This variable is optional
#
# [*protocol*]
#   Defines the protocol to use for api calls using curl
#   Default value from main class is: http
#
# [*ssl_args*]
#   SSL arguments for curl commands.
#   Default value from main class is an empty string.
#
# [*import_dir*]
#   Where to store json files on the filesystem.
#

define cirrus_elasticsearch::settings (
  $ensure     = 'present',
  $content    = undef,
  $host       = 'localhost',
  $port       = 9200,
  $protocol   = 'http',
  $curl_args   = undef,
  $import_dir = $::cirrus_elasticsearch::params::es_import_dir,
)
{
  require ::elasticsearch

  # ensure
  if ! ($ensure in [ 'present', 'absent' ]) {
    fail("\"${ensure}\" is not a valid ensure parameter value")
  }

  if ! is_integer($port) {
    fail("\"${port}\" is not an integer")
  }

  Exec {
    path      => [ '/bin', '/usr/bin', '/usr/local/bin' ],
    cwd       => '/',
    tries     => 6,
    try_sleep => 10,
  }

  file { $import_dir:
    ensure => 'directory',
    owner  => 'elasticsearch',
    group  => 'elasticsearch',
    mode   => '0750',
  }

  # Build up the url
  $es_url = "${protocol}://${host}:${port}/_snapshot/${name}"

  if ($ensure == 'present') {
    if $content == undef {
      fail('The variable "content" cannot be empty.')
    } else {
      $insert_notify = Exec["insert_${name}"]
    }
  } else {
    $insert_notify = undef
  }

  # Delete the existing item
  exec { "delete_${name}":
    command     => "curl ${curl_args} -s -XDELETE ${es_url}",
    onlyif      => "test $(curl ${curl_args} -s '${es_url}?pretty=true' | grep -c ${name}) -gt 1",
    notify      => $insert_notify,
    refreshonly => true,
  }

  if ($ensure == 'absent') {
    # delete the template file on disk and then on the server
    file { "${import_dir}/${name}.json":
      ensure  => 'absent',
      notify  => Exec[ "delete_${name}" ],
      require => File[$import_dir],
    }
  }

  if ($ensure == 'present') {
    # place the template file using content
    file { "${import_dir}/${name}.json":
      ensure  => file,
      content => template("${module_name}/${content}"),
      notify  => Exec[ "delete_${name}" ],
      require => File[$import_dir],
    }

    exec { "insert_${name}":
      command     => "curl ${curl_args} -sL -w \"%{http_code}\\n\" -XPUT ${es_url} -d @${import_dir}/${name}.json -o /dev/null | egrep \"(200|201)\" > /dev/null",
      refreshonly => true,
      loglevel    => 'debug',
    }
  }
}
