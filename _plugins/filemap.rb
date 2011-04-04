require 'yaml'
require 'digest/md5'
require 'pathname'

# taken, with some changes, from sitemap_generator.rb
# http://recursive-design.com/projects/jekyll-plugins/ which is free
# software released under the terms of the MIT license
# (http://www.opensource.org/licenses/mit-license.php)

module Jekyll

  # Monkey-patch an accessor for a page's containing folder, since 
  # we need it to generate the sitemap.
  class Page
    def subfolder
      @dir
    end
  end
  

  # Sub-class Jekyll::StaticFile to allow recovery from unimportant exception 
  # when writing the sitemap file.
  class StaticSitemapFile < StaticFile
    def write(dest)
      super(dest) rescue ArgumentError
      true
    end
  end
  
  
  # Generates a files.yml file containing URLs of all pages and posts.
  class FilemapGenerator < Generator
    safe true
    priority :low
    
    # Generates the files.yml file.
    #
    #  +site+ is the global Site object.
    def generate(site)
      # Create the destination folder if necessary.
      site_folder = site.config['destination']
      unless File.directory?(site_folder)
        p = Pathname.new(site_folder)
        p.mkdir
      end
      
      # Write the contents of files.yml.
      File.open(File.join(site_folder, 'files.yml'), 'w') do |f|
        f.write(generate_content(site))
        f.close
      end
      
      # Add an entry for the file, otherwise Site::cleanup will remove it.
      site.static_files << Jekyll::StaticSitemapFile.new(site, site.dest, '/', 'files.yml')
    end

    private
    
    # Returns a string containing the the XML entries.
    #
    #  +site+ is the global Site object.
    def generate_content(site)
      result = {}
      
      # First, try to find any stand-alone pages.      
      site.pages.each{ |page|
        path = page.subfolder + '/' + page.name
        result[path.to_sym]= Digest::MD5.hexdigest(site.source + path)
      }
      
      # Next, find all the posts.
      posts = site.site_payload['site']['posts']
      for post in posts do
        result[post.url.to_sym] = Digest::MD5.hexdigest(site.source + post.url)
      end
      
      result.to_yaml
    end

  end
  
end
