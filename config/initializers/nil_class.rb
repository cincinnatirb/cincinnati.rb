class NilClass
  # Allowing a chain like: value.nonblank? || 'default value'
  def nonblank?
    self
  end
  # so it plays nicely with Numeric#nonzero?
  def nonzero?
    self
  end
end
