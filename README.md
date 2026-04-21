# Database Management System using Bash Script

## Overview
A lightweight Database Management System (DBMS) implemented using Bash scripting on Linux.
The project simulates core database functionalities such as creating databases, managing tables, and performing basic data operations through a command-line interface.

## Features
- Create and list databases
- Connect to a database
- Create tables with defined schema
- Insert records
- Select data
- Delete records
- Drop tables and databases

## Technologies
- Bash Scripting
- Linux CLI

## Project Structure
```
.
├── main.sh
├── db/
│   ├── <database_name>/
│   │   ├── <table_name>
│   │   └── <table_name>.meta
└── README.md
```

## How It Works
- Each database is represented as a directory
- Each table is stored as a file
- Table structure is stored in a `.meta` file
- Data is managed using Bash scripts and standard Linux utilities

## Getting Started

### Prerequisites
- Linux environment
- Bash shell

### Run
```bash
chmod +x main.sh
./main.sh
```

## Future Improvements
- Add update functionality
- Improve validation and error handling
- Support advanced queries
- Add logging

## Author
Nabil Ayman  
DevOps Engineer