# Tests Dogs API

This directory contain all test for Dogs API with RSpec.

## Configuration

### Prerequisites

1. **Ruby** (version 2.7 o higher)
2. **Bundler** to improve dependencies
3. **Docker** to run dogs API

### Install

1. Install depedencies:

```bash
bundle install
```

2. Make sure API is running:

```bash
docker build -t exercise:1.0 .

docker run --name demo -it -p 5000:5000 exercise:1.0
```

## Run test

### Run all test

```bash
bundle exec rspec
```

### Run specific test

```bash
bundle exec rspec spec/api/dogs_spec.rb -e "POST /dogs"

bundle exec rspec spec/api/dogs_spec.rb -e "GET /dogs/:id"
```

### Run with format

```bash
bundle exec rspec --format documentation
```

## Endpoints tested

- `POST /dogs` - Create a new dog
- `GET /dogs/:id` - Get a dog
- `DELETE /dogs/:id` - Delete a dog
- `GET /dogs` - Get all dogs
- Method Not Allowed

## WebMock Configuration

Test are setup to allows requests really to local API (`127.0.0.1:5000`).

## Test data

The tests use the `Faker` library to generate test data.

## Troubleshooting

### Error: "Connection refused"

- Make sure of API it running in Docker
- Check that port 5000 is available

### Error: "Gem not found"

- Run `bundle install` to install dependencies

### Tests failed

- Check that API is response successfully
- Check container Docker logs

## API Improvements

Based on the testing and analysis of the Python API, here are the identified issues and potential improvements:

### Critical Issues Found

| Issue | Description | Impact | Recommended Fix |
|-------|-------------|---------|-----------------|
| **Boolean Validation Bug** | `check_payload` returns `false` (lowercase) instead of `False` (Python boolean) | High | Fix the boolean return value in validation logic |
| **Root Endpoint Behavior** | `/` accepts POST and returns 200 with "This shouldn't have succeeded" message | Medium | Remove POST method from root endpoint or implement proper behavior |
| **Trailing Slash Redirect** | `/dogs` redirects 308 to `/dogs/` | Low | Document this behavior or normalize endpoints |
| **Method Not Allowed** | Some endpoints return 405 for unsupported methods | Low | Document supported methods or implement proper error handling |

### Architecture & Performance Issues

| Issue | Description | Impact | Recommended Fix |
|-------|-------------|---------|-----------------|
| **Concurrency Issues** | `data_store` is an in-memory dict without locking | High | Use database |
| **Data Persistence** | Data is volatile and lost on container restart | High | Implement persistent storage (database/file system) |
| **No Input Validation** | Limited validation on dog data (age, breed, name) | Medium | Add comprehensive input validation |
| **No Error Handling** | Minimal error handling for edge cases | Medium | Implement proper error handling and logging |

### API Design Improvements

| Issue | Description | Impact | Recommended Fix |
|-------|-------------|---------|-----------------|
| **Inconsistent Response Format** | Mix of JSON and HTML responses | High | Standardize all responses to JSON format |
| **No API Versioning** | No version control for API endpoints | Low | Implement API versioning (e.g., `/v1/dogs`) |
| **Missing Documentation** | No API documentation or OpenAPI/Swagger specs | Low | Add comprehensive API documentation |

### Security & Best Practices

| Issue | Description | Impact | Recommended Fix |
|-------|-------------|---------|-----------------|
| **No Rate Limiting** | No protection against abuse | Medium | Implement rate limiting |
| **No Authentication** | No authentication or authorization | Medium | Add authentication system if needed |
| **No CORS Configuration** | No Cross-Origin Resource Sharing setup | Low | Configure CORS for web applications |

### Testing & Quality Assurance

| Issue | Description | Impact | Recommended Fix |
|-------|-------------|---------|-----------------|
| **No Health Check Endpoint** | No way to verify API health | Medium | Add `/health` or `/status` endpoint |

### Recommended Implementation Priority

1. **High Priority** (Fix immediately):
   - Boolean validation bug
   - Concurrency issues
   - Data persistence
   - Input validation

2. **Medium Priority** (Next sprint):
   - Standardize response format
   - Implement proper HTTP status codes
   - Add error handling

3. **Low Priority** (Future releases):
   - API versioning
   - Documentation
   - Security features
