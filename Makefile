review:
	bin/rubocop
	bundle exec rails_best_practices .
	bundle exec erb_lint --lint-all
	bundle exec database_consistency
	bin/brakeman --run-all-checks -q --color --no-summary

test:
	bundle exec rspec --fail-fast=5
