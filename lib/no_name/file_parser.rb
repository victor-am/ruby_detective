require 'parser/current'

module NoName
  class FileParser
    attr_reader :root, :path, :constants, :class_definitions, :module_definitions, :inheritance_definitions

    NODE_CLASS = Parser::AST::Node

    def initialize(file_path)
      @path = file_path
      @code = File.read(file_path)
    end

    def parse
      @constants = []
      @class_definitions = []
      @module_definitions = []
      @inheritance_definitions = []
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
      node.children.each_with_index do |child_node, index|
        next unless child_node.is_a?(NODE_CLASS)

        if child_node.type == :const
          constant_name = child_node.children[1]
          register_constant_as_dependency(constant_name)

          register_definitions(node, child_node, constant_name, child_index: index)
        end

        extract_data_from_node(child_node)
      end
    end

    def register_constant_as_dependency(constant_name)
      @constants << constant_name
    end

    def register_definitions(node, child, constant_name, child_index:)
      case node.type
      when :class
        case child_index
        when 0
          register_constant_as_class(constant_name)
        when 1
          register_constant_as_inheritance(constant_name)
        else
          raise "Unexpected AST structure, please report this issue on github :x"
        end
      when :module
        register_constant_as_module(constant_name)
      end
    end

    def register_constant_as_class(constant_name)
      @class_definitions << constant_name
    end

    def register_constant_as_inheritance(constant_name)
      @inheritance_definitions << constant_name
    end

    def register_constant_as_module(constant_name)
      @module_definitions << constant_name
    end
  end
end
