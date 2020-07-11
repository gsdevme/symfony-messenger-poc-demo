.PHONY: all
default: all;

# either dev,prod
env=dev

build:
	docker-compose \
		-f infrastructure/docker-compose.yml \
		-f infrastructure/docker-compose.$(env).yml \
		--project-name messenger-demo \
		--project-directory $(CURDIR) \
		build

start:
	docker-compose \
		-f infrastructure/docker-compose.yml \
		-f infrastructure/docker-compose.$(env).yml \
		--project-name messenger-demo \
		--project-directory $(CURDIR) \
		up -d

stop:
	docker-compose \
		-f infrastructure/docker-compose.yml \
		-f infrastructure/docker-compose.$(env).yml \
		--project-name messenger-demo \
		--project-directory $(CURDIR) \
		down --remove-orphans

init:
	docker-compose \
		-f infrastructure/docker-compose.yml \
		-f infrastructure/docker-compose.$(env).yml \
		--project-name messenger-demo \
		--project-directory $(CURDIR) exec php bin/console doctrine:schema:create

mi:
	docker-compose \
		-f infrastructure/docker-compose.yml \
		-f infrastructure/docker-compose.$(env).yml \
		--project-name messenger-demo \
		--project-directory $(CURDIR) exec php bin/console doctrine:mi:mi -n

shell:
	docker-compose \
		-f infrastructure/docker-compose.yml \
		-f infrastructure/docker-compose.$(env).yml \
		--project-name messenger-demo \
		--project-directory $(CURDIR) exec php bash

server-dump:
	docker-compose \
		-f infrastructure/docker-compose.yml \
		-f infrastructure/docker-compose.$(env).yml \
		--project-name messenger-demo \
		--project-directory $(CURDIR) exec php bin/console server:dump

shell-ci:
	docker-compose \
		-f infrastructure/docker-compose.yml \
		-f infrastructure/docker-compose.$(env).yml \
		--project-name messenger-demo \
		--project-directory $(CURDIR) exec php make ci

shell-unit:
	docker-compose \
		-f infrastructure/docker-compose.yml \
		-f infrastructure/docker-compose.$(env).yml \
		--project-name messenger-demo \
		--project-directory $(CURDIR) exec php make unit

install:
	docker-compose \
		-f infrastructure/docker-compose.yml \
		-f infrastructure/docker-compose.$(env).yml \
		--project-name messenger-demo \
		--project-directory $(CURDIR) exec php composer install

ci:
	vendor/bin/phpcs --standard=ruleset.xml -sp src/ && \
	vendor/bin/phpstan analyse -c phpstan.neon -l 8 src/

unit:
	export APP_ENV=test && vendor/bin/simple-phpunit --bootstrap tests/bootstrap.php tests/
