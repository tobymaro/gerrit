name             "gerrit"
maintainer       "Steffen Gebert"
maintainer_email "steffen.gebert@typo3.org"
license          "Apache 2.0"
description      "Installs/Configures gerrit"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.4.2"

%w{ database mysql postgresql java git apache2}.each do |cookbook|
  depends cookbook
end

recipe "gerrit::default", "Installs and configures Gerrit. Includes other recipes, if needed"
recipe "gerrit::mysql", "Installs MySQL server and configures Gerrit to use MySQL"
recipe "gerrit::proxy", "Installs Apache2 as reverse proxy in front of Gerrit"

supports "debian"
