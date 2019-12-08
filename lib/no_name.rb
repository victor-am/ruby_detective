module NoName
end

require 'parser/current'

require_relative 'no_name/errors'

require_relative 'no_name/report'
require_relative 'no_name/file_parser'

require_relative 'no_name/rich_node_analyzer'
require_relative 'no_name/graph_builder'

require_relative 'no_name/definitions/class_declaration'

require_relative 'no_name/rich_nodes/query'
require_relative 'no_name/rich_nodes/factory'
require_relative 'no_name/rich_nodes/generic_node'
require_relative 'no_name/rich_nodes/value_node'
require_relative 'no_name/rich_nodes/constant_reference_node'
require_relative 'no_name/rich_nodes/class_declaration_node'
require_relative 'no_name/rich_nodes/module_declaration_node'
