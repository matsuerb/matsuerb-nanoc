# frozen_string_literal: true

# The single place that knows how deep command_lib/ is nested under the
# project root, so individual command files don't each reimplement their
# own "../../../"-style arithmetic to get there.
PROJECT_ROOT = File.expand_path('..', __dir__)

def project_path(relative_path)
  File.expand_path(relative_path, PROJECT_ROOT)
end
