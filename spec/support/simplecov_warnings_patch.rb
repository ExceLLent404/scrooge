module SimpleCov
  class SourceFile
    # The original method patched not to pollute log with warnings
    # when `enable_coverage_for_eval` option is enabled
    def coverage_exceeding_source_warn
    end
  end
end
