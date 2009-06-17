class Array
  def random
    self[Kernel.rand(self.length)]
  end

  def ===(other)
    include?(other)
  end
end
