# CodeSmoker Test: Julia Genie.jl (#18)

A test repository for the CodeSmoker test suite demonstrating a Julia Genie.jl web application.

## Project Structure

```
├── app.jl                # Main application module
├── routes.jl             # API route definitions
├── bootstrap.jl          # Bootstrap script
├── bin/
│   └── server.jl         # Server startup script
├── config/
│   └── settings.jl       # Configuration
└── Project.toml          # Julia dependencies
```

## Features

- **Genie.jl Framework**: High-performance Julia web framework
- **RESTful API**: Full CRUD operations for todos
- **In-memory Storage**: Simple mutable struct storage
- **JSON API**: Clean JSON request/response handling

## API Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/` | API information |
| GET | `/api/todos` | Get all todos |
| GET | `/api/todos/:id` | Get todo by ID |
| POST | `/api/todos` | Create a new todo |
| PUT | `/api/todos/:id` | Update a todo |
| DELETE | `/api/todos/:id` | Delete a todo |

## Getting Started

### Prerequisites

- Julia >= 1.9

### Installation

```julia
# Start Julia REPL
julia

# Activate project and install dependencies
using Pkg
Pkg.activate(".")
Pkg.instantiate()
```

### Run the Server

```julia
using GenieFramework
Genie.loadapp()
up()  # Server runs at http://localhost:8000
```

Or use the bootstrap script:

```bash
julia bootstrap.jl
```

### Test the API

```bash
# Get all todos
curl http://localhost:8000/api/todos

# Create a todo
curl -X POST http://localhost:8000/api/todos \
  -H "Content-Type: application/json" \
  -d '{"name":"New Task"}'
```

## Documentation

Built using latest documentation from:
- [Genie Framework](https://learn.genieframework.com) - Genie.jl documentation

---

*This is a CodeSmoker test repository*
