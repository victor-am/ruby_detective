module RubyDetective
  module SourceRepresentation
    module Entities
      class Base
        ROOT_SIGN_SYMBOL = :"::"

        def absolute_path?
          namespace.first == ROOT_SIGN_SYMBOL
        end

        def path
          namespace + [name]
        end

        def path_without_root_sign
          namespace_without_root_sign + [name]
        end

        # Removes the :"::" symbol from the namespace
        def namespace_without_root_sign
          if absolute_path?
            namespace[1..-1]
          else
            namespace
          end
        end

        def path_as_text
          if absolute_path?
            "::" + path_without_root_sign.join("::")
          else
            path.join("::")
          end
        end

        def namespace_as_text
          if absolute_path?
            "::" + namespace_without_root_sign.join("::")
          else
            namespace.join("::")
          end
        end
      end
    end
  end
end
