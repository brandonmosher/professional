# Force xelatex to search for .cls files in other directories
export TEXINPUTS := .//:

CC = xelatex -interaction=nonstopmode -halt-on-error

SRC_DIR = professional-data
BUILD_DIR = build

all:
	@echo "usage: make [DOCUMENT_TYPE][VERSION].pdf"
	@echo "error: no document type specified"

%.pdf:
	$(eval TYPE = $(firstword $(subst -, ,$*)))
	$(eval BUILD_DIR = $(abspath $(BUILD_DIR)/$*))
	$(eval SRC_DIR = $(abspath $(SRC_DIR)/$(TYPE)))
	$(eval ARGS = $(shell cat $(SRC_DIR)/$*.version))
	cd $(SRC_DIR) && json_to_tex $(ARGS) --output-dirpath $(BUILD_DIR)
	$(CC) -output-directory=$(BUILD_DIR) $(BUILD_DIR)/$*.tex

# Rule to run when LaTex Workshop triggers build
# Should find all currently build versions that use the updated template and rebuild them
template/%:
	@

clean:
	rm -rf $(BUILD_DIR)
