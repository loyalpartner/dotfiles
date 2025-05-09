# Debugging Settings

# Disable debuginfod
set debuginfod enabled off

# Skip patterns for common libraries and functions
skip -rfu '^(absl|std|std::Cr)(::[a-zA-z0-9_]+)+'
skip -rfu '([a-zA-z0-9_]+)::\1'
skip -rfu 'operator.*'
skip -gfi 'base/allocator/*.h'

# Default to Intel syntax for x86 assembly
set disassembly-flavor intel
