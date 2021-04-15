require_relative 'tree'

# arr = [4, 10, 12, 15, 18, 22, 24, 25, 31, 35, 44, 50, 66, 70, 90]
arr = Array.new(15) { rand(1..100) }
tree = Tree.new(arr.shuffle)

puts "Balanced?: #{tree.balanced?}"
puts "Level order: #{tree.level_order}"
puts "Preorder: #{tree.preorder}"
puts "Postorder: #{tree.postorder}"
puts "Inorder: #{tree.inorder}"
puts

new_values = [123, 234, 345, 456, 567, 678, 789, 890]
new_values.each { |i| tree.insert(i) }
puts "Unbalancing with insertion of these values: #{new_values}"
puts

puts "Balanced?: #{tree.balanced?}"
puts

tree.rebalance
puts 'Rebalancing...'
puts

puts "Balanced?: #{tree.balanced?}"
puts "Level order: #{tree.level_order}"
puts "Preorder: #{tree.preorder}"
puts "Postorder: #{tree.postorder}"
puts "Inorder: #{tree.inorder}"
