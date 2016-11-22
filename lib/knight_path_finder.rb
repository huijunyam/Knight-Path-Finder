require_relative '00_tree_node'
require 'byebug'

class KnightPathFinder

  attr_reader :visited_positions, :starting_position
  attr_accessor :root_node

  MOVES = [
    [-2, -1],
    [-2, 1],
    [-1, -2],
    [-1, 2],
    [1, -2],
    [1, 2],
    [2, -1],
    [2, 1]
  ]

  def initialize(pos = [0, 0])
    @starting_position = pos
    @visited_positions = [starting_position]
    build_move_tree
  end

  def find_path(end_pos)
    end_node = root_node.dfs(end_pos)
    trace_path_back(end_node)
  end

  private
  def self.valid_moves(pos)
    valid_list = []
    x, y = pos

    MOVES.each do |dx, dy|
      current_pos = [x + dx, y + dy]
      valid_list << current_pos if current_pos.all? { |el| el.between?(0, 7) }
    end

    valid_list
  end

  def new_move_positions(pos)
    new_moves = self.class.valid_moves(pos).reject do |position|
      visited_positions.include?(position)
    end

    @visited_positions += new_moves
    new_moves
  end

  def build_move_tree
    @root_node = PolyTreeNode.new(starting_position)
    queue = [root_node]

    until queue.empty?
      first_node = queue.shift
      new_move_positions(first_node.value).each do |pos|
        node = PolyTreeNode.new(pos)
        queue << node
        first_node.add_child(node)
      end
    end
  end

  def trace_path_back(node)
    path = []
    until node.nil?
      path.unshift(node.value)
      node = node.parent
    end
    path
  end

end

if __FILE__ == $PROGRAM_NAME
  kpf = KnightPathFinder.new([0, 0])
  p kpf.find_path([7, 6])
  p kpf.find_path([6, 2])
end
