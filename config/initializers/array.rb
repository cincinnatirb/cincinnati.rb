class Array
  def random
    self[rand(self.length)]
  end

  def ===(other)
    include?(other)
  end
end
