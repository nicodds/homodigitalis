require 'yaml'

old = YAML::load_file('../files.yml')
new = YAML::load_file('_site/files.yml')

new.each_key do |k|
  if !old.has_key?(k) or old[k] != new[k]
    puts '>>>>>>>> '+k.to_s
    puts 'assente'
  end
end
