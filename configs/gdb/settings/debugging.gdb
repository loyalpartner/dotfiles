# Debugging Settings

# Disable debuginfod
set debuginfod enabled off

# Skip patterns for common libraries and functions
skip -rfu '^(absl|std|std::Cr)(::[a-zA-z0-9_]+)+'  # Skip standard library internals
skip -rfu '([a-zA-z0-9_]+)::\1'                     # Skip constructors
skip -rfu 'operator.*'                              # Skip operators
skip -gfi 'base/allocator/*.h'                      # Skip allocator implementation

# Default to Intel syntax for x86 assembly
set disassembly-flavor intel