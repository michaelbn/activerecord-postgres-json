class String

  def from_json
    JSON.parse(self)
  end

end