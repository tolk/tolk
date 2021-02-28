module Tolk
  module Pagination
    module Methods
      # Kaminari defaults page_method_name to :page, will_paginate always uses :page
      def pagination_method
        defined?(Kaminari) ? Kaminari.config.page_method_name : :page
      end

      # Kaminari defaults param_name to :page, will_paginate always uses :page
      def pagination_param
        defined?(Kaminari) ? Kaminari.config.param_name : :page
      end
    end

    module ViewHelper
      def tolk_paginate(collection, options = {})
        if respond_to?(:will_paginate)
          # If parent app is using Will Paginate, we need to use it also
          will_paginate collection, options
        else
          # Otherwise use Kaminari
          paginate collection, options
        end
      end
    end
  end
end
