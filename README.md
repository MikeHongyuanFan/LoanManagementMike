# Loan Management System

This repository contains a Frappe-based Loan Management System built using Docker. It integrates the Frappe Framework, ERPNext, and the Lending application to provide a comprehensive solution for managing loans and lending operations.

## Features

- **Loan Application Processing**: Create and manage loan applications
- **Loan Management**: Track loans throughout their lifecycle
- **Repayment Scheduling**: Generate and manage repayment schedules
- **Interest Calculation**: Automatic interest calculation based on various methods
- **Loan Security Management**: Track securities against loans
- **Loan Write-off Handling**: Process for writing off loans
- **Reporting and Analytics**: Comprehensive reporting for loan portfolios

## Setup Instructions

### Prerequisites
- Docker
- Docker Compose
- Git

### Installation

1. Clone this repository:
   ```
   git clone https://github.com/MikeHongyuanFan/LoanManagementMike.git
   cd LoanManagementMike
   ```

2. Start the Docker containers:
   ```
   docker compose -f pwd.yml up -d
   ```

3. After a few minutes, access the application at:
   ```
   http://localhost:8080
   ```

4. Login with the default credentials:
   - Username: Administrator
   - Password: admin

## Architecture

This project uses a multi-container Docker setup with the following components:

- **MariaDB**: Database server
- **Redis**: Cache and queue server
- **Frappe Backend**: Application server
- **Nginx**: Web server
- **Workers**: Background task processing
- **Scheduler**: Scheduled tasks execution

## Development

To make changes to the Lending application:

1. Connect to the backend container:
   ```
   docker exec -it frappe_docker-backend-1 bash
   ```

2. Navigate to the lending app directory:
   ```
   cd /home/frappe/frappe-bench/apps/lending
   ```

3. Make your changes and restart the services:
   ```
   bench restart
   ```

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgements

- [Frappe Framework](https://frappeframework.com/)
- [ERPNext](https://erpnext.com/)
- [Frappe Lending](https://github.com/frappe/lending)
