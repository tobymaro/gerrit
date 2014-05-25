if platform?("ubuntu")
  package "openjdk-6-jre-headless"
else
  include_recipe "java"
end