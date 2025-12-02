using Genie, Genie.Router, Genie.Renderer.Json, Genie.Requests
using JSON3

# In-memory todo storage
mutable struct Todo
    id::Int
    name::String
    isComplete::Bool
end

const TODOS = Todo[
    Todo(1, "Learn Julia", false),
    Todo(2, "Build Genie app", false)
]
const NEXT_ID = Ref(3)

# Helper to convert Todo to Dict
todo_to_dict(t::Todo) = Dict("id" => t.id, "name" => t.name, "isComplete" => t.isComplete)

# Routes
route("/") do
    json(Dict(
        "message" => "Welcome to Genie.jl Todo API!",
        "endpoints" => Dict(
            "GET /api/todos" => "Get all todos",
            "GET /api/todos/:id" => "Get todo by ID",
            "POST /api/todos" => "Create a todo",
            "PUT /api/todos/:id" => "Update a todo",
            "DELETE /api/todos/:id" => "Delete a todo"
        )
    ))
end

# GET all todos
route("/api/todos", method=GET) do
    json(map(todo_to_dict, TODOS))
end

# GET todo by ID
route("/api/todos/:id", method=GET) do
    id = parse(Int, params(:id))
    idx = findfirst(t -> t.id == id, TODOS)
    
    if isnothing(idx)
        Genie.Renderer.respond(json(Dict("error" => "Not found")), 404)
    else
        json(todo_to_dict(TODOS[idx]))
    end
end

# POST create todo
route("/api/todos", method=POST) do
    payload = jsonpayload()
    
    name = get(payload, "name", "")
    isComplete = get(payload, "isComplete", false)
    
    if isempty(name)
        Genie.Renderer.respond(json(Dict("error" => "Name is required")), 400)
    else
        todo = Todo(NEXT_ID[], name, isComplete)
        NEXT_ID[] += 1
        push!(TODOS, todo)
        Genie.Renderer.respond(json(todo_to_dict(todo)), 201)
    end
end

# PUT update todo
route("/api/todos/:id", method=PUT) do
    id = parse(Int, params(:id))
    idx = findfirst(t -> t.id == id, TODOS)
    
    if isnothing(idx)
        Genie.Renderer.respond(json(Dict("error" => "Not found")), 404)
    else
        payload = jsonpayload()
        
        if haskey(payload, "name")
            TODOS[idx].name = payload["name"]
        end
        if haskey(payload, "isComplete")
            TODOS[idx].isComplete = payload["isComplete"]
        end
        
        Genie.Renderer.respond(json(Dict("message" => "Updated")), 200)
    end
end

# DELETE todo
route("/api/todos/:id", method=DELETE) do
    id = parse(Int, params(:id))
    idx = findfirst(t -> t.id == id, TODOS)
    
    if isnothing(idx)
        Genie.Renderer.respond(json(Dict("error" => "Not found")), 404)
    else
        deleteat!(TODOS, idx)
        Genie.Renderer.respond(json(Dict("message" => "Deleted")), 200)
    end
end
