COMMONMARK=node_modules/.bin/commonmark
BUILD=build
DOCS=privacy terms

all: $(addprefix $(BUILD)/,$(addsuffix .html,$(DOCS)))

$(BUILD)/%.html: %.md %.updated $(BUILD) $(COMMONMARK)
	sed 's/UPDATED/$(shell cat "$*.updated")/' $*.md | $(COMMONMARK) > $@

%.updated: %.md
	date -d"$(shell git log -1 --format=%cd --date=short $<)" "+%B %e, %Y" > $@

$(BUILD):
	mkdir -p $(BUILD)

$(COMMONMARK):
	npm i

.PHONY: clean docker format

clean:
	rm -rf $(BUILD)

DOCKER_TAG=markdown-web-terms

docker:
	docker $(BUILD) -t $(DOCKER_TAG) .
	docker run -v $(shell pwd)/$(BUILD):/work/$(BUILD) $(DOCKER_TAG)
	sudo chown -R `whoami` $(BUILD)

format:
	for doc in $(DOCS); do \
		fmt --uniform-spacing --width=72 $$doc.md > $$doc.tmp && \
		mv $$doc.tmp $$doc.md ; \
	done
