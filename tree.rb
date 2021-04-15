require_relative 'node'

class Tree
  attr_reader :root

  def initialize(array = [])
    self.root = build_tree(array)
  end

  def build_tree(arr)
    return nil if arr.empty?

    array = simplify_array(arr)
    midpoint = array.length / 2
    data = array.delete_at(midpoint)
    halves = halve_array(array)
    left = build_tree(halves[0])
    right = build_tree(halves[1])
    Node.new(data: data, left: left, right: right)
  end

  def simplify_array(arr)
    arr.sort.uniq
  end

  def halve_array(arr)
    arr.length <= 1 ? [arr, []] : arr.each_slice((arr.length / 2.0).round).to_a
  end

  def insert(data)
    node = Node.new(data: data)
    unless root
      self.root = node
      return self
    end

    cur = prev = root
    while cur
      return puts "#{data} already in Tree" if cur == node

      prev = cur
      cur = data < cur.data ? cur.left : cur.right
    end

    if node < prev
      prev.left = node
    else
      prev.right = node
    end
    self
  end

  def delete(data)
    return nil unless root

    cur = prev = root
    until cur.data == data
      prev = cur
      cur = data < cur.data ? cur.left : cur.right
      return puts "#{data} is not in Tree" unless cur
    end

    if cur.leaf?
      cur < prev ? prev.left = nil : prev.right = nil
    elsif cur.left.nil? || cur.right.nil?
      if cur < prev
        prev.left = cur.left || cur.right
      else
        prev.right = cur.left || cur.right
      end
    else
      new_data = inorder_successor(data)
      delete(new_data)
      cur.data = new_data
    end
    self
  end

  def inorder_successor(data)
    node = find(data)
    return nil if node.right.nil?

    node = node.right
    node = node.left until node.left.nil?
    node.data
  end

  def find(data)
    return self unless root

    cur = root
    until cur.data == data
      cur = data < cur.data ? cur.left : cur.right
      return nil unless cur
    end
    cur
  end

  def level_order
    result = []
    return result unless root

    queue = [root]
    until queue.empty?
      node = queue.pop
      queue.unshift(node.left) unless node.left.nil?
      queue.unshift(node.right) unless node.right.nil?
      result << node.data
    end
    result
  end

  def inorder
    result = []
    return result unless root

    stack = []
    cur = root
    until cur.nil? && stack.empty?
      until cur.nil?
        stack.push(cur)
        cur = cur.left
      end
      cur = stack.pop
      result << cur.data
      cur = cur.right
    end
    result
  end

  def preorder
    result = []
    return result unless root

    stack = [root]
    until stack.empty?
      node = stack.pop
      result << node.data
      stack << node.right unless node.right.nil?
      stack << node.left unless node.left.nil?
    end
    result
  end

  def postorder
    result = []
    return result unless root

    stack1 = [root]
    stack2 = []
    until stack1.empty?
      node = stack1.pop
      stack2 << node
      stack1 << node.left unless node.left.nil?
      stack1 << node.right unless node.right.nil?
    end

    result << stack2.pop.data until stack2.empty?
    result
  end

  def height(node = root)
    queue = [node]
    height = 0
    return height unless node

    loop do
      node_count = queue.size
      return height if node_count.zero?

      height += 1
      until node_count.zero?
        node = queue.pop
        queue.unshift(node.left) unless node.left.nil?
        queue.unshift(node.right) unless node.right.nil?
        node_count -= 1
      end
    end
  end

  def depth(node)
    depth = 0
    return 0 unless node

    cur = root
    until cur == node
      cur = node.data < cur.data ? cur.left : cur.right
      depth += 1
    end
    depth
  end

  def balanced?
    return true unless root

    stack = [root]
    until stack.empty?
      node = stack.pop
      return false if (height(node.left) - height(node.right)).abs > 1

      stack << node.right unless node.right.nil?
      stack << node.left unless node.left.nil?
    end
    true
  end

  def rebalance
    self.root = build_tree(level_order)
    self
  end

  # Taken from TOP project page
  def pretty_print(node = root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end

  private

  attr_writer :root
end
