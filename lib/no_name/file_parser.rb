require 'parser/current'

module NoName
  class FileParser
    attr_reader :root, :constants

    NODE_CLASS = Parser::AST::Node

    def initialize(file_path)
      @code = File.read(file_path)
      @constants = []
    end

    def parse
      @constants = []
      @root = Parser::CurrentRuby.parse(@code)

      extract_data_from_node(@root)

      @constants.uniq!
    end

    private

    # Sample structure
    #
    # [
    #   :module, [
    #     :const, nil, :MyNamespace
    #   ],
    #   [
    #     :begin, [
    #       :class, [
    #         :const, nil, :MyClass
    #       ], nil, [
    #         :def, :my_method, [
    #           :args
    #         ],
    #         [
    #           :send, [
    #             :send, [
    #               :const, nil, :MyOtherClass
    #             ],
    #             :new
    #           ], :my_other_method
    #         ]
    #       ]
    #     ],
    #     [
    #       :class, [
    #         :const, nil, :MyOtherClass
    #       ],
    #       nil, [
    #         :def, :my_other_method, [
    #           :args
    #         ],
    #         [
    #           :int, 1
    #         ]
    #       ]
    #     ]
    #   ]
    # ]
    def extract_data_from_node(node)
      node.children.each do |child_node|
        next unless child_node.is_a?(NODE_CLASS)

        if child_node.type == :const
          constant_name = child_node.children[1]
          register_constant_as_dependency(constant_name)
        end

        extract_data_from_node(child_node)
      end
    end

    def register_constant_as_dependency(constant_name)
      @constants << constant_name
    end
  end
end
