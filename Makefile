review:
	bin/rubocop
	bundle exec rails_best_practices .
	bundle exec erb_lint --lint-all
	bin/brakeman --run-all-checks -q --color --no-summary
