# the root name space for this scheduler
module Patriot
  # a name space for commands
  module Command 
    # a parameter key for command class name (used in jobs)
    COMMAND_CLASS_KEY   = "COMMAND_CLASS"

    # attribute name for required products
    REQUISITES_ATTR     = "requisites"
    # attribute name for produced products
    PRODUCTS_ATTR       = "products"
    # attribute name for job state
    STATE_ATTR          = "state"
    # attribute name for job priority
    PRIORITY_ATTR       = "priority"
    # attribute name for job execution node constraint
    EXEC_NODE_ATTR      = "exec_node"
    # attribute name for job execution host constraint
    EXEC_HOST_ATTR      = "exec_host"
    # attribute name for start time constraint
    START_DATETIME_ATTR = "start_datetime"
    # attribute name for the skip on fail marker
    SKIP_ON_FAIL_ATTR   = "skip_on_fail"

    # a list of comman attributes
    COMMON_ATTRIBUTES = [
      REQUISITES_ATTR,
      PRODUCTS_ATTR,
      STATE_ATTR,
      PRIORITY_ATTR,
      EXEC_NODE_ATTR,
      EXEC_HOST_ATTR,
      START_DATETIME_ATTR,
      SKIP_ON_FAIL_ATTR
    ]

    # exit code of a command
    module ExitCode
      # successfully finished
      SUCCEEDED    = 0
      # failed
      FAILED       = 1
      # failed but skipped (marked skip_on_fail)
      FAILURE_SKIPPED = 2
      # skip (e.g., updated elsewhere)
      SKIPPED      = -1

      # @param exit_code [Patriot::Command::ExitCode]
      # @return [String] string expression of the exit code
      def name_of(exit_code)
        exit_code = exit_code.to_i
        return case exit_code
          when 0  then "SUCCEEDED"
          when 1  then "FAILED"
          when 2  then "FAILURE_SKIPPED"
          when 4  then "FAILED" # for backward compatibility
          else raise "unknown exit_code #{exit_code}"
        end
      end
      module_function :name_of
    end

    require 'patriot/command/parser'
    require 'patriot/command/command_macro'
    require 'patriot/command/base'
    require 'patriot/command/command_group'
    require 'patriot/command/composite'
    require 'patriot/command/sh_command'
  end
end

