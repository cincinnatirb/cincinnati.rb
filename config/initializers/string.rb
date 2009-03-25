class String
  # Allowing a chain like: string_value.nonblank? || 'default value'
  def nonblank?
    self unless blank?
  end

  # Future-proof by adding an #ord method to return the integral value of a
  # string (the first character).
  unless instance_methods.include?('ord') # Ruby 2.0
    def ord
      unless size == 1
        raise TypeError, "expected a characer, but string of size %ld given" % size
      end

      self[0]                   # Ruby 1.8
    end
  end

end
