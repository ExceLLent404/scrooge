review:
	bin/rubocop
	bin/brakeman --run-all-checks -q --color --no-summary
