# EPUB Kit

A monorepo containing reusable EPUB reader packages for Flutter applications.

## Packages

### 📖 [epub_viewer](./packages/epub_viewer)
Core EPUB viewer package with reading functionality, bookmarks, history, and search support.

### 🔖 [epub_bookmarks](./packages/epub_bookmarks)
Bookmark and history management screens for EPUB readers.

### 🔍 epub_search
Full-text search functionality across EPUB books (coming soon).

## Installation

Each package can be installed independently or together.

### 1. Using Only `epub_viewer`

```yaml
dependencies:
  epub_viewer:
    git:
      url: https://github.com/Amorphteam/ketub_reader.git
      ref: epub_viewer-v0.1.0  # or latest tag
      path: packages/epub_viewer
```

### 2. Using Only `epub_bookmarks`

```yaml
dependencies:
  epub_bookmarks:
    git:
      url: https://github.com/Amorphteam/ketub_reader.git
      ref: epub_bookmarks-v0.1.0  # or latest tag
      path: packages/epub_bookmarks
```

### 3. Using Both Packages

```yaml
dependencies:
  epub_viewer:
    git:
      url: https://github.com/Amorphteam/ketub_reader.git
      ref: epub_viewer-v0.1.0
      path: packages/epub_viewer
  
  epub_bookmarks:
    git:
      url: https://github.com/Amorphteam/ketub_reader.git
      ref: epub_bookmarks-v0.1.0
      path: packages/epub_bookmarks
```

See [USAGE_EXAMPLES.md](./USAGE_EXAMPLES.md) for detailed implementation examples.

## Development

This is a monorepo containing multiple packages. Each package is located in the `packages/` directory.

### Structure
```
packages/
  ├── epub_viewer/      # Core viewer package
  ├── epub_bookmarks/   # Bookmarks package (coming soon)
  └── epub_search/      # Search package (coming soon)
```

## Versioning

Each package is versioned independently. Git tags follow the format:
- `epub_viewer-v<version>`
- `epub_bookmarks-v<version>`
- `epub_search-v<version>`

## License

[Add your license here]

