#etc/puppet/manifests/classes/project.pp
node "elijah.example.com" {
	include pogi
	include timezone

}
class pogi {
	package { 'vim' :
		ensure => 'installed',
		allow_virtual => true,
		}
	package { 'curl': 
		ensure => 'installed',
		}
	package { 'git': 
		ensure => 'installed'
		 }
	package { 'wget' :
		ensure => 'installed',
		}
	user  { 'monitor':
		ensure => 'present',
		managehome => true,
		home => '/home/monitor',
		shell => '/bin/bash',
		}

	wget::fetch { 'memory_check' :
		source => 'http://raw.githubusercontent.com/elijah719/project/master/memory_check.sh',
		destination => '/home/monitor/scripts/',
		timeout => 0,
		verbose => false,
		}
	file {'/home/monitor/src' :
		ensure => 'directory',
		}
	file {'/home/monitor/src/my_memory_check' :
		ensure => 'link',
		target => '/home/monitor/scripts/memory_check.sh'
	}

	cron { '/home/monitor/src/my_memory_check' :
		user => monitor,
		command => '/home/monitor/src/my_memory_check',
		minute => '*/10',
		require => File['/home/monitor/src/my_memory_check']
		}
		
	class { 'timezone' :
		timezone => 'PHT',
		}
}

