NAME = HELLO

.PHONY: all restart rebuild setup build get_dump pull_db import_db logs manage start stop status help dbinit \
	deploy first_deploy test tests coverage docs pylint flake8 depup

all: ## setup && build && start
all: setup build start

restart: ## stop && start
restart: stop start

rebuild: ## build && restart
rebuild: build restart

setup: ## Setup local dev env.
setup:
		rm -rf .docker_env && virtualenv -p python3 .docker_env && ./.docker_env/bin/pip install -r requirements/docker.txt
		touch .env

edit_settings_vault: ## Edit vault settings file
edit_settings_vault:
		python3 -m venv .docker_env && ./.docker_env/bin/pip install -r requirements/docker.txt
		.docker_env/bin/ansible-vault edit docker/ansible/vars/settings.vault.yaml --vault-password-file=.vaultfile

decrypt_vaultfiles: ## decrypt vaultfiles
decrypt_vaultfiles:
		cat .vaultfile.gpg | gpg -d > .vaultfile
		# cat provision/.vaultfile.gpg | gpg -d > provision/.vaultfile

restart: ## stop && start
restart: stop start

rebuild: ## build && restart
rebuild: build restart

build: ## Build App Docker Images.
build:
		@docker/scripts/docker-compose build $(arg)

build-prod: ## Build production image
build-prod:
		docker build -f Dockerfile.prod . -t helloworld:latest

start: ## Start all containers.
start:
		@docker/scripts/docker-compose up -d --remove-orphans
		@docker/scripts/docker-compose exec web /worker/code/docker/scripts/start.sh run_info

status: ## Show containers status.
status:
		@docker/scripts/docker-compose ps

stop: ## Stop all containers.
stop:
		@docker/scripts/docker-compose down

logs: ## Show logs from all running containers
logs:
		@docker/scripts/docker-compose logs

manage: ## Django manage. Specify arguments as arg=""
manage:
		@docker/scripts/docker-compose exec -u worker web /bin/bash -c '/worker/code/manage.py $(arg)'

dbinit: ## Clear database and populate it with test data
dbinit:
	  @docker/scripts/docker-compose exec -u worker web /bin/bash -c '/worker/code/manage.py init_db'

dbshell: ## Django database shell
dbshell:
		$(MAKE) manage arg="dbshell"

shell: ## Django shell
shell:
		$(MAKE) manage arg="shell_plus"

migrate: ## Migrate django
migrate:
		$(MAKE) manage arg="migrate"

first_deploy: ## First time deploy - initialize remote host, repo & access
first_deploy:
		cd deploy && ./venv-ansible-playbook 0_configure.yml -l $(site)
		$(MAKE) deploy site=$(site)

deploy: ## Django manage. Specify arguments as arg=""
deploy:
		$(MAKE) manage arg="collectstatic --noinput"
		cd deploy && ./venv-ansible-playbook 1_deploy.yml -l $(site)

get_dump: ## Get dump from host
get_dump:
		$(MAKE) manage arg="collectstatic --noinput"
		cd deploy && ./venv-ansible-playbook get_dump.yml -l $(site)

import_dump: ## Run automated test
import_dump:
		@docker/scripts/docker-compose stop web celery celerybeat
		@docker/scripts/docker-compose exec -u postgres db bash -c /dumps/import_dump.sh
		$(MAKE) start

help: ## display this help message
	@echo "Please use 'make <target>' where <target> is one of"
	@perl -nle'print $& if m{^[a-zA-Z_-]+:.*?## .*$$}' $(MAKEFILE_LIST) | sort | \
	awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m  %-25s\033[0m %s\n", $$1, $$2}'

update_reqs: ## Update requirements files
update_reqs:
	@.docker_env/bin/pip-compile \
		--generate-hashes \
		--output-file requirements/base.txt \
		requirements/base.in
	@.docker_env/bin/pip-compile \
		--generate-hashes \
		--output-file requirements/dev.txt \
		requirements/dev.in
	@.docker_env/bin/pip-compile \
		--generate-hashes \
		--output-file requirements/prod.txt \
		requirements/prod.in

test: ## Run automated test
test:
		hg id -b -i -t
		@docker/scripts/docker-compose exec -u worker web bash -c "/worker/code/manage.py test --noinput --settings=fc.test_settings $(arg)"

watch_test: ## For call automated test with 'inotifywait' in watch mode
watch_test:
		@docker/scripts/docker-compose exec -T -u worker web bash -c "/worker/code/manage.py test  --noinput --settings=fc.test_settings $(arg)"

# depricated since 'make test' works fine again
tests: test

coverage: ## Run coverage report
coverage:
		@docker/scripts/docker-compose exec -u worker web bash -c \
			"(python -m coverage run --rcfile=/worker/code/coverage/config /worker/code/manage.py \
			test --noinput --settings=fc.test_settings app1 app2 app3 ; exit 0)"
		@docker/scripts/docker-compose exec -u worker web \
			python -m coverage html --rcfile=/worker/code/coverage/config
		@docker/scripts/docker-compose exec -u worker web \
			python -m coverage report --rcfile=/worker/code/coverage/config
		xdg-open coverage/coverage_html_report/index.html

docs: ## Build docs
docs:
		@docker/scripts/docker-compose exec $(arg) -u worker web bash -c "cd docs && make html"
		xdg-open docs/_build/html/index.html

publish_docs: ## Publish docs to http://helloworld-docs.ua2web.com/docs/
publish_docs:
		rsync -e "ssh -p 12076" -a docs/_build/html/ client@helloworld-docs.ua2web.com:/var/www/htdocs/docs/
		xdg-open http://helloworld-docs.ua2web.com/docs/

hg_assert_one_head_now: ## There must be only 1 head, warn otherwise
hg_assert_one_head_now:
		bash bin/check_heads.sh

drop_testdb: ## Drop testdb (for buildbot, needed for automated testing)
drop_testdb:
		@docker/scripts/docker-compose exec -u worker web bash -c \
			'(echo "drop database test_fc"|/worker/code/manage.py dbshell; exit 0)'

#			'pylint -j 0 ' \

pylint: ## Check pylint
pylint:
		@docker/scripts/docker-compose exec -u worker web bash -c \
			'(cd helloworld; pylint -j 0 helloworld.core.Game helloworld.core.Country helloworld.core.City)'

flake8: ## Check flake8 - PEP8 checks
flake8:
		@docker/scripts/docker-compose exec -u worker web bash -c \
			'(flake8 helloworld/helloworld/core)'

depup: ## Dependency packages
depup:
		git clone https://github.com/fniessen/org-html-themes.git

push_to_registry: ## Push to openshift registry
push_to_registry:
		docker tag helloworld:latest localhost:5000/helloworld:latest
		docker push localhost:5000/helloworld:latest
