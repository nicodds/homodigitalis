@@site_url = '/'

task :cloud_basic do
  puts 'Generating tag cloud...'
  require 'rubygems'
  require 'jekyll'
  include Jekyll::Filters
  
  options = Jekyll.configuration({})
  site = Jekyll::Site.new(options)
  site.read_posts('')
  
  html = ''
  
  site.tags.each do |tag, posts|
    
    s = posts.count
    next if s < 2
    
    font_size = 10 + (s*2);
    html << "<a href=\"/tag/#{tag}/\" title=\"Post con tag #{tag}\" style=\"font-size: #{font_size}px; line-height:#{font_size}px\" rel=\"tag\">#{tag}</a> "
  end
  
  File.open('_includes/tags.html', 'w+') do |file|
    file.puts html
  end
  
  puts 'Done.'
end


task :cloud do
    puts 'Generating tag cloud...'
    require 'rubygems'
    require 'jekyll'
    require 'pp'
    include Jekyll::Filters

    options = Jekyll.configuration({})
    site = Jekyll::Site.new(options)
    site.read_posts('')
   
    html =<<-HTML
---
layout: base
title: Tags
description: "Tutti i tag di Homo Digitalis, il blog di Domenico Delle Side"
---
<div id="content">
<div id="main">
<div class="post">

<h2>Tag cloud di {{site.title}}</h2>

    <p>Click su un tag per vedere i post disponibili.</p>
    HTML
  
  site.tags.each do |tag, posts|
    next if tag == ".net"
    html << <<-HTML
      HTML
    
    s = posts.count
    font_size = 12 + (s*1.5);
    html << "<a href=\"/tag/#{tag}/\" title=\"Post con tag #{tag}\" style=\"font-size: #{font_size}px; line-height:#{font_size}px\">#{tag}</a> "
  end

  html << "</div>
</div>
</div>
"
  
  File.open('tags.html', 'w+') do |file|
    file.puts html
  end
  
  puts 'Done.'
end

desc 'Generate tags page'
task :tags => [:cloud_basic, :cloud] do
  puts "Generating tags..."
  require 'rubygems'
  require 'jekyll'
  include Jekyll::Filters
  
  options = Jekyll.configuration({})
  site = Jekyll::Site.new(options)
  site.read_posts('')
  site.tags.each do |tag, posts|
    
    next if tag == ".net"
    html = ''
    html << <<-HTML
---
layout: base
title: Post con tag "#{tag}"
description: "Elenco di tutti i post con tag '#{tag}' presenti su Homo Digitalis, il blog di Domenico Delle Side"
---
<div id="content">
<div id="main">
<div class="post">
<h2>Post con tag "#{tag}"</h2>
<a href="/tags.html" title="Tag cloud for {{site.title}}">&laquo; Tutti i tag...</a>
HTML

    html << '<ul class="posting_list">'
    posts.each do |post|
      post_data = post.to_liquid
      html << <<-HTML
        <li><a href="#{post.url}" rel="tag" title="Leggi il post #{post_data['title']}">#{post_data['title']}</a></li>
      HTML
    end
    html << '</ul>'
    
    html << '</div>
</div>
</div>
'
    FileUtils.mkdir_p "tag/#{tag}"
    File.open("tag/#{tag}/index.html", 'w+') do |file|
      file.puts html
    end
  end
  puts 'Done.'
end
