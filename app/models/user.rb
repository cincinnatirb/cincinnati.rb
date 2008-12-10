class User
  def self.authenticate username, password
    username == 'admin' && password == "foo"
  end
end
