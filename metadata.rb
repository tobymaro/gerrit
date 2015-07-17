name             "gerrit"
maintainer       "Steffen Gebert"
maintainer_email "steffen.gebert@typo3.org"
license          "Apache 2.0"
description      "Installs/Configures gerrit"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.4.8"

depends "apache2", "~> 3.1.0"
depends "database", "~> 4.0.6"
depends "mysql", "~> 6.1.0"
depends "java", "~> 1.31.0"
depends "git", "~> 4.2.2"
