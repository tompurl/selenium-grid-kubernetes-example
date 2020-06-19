# HELP
# This will output the help for each task
# thanks to https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
.PHONY: help
current_dir = $(shell pwd)
robot_threads = 4

help: ## Er-doy
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help

run-rf-tests: ${OUT_DIR} ## Run the Robot Framework tests.
	sudo docker run --rm -e -v $(current_dir)/Output:/opt/robotframework/reports -v $(current_dir)/tests:/opt/robotframework/tests ppodgorsek/robot-framework

run-rf-tests-concurrently:
	sudo docker run --rm -e ROBOT_THREADS=$(robot_threads) -v $(current_dir)/Output:/opt/robotframework/reports -v $(current_dir)/tests:/opt/robotframework/tests ppodgorsek/robot-framework

test: run-rf-tests 
testc: run-rf-tests-concurrently
