module RubyDetective
end

require 'parser/current'

require_relative 'ruby_detective/errors'

require_relative 'ruby_detective/report'
require_relative 'ruby_detective/file_parser'

require_relative 'ruby_detective/rich_node_analyzer'
require_relative 'ruby_detective/graph_builder'

require_relative 'ruby_detective/definitions/class_declaration'

require_relative 'ruby_detective/rich_nodes/query'
require_relative 'ruby_detective/rich_nodes/factory'
require_relative 'ruby_detective/rich_nodes/generic_node'
require_relative 'ruby_detective/rich_nodes/value_node'
require_relative 'ruby_detective/rich_nodes/constant_reference_node'
require_relative 'ruby_detective/rich_nodes/class_declaration_node'
require_relative 'ruby_detective/rich_nodes/module_declaration_node'
