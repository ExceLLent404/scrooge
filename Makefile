review:
	bin/rubocop
	bundle exec erb_lint --lint-all
	bin/brakeman --run-all-checks -q --color --no-summary
