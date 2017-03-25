class String

  def deslug
    self.gsub('-', ' ').split.map(&:capitalize).join(' ')
  end

end