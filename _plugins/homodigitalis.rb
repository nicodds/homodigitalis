module Liquid
  module HomoDigitalisHelpers
    safe = true

    IT_MONTHS = [nil, "Gennaio", "Febbraio", "Marzo", 
                 "Aprile", "Maggio", "Giugno", "Luglio", 
                 "Agosto", "Settembre", "Ottobre", "Novembre", 
                 "Dicembre"]
    
    def to_it_date(input)
      input.strftime("%d {m} %Y").to_s.gsub(/\{m\}/, IT_MONTHS[input.strftime("%-m").to_i])
    end
    
    def to_tag_string(input)
      input.collect {|x| "<a href=\"/tag/#{x}\" rel=\"tag\" title=\"Post con tag #{x}\">#{x}</a>"}.join(', ')
    end
  end
  
  Liquid::Template.register_filter(HomoDigitalisHelpers)
end


module Jekyll
  class Page
    alias :old_to_liquid :to_liquid
    
    def to_liquid
      to_merge = {
        'keywords' => @site.config['default_keywords'].join(', '),
        "url"      => File.join(@dir, self.url),
        "content"  => self.content
      }

      unless self.data.has_key?('description')
        to_merge['description'] = @site.config['default_description']
      end

      self.data.deep_merge(to_merge)
    end
  end

  class Post
    alias :old_to_liquid :to_liquid
    
    def to_liquid
      to_merge = {
        "keywords"   => (self.tags + @site.config['default_keywords']).join(', '),
        "title"      => self.data["title"] || self.slug.split('-').select {|w| w.capitalize! || w }.join(' '),
        "url"        => self.url,
        "date"       => self.date,
        "id"         => self.id,
        "categories" => self.categories,
        "next"       => self.next,
        "previous"   => self.previous,
        "tags"       => self.tags,
        "content"    => self.content
      }

      unless self.data.has_key?('description')
        to_merge['description'] = @site.config['default_description']
      end

      self.data.deep_merge(to_merge)
    end
  end
end

