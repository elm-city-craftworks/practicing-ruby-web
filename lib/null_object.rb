class << (NullObject = Object.new)
  def method_missing(id, *a, &b)
    NullObject
  end
end
