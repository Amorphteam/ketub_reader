# EPUB Kit

A monorepo containing reusable EPUB reader packages for Flutter applications.

## Packages

### 📖 [epub_viewer](./packages/epub_viewer)
Core EPUB viewer package with reading functionality, bookmarks, history, and search support.

### 🔖 [epub_bookmarks](./packages/epub_bookmarks)
Bookmark and history management screens for EPUB readers.

### 🔍 [epub_search](./packages/epub_search)
Full-text search functionality across EPUB books with dedicated UI.

## Installation

Each package can be installed independently or together.

### 1. Using Only `epub_viewer`

```yaml
dependencies:
  epub_viewer:
    git:
      url: https://github.com/Amorphteam/ketub_reader.git
      ref: v0.0.1-beta  # shared repo tag; run `git tag` to confirm latest
      path: packages/epub_viewer
```

### 2. Using Only `epub_bookmarks`

```yaml
dependencies:
  epub_bookmarks:
    git:
      url: https://github.com/Amorphteam/ketub_reader.git
      ref: v0.0.1-beta
      path: packages/epub_bookmarks
```

### 3. Using Both Packages

```yaml
dependencies:
  epub_viewer:
    git:
      url: https://github.com/Amorphteam/ketub_reader.git
      ref: v0.0.1-beta
      path: packages/epub_viewer
  
  epub_bookmarks:
    git:
      url: https://github.com/Amorphteam/ketub_reader.git
      ref: v0.0.1-beta
      path: packages/epub_bookmarks
```

### 4. Using Only `epub_search`

```yaml
dependencies:
  epub_search:
    git:
      url: https://github.com/Amorphteam/ketub_reader.git
      ref: v0.0.1-beta
      path: packages/epub_search
```

See [USAGE_EXAMPLES.md](./USAGE_EXAMPLES.md) for detailed implementation examples.

## Development

This is a monorepo containing multiple packages. Each package is located in the `packages/` directory.

### Structure
```
packages/
  ├── epub_viewer/      # Core viewer package
  ├── epub_bookmarks/   # Bookmarks package
  └── epub_search/      # Search package
```

## Versioning

Each package is versioned independently. The repository currently ships a shared release tag (e.g., `v0.0.1-beta`) that works for every package path. When package-specific tags (like `epub_viewer-v<version>`) are published, prefer those for finer control.

Check available tags with:

```bash
git ls-remote --tags https://github.com/Amorphteam/ketub_reader.git
```

## License

[Add your license here]

