# frozen_string_literal: true

require 'date'

# Parses EVENT_DATE from a command's positional args, printing the
# command's help and exiting with status 1 if it's missing or invalid.
def parse_event_date(args, cmd)
  Date.parse(args.first)
rescue StandardError
  puts('ERROR: you must specify EVENT_DATE')
  puts
  puts(cmd.help)
  exit(1)
end
