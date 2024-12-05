# OpenBAS Docker Compose Workplace

This repository provides a streamlined Docker Compose architecture to quickly set up and manage an instance of [OpenBAS](https://www.filigran.io/). The provided `Makefile` automates installation, setup, and management tasks, making it easy to deploy and maintain your Breach and Attack Simulation platform.

---

## What is OpenBAS?

[OpenBAS](https://www.filigran.io/) (Open Breach and Attack Simulation) is an open-source platform designed to simulate cyber threats and assess the effectiveness of an organization’s security controls. By replicating real-world attack techniques, OpenBAS enables organizations to identify weaknesses in their security posture and optimize their defenses.

---

## Project Structure

The project is structured to separate services, collectors, and environment files for easier management:

- **`services/`**: Contains Docker Compose YAML files for core OpenBAS services (e.g., PostgreSQL, MinIO, RabbitMQ, Elasticsearch, etc.).
- **`collectors/`**: Contains Docker Compose YAML files for various OpenBAS collectors.
- **`envs/`**: Stores `.env` files to configure services and collectors.

---

## Setup and Usage

### Prerequisites
- Docker and Docker Compose installed on your system.
- Basic understanding of Makefiles and Docker Compose.
- Sufficient disk space for persistent volumes and databases.

### Commands Overview

The `Makefile` simplifies the management of the OpenBAS instance. Below is an explanation of each command:

1. **Install OpenBAS**
   Initializes persistent volumes and generates necessary UUIDs for configuration files.
   ```bash
   make openbas-install
   ```

2. **Up OpenBAS**
   Builds the `.env` file from `envs/` and starts OpenBAS services and collectors in Docker.
   ```bash
   make openbas-up
   ```

3. **Down OpenBAS**
   Stops all running containers and removes associated volumes.
   ```bash
   make openbas-down
   ```

4. **View Logs**
   Displays the logs of all running containers.
   ```bash
   make openbas-logs
   ```

5. **Remove OpenBAS**  
   Stops all containers, removes persistent volumes, and performs a complete Docker system prune.  
   ```bash
   make openbas-docker-prune
   ```

---

## Description of Collectors

The collectors enable OpenBAS to ingest and utilize various datasets for attack simulations and security assessments. Below is a list of available collectors and their purposes:

1. **Atomic Red Team Collector**  
   Retrieves and integrates simulated attack techniques from the Atomic Red Team framework.

2. **MITRE ATT&CK Collector**  
   Ingests datasets from MITRE ATT&CK, including adversary tactics and techniques.

---

## Services Overview

Core services required for OpenBAS to function:

- **PostgreSQL**: Database backend for storing configuration and simulation results.
- **MinIO**: Object storage for OpenBAS-related data.
- **RabbitMQ**: Message broker for inter-service communication.
- **Elasticsearch**: Provides a powerful search and analytics engine for simulation data.
- **OpenBAS Core**: The main application backend for managing simulations.
- **Nginx**: Reverse proxy to route traffic to OpenBAS services.

---

## Persistent Volumes

All databases and services use a persistent storage directory located in `./openbas_persistent_volumes`. This directory ensures data durability across container restarts.

- **S3 Data**: Persistent storage for MinIO.
- **Redis Data**: Cache persistence.
- **AMQP Data**: RabbitMQ queue persistence.
- **ES Data**: Elasticsearch data store.

---

## How to Contribute

Contributions are welcome! If you'd like to improve the project or add new collectors:
1. Fork this repository.
2. Create a new branch for your changes.
3. Submit a pull request with detailed explanations.

---

## License

This project is licensed under the [MIT License](LICENSE).

---

Feel free to reach out for questions or suggestions. Enjoy using OpenBAS! 🚀
