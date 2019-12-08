require 'json'

module NoName
  class GraphBuilder
    attr_reader :classes

    def initialize(classes)
      @classes = classes
    end

    def build
      nodes = classes.each_with_index.map do |c, index|
        {
          id: "n#{index}",
          label: c.full_name,
          size: c.lines_of_code
        }
      end

      edges = classes.each_with_index.map do |c, class_index|
        class_node = nodes.find{|n| n[:label] == c.full_name}

        c.dependencies.each_with_index.map do |d, dependency_index|
          dependency_node = nodes.find{|n| n[:label] == d.full_name}

          {
            id: "e#{class_index}-#{dependency_index}",
            source: class_node[:id],
            target: dependency_node[:id]
          }
        end
      end.flatten

      { nodes: nodes, edges: edges }.to_json
    end
  end
end
