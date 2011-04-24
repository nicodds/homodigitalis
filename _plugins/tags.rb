module Jekyll
  class AllTagCloudTag < Liquid::Tag
    safe = true
    
    def initialize(tag_name, text, tokens)
      super
    end

    def render(context)
      html = ""
      tags = context.registers[:site].tags
      avg = tags.inject(0.0) {|memo, tag| memo += tag[1].length} / tags.length
      weights = Hash.new
      tags.each {|tag| weights[tag[0]] = tag[1].length/avg}
      tags.each do |tag, posts|
        html << "\t<span style=\"font-size: #{sprintf("%d", weights[tag] * 100)}%\"><a href='/tag/#{tag}/' title=\"post con tag #{tag}\">#{tag}</a></span>\n"
      end
      html
    end
  end

  class SubTagCloudTag < Liquid::Tag
    safe = true
    
    def initialize(tag_name, level, tokens)
      @level = level.to_i - 1
      super
    end

    def render(context)
      html = ""
      tags = context.registers[:site].tags.reject {|tag,posts| posts.length <= @level}
      max = (tags.collect {|tag, posts| posts.length}).max
      min = (tags.collect {|tag, posts| posts.length}).min
      tags.each do |tag, posts|
        html << "  <span style=\"font-size: #{sprintf("%2f", 100 + (120*(posts.length-min)/max))}%\"><a href='/tag/#{tag}/' title=\"post con tag #{tag}\">#{tag}</a></span>\n"
      end
      html
    end
  end


  class TagPage < Page
    include Convertible
    attr_accessor :site, :pager, :name, :ext
    attr_accessor :basename, :dir, :data, :content, :output

    def initialize(site, tag, posts)
      @site = site
      @base = 'tag'
      @dir = tag
      @tag = tag
      self.ext = '.html'
      @name = 'index' + self.ext
      self.basename = @name
      self.content = <<-EOS


<div id="content">
  <div id="main">
    <div class="post">
      <h2>Post con tag "#{tag}"</h2>

      <a href="/tags.html" title="Tag cloud for {{site.title}}">&laquo; Tutti i tag...</a>

      <ul class="posting_list">
{% for post in page.posts %}
        <li><a href="{{ post.url }}" rel="tag" title="Leggi il post {{ post.title }}">{{ post.title }}</a></li>
{% endfor %}
      </ul>
    </div>
  </div>
</div>


EOS
      self.data = {
        'layout' => 'base',
        'title' => "Post con tag \"#{@tag}\"",
        'description' => "Homo Digitalis, il blog di Domenico Delle Side. Elenco di tutti i post con tag '#{@tag}'",
        'keywords' => ([tag] + site.config['default_keywords']).join(', '),
        'posts' => posts
      }
    end

    def render(layouts, site_payload)
      payload = {
        "page" => self.to_liquid,
        "paginator" => pager.to_liquid
      }.deep_merge(site_payload)
      do_layout(payload, layouts)
    end

    def url
      File.join("/tag", @dir, @name)
    end

    def to_liquid
      self.data.deep_merge({
                             "url" => self.url,
                             "content" => self.content
                           })
    end

    def write(dest_prefix, dest_suffix = nil)
      dest = dest_prefix
      dest = File.join(dest, dest_suffix) if dest_suffix
      path = File.join(dest, CGI.unescape(self.url))
      FileUtils.mkdir_p(File.dirname(path))
      File.open(path, 'w') do |f|
        f.write(self.output)
      end
    end

    def pager
      true
    end

    def html?
      true
    end
  end


  class TagPageGenerator < Generator
    safe true

    def generate(site)
      site.tags.each do |tag, posts|
        site.pages << TagPage.new(site, tag, posts)
      end
    end
  end

end

Liquid::Template.register_tag('all_tags', Jekyll::AllTagCloudTag)
Liquid::Template.register_tag('sub_tags', Jekyll::SubTagCloudTag)

