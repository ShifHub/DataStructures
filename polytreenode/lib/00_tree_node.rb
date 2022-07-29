require 'byebug'
module Searchable
    def dfs(target_value)
        if self.value == target_value
            return self            
        end
        self.children.each do |child|
            result = child.dfs(target_value)
            return result unless result.nil?
        end
        nil
    end

    def bfs(target_value)
        queue = [self]
        until queue.empty?
            current = queue.first
            queue = queue.drop(1)
            return current if current.value == target_value
            queue += current.children
        end
        nil
    end
end

class PolyTreeNode
    include Searchable

    def initialize(value)
        @value = value
        @parent = nil
        @children = []
    end

    def value
        @value
    end

    def children
        @children
    end

    def parent
        @parent
    end

    def remove_child(node)
        found = false
        @children.each.with_index do |child, i| 
            if node === child
                node.parent = nil
                @children.delete_at(i)
                found = true
            end
        end
        unless found
            raise "Child not found"
        end
    end

    def parent=(node)
        if @parent != nil
            @parent.children.each.with_index do |child, i|
                if child === self
                    @parent.children.delete_at(i)
                end
            end
        end
        @parent = node
        unless @parent == nil || @parent.children.include?(self)
            @parent.children << self
        end
    end

    def add_child(node)
        unless @children.include?(node)
            @children << node
        end
        unless node.parent == self
            node.parent = self
        end
    end
end