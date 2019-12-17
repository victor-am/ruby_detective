module RubyDetective
end

require "parser/current"

require_relative "ruby_detective/runner"
require_relative "ruby_detective/file_parser"
require_relative "ruby_detective/dependency_search"
require_relative "ruby_detective/json_builder"
require_relative "ruby_detective/ui_generator"

require_relative "ruby_detective/representations/class_representation"

require_relative "ruby_detective/ast/analyzer"
require_relative "ruby_detective/ast/query"
require_relative "ruby_detective/ast/node_factory"

require_relative "ruby_detective/ast/nodes/generic_node"
require_relative "ruby_detective/ast/nodes/value_node"
require_relative "ruby_detective/ast/nodes/constant_reference_node"
require_relative "ruby_detective/ast/nodes/class_declaration_node"
require_relative "ruby_detective/ast/nodes/module_declaration_node"
