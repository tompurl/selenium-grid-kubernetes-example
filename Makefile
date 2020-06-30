# HELP
# This will output the help for each task
# thanks to https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
.PHONY: help
current_dir = $(shell pwd)
robot_threads = 4
help: ## Er-doy
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help

run-rf-chrome-tests: ## Run the Robot Framework tests against Chrome
	sudo docker run --network="host" --rm -e ROBOT_OPTIONS="-V /opt/robotframework/tests/env-chrome.py" -v $(current_dir)/Output:/opt/robotframework/reports -v $(current_dir)/tests:/opt/robotframework/tests ppodgorsek/robot-framework

run-rf-opera-tests: ## FIXME - Run the Robot Framework tests against Opera
	sudo docker run --network="host" --rm -e ROBOT_OPTIONS="-V /opt/robotframework/tests/env-opera.py -v BROWSER:opera -v VERSION:68.0" -v $(current_dir)/Output:/opt/robotframework/reports -v $(current_dir)/tests:/opt/robotframework/tests ppodgorsek/robot-framework

run-rf-ff-tests: ## Run the Robot Framework tests against Firefox
	sudo docker run --network="host" --rm -e ROBOT_OPTIONS="-V /opt/robotframework/tests/env-ff.py" -v $(current_dir)/Output:/opt/robotframework/reports -v $(current_dir)/tests:/opt/robotframework/tests ppodgorsek/robot-framework

run-rf-tests-concurrently: ## Run the Robot Framework tests using multiple threads tests against Firefox
	sudo docker run --network="host" --rm -e ROBOT_OPTIONS="-V /opt/robotframework/tests/env-ff.py" -e ROBOT_THREADS=$(robot_threads) -v $(current_dir)/Output:/opt/robotframework/reports -v $(current_dir)/tests:/opt/robotframework/tests ppodgorsek/robot-framework

test: run-rf-chrome-tests run-rf-opera-tests run-rf-ff-tests
testc: run-rf-tests-concurrently
