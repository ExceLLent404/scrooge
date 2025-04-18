review:
	bin/rubocop
	bundle exec rails_best_practices .
	bundle exec erb_lint --lint-all
	bundle exec database_consistency
	bin/brakeman --run-all-checks -q --color --no-summary

test:
	bundle exec rspec --fail-fast=5

chrome:
	LANGUAGE=en_US.UTF-8 chromedriver \
		--allowed-ips=$$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' scrooge-web-1) \
		--allowed-origins="*" --port=9515 --log-level=WARNING
