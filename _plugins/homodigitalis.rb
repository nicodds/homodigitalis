module HomoDigitalisHelpers
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


