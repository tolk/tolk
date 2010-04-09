Mime::Type.register_alias "text/yaml", :yml

will_paginate = File.join(File.dirname(__FILE__), 'vendor/plugins/will_paginate')
$: << File.join(will_paginate, 'lib')

require File.join(will_paginate, 'init')
