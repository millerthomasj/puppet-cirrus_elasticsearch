# Class cirrus_elasticsearch::mount
#
# Properly mount as many mountpoints as needed.
#

class cirrus_elasticsearch::mount (
  $blockdevs,
  $instance_name
)
{
  if $blockdevs {
    $blockdevs.each |$index, $device| {
      $mountpoint = "/usr/share/elasticsearch/data${index}"
      $blkdev = "/dev/${device}"

      filesystem { $blkdev:
        ensure  => 'present',
        fs_type => 'ext4',
      }
      exec { "mkdir ${mountpoint}":
        command => "mkdir -p ${mountpoint}",
        path    => ['/usr/sbin', '/usr/bin', '/sbin', '/bin'],
        unless  => "test -d ${mountpoint}",
      }
      mount { $mountpoint:
        ensure  => 'mounted',
        device  => $blkdev,
        fstype  => 'ext4',
        options => 'defaults',
        require => [ Filesystem[$blkdev], Exec["mkdir ${mountpoint}"] ],
        before  => Elasticsearch::Instance[$instance_name],
      }
    }
  }
}
