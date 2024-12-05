SERVICES_DIR := ./services
COLLECTORS_DIR := ./collectors

# Take care, if you change it, modify the driver_opts in corresponding services
PERSISTENT_VOLUMES_DIR := ./openbas_persistent_volumes

SERVICES_FILES := $(wildcard $(SERVICES_DIR)/service-*.yml)
SERVICES_FILES_FLAGS := $(foreach file, $(SERVICES_FILES), -f $(file))

COLLECTORS_FILES := $(wildcard $(COLLECTORS_DIR)/collector-*.yml)
COLLECTORS_FILES_FLAGS := $(foreach file, $(COLLECTORS_FILES), -f $(file))

ENVS_DIR := ./envs
ENVS_FILES := $(wildcard $(ENVS_DIR)/*.env)

UNAME := $(shell uname)
UUID_GEN := `cat /proc/sys/kernel/random/uuid`

ifeq ($(UNAME), Darwin)
	UUID_GEN := `uuidgen`
endif

#Function to replace all `# <generate_uuid>` with the UUID_GEN command
define generate_uuids
	echo "Replacing UUID in $(1)...";
	grep "# <generate_uuid>" $(1) | while read -r line; do \
		key="$$(echo $$line | cut -d '=' -f 1)"; \
		sed -i '' "s/$$line/$$key=$(UUID_GEN) # <generate_uuid>/g" $(1); \
	done;
	echo "All UUID replaced in $(1).";
endef


#Initial Install OpenBAS
openbas-install:
	@echo "Creating Databases structures if needed..."
	@mkdir -p $(PERSISTENT_VOLUMES_DIR)/{s3data,amqpdata,pgsqldata}
	@echo "Starting installation by settings all new UUID..."
	@$(foreach file, $(ENVS_FILES), $(call generate_uuids, $(file)))
	@echo "Installation done..."

# Up OpenBAS
openbas-up:
	@echo "Building Environments..."
	@> .env
	@cat ./envs/*.env >> .env
	@echo "Starting services..."
	@docker-compose --project-name openbas $(SERVICES_FILES_FLAGS)  $(COLLECTORS_FILES_FLAGS) --env-file .env up -d
	@echo "OpenBAS should be running"

# Down OpenBAS
openbas-down:
	@echo "Stopping services..."
	@docker-compose --project-name openbas $(SERVICES_FILES_FLAGS) $(COLLECTORS_FILES_FLAGS) down -v

# Logs
openbas-logs:
	@echo "Access all docker-compose logs..."
	@docker-compose --project-name openbas $(SERVICES_FILES_FLAGS) $(COLLECTORS_FILES_FLAGS) logs -f -t --tail=1000

# Remove OpenBAS
openbas-docker-prune:
	@make openbas-down
	@echo "Hard deleting all databases..."
	@rm -rf $(PERSISTENT_VOLUMES_DIR)/*
	@echo "Cleaning Docker (prune af)..."
	@docker system prune -af
