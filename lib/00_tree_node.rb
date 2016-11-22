require 'byebug'
class PolyTreeNode
  attr_accessor :value, :parent, :children

  def initialize(value)
    @value = value
    @parent = nil
    @children = []
  end

  def parent=(node)
    if node.nil?
      @parent = nil
    else
      self.parent.children.reject! { |el| el == self } unless parent.nil?
      @parent = node
      parent.children << self unless parent.children.include?(self)
    end
  end

  def add_child(child_node)
    child_node.parent = self
  end

  def remove_child(child_node)
    raise "error" unless children.include?(child_node)
    child_node.parent = nil
  end

  def dfs(target_value)
    return self if self.value == target_value

    children.each do |child|
      current_node = child.dfs(target_value)
      return current_node unless current_node.nil?
    end

    nil
  end

  def bfs(target)
    queue = [self]

    until queue.empty?
      el = queue.shift
      return el if el.value == target
      el.children.each { |child| queue << child }
    end

    nil
  end
end
