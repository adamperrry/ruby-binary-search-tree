class Node
  include Comparable
  attr_accessor :data, :left, :right

  def initialize(data: nil, left: nil, right: nil)
    self.data = data
    self.left = left
    self.right = right
  end

  def <=>(other)
    return data <=> other.data if other.instance_of? Node

    data <=> other
  end

  def leaf?
    left.nil? && right.nil?
  end
end
