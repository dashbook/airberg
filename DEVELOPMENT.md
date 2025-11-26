# Development Guide

## Debugging Connectors

When troubleshooting connector issues, you can enable detailed debug logging by setting the `RUST_LOG` environment variable to `debug`.

### Example: Debugging PostgreSQL Source

```bash
docker run --rm -it \
  -v .:/tmp/config \
  -e RUST_LOG=debug \
  -e POSTGRES_PASSWORD=postgres \
  dashbook/source-postgres:sql
```

