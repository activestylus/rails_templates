class String
  
  def to_dom_id
    self.downcase.gsub(/\s/, '-').gsub(/[^\w^\-]/, '')
  end
  
  def urlize
    self.gsub(/[^\/\w\s\-€”]/,'').gsub(/[^\w]|[\_]/,' ').split.join('-').downcase
  end

  def to_url
    I18n.translate(self.to_s).urlize
  end
  
  def strip_html
    self.gsub(/<\/?[^>]*>/, "") if self
  end
end