#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

# Get the directory to run the script in, default to the current directory.
DIR=${1:-$(pwd)}

# Change to the specified directory.
cd "$DIR"

# Function to sort package imports by length in descending order
sort_imports() {
    local file=$1
    # Separate imports from the rest of the code
    local imports=$(grep -E '^import.*;' "$file")
    local rest=$(grep -Ev '^import.*;' "$file")

    # Sort imports by length in descending order and merge with the rest of the code
    {
        echo "$imports" | awk '{ print length, $0 }' | sort -nr | cut -d" " -f2-
        echo "$rest"
    } > "$file.sorted"

    # Replace the original file with the sorted one
    mv "$file.sorted" "$file"
}

# Find all Dart files and sort their imports
find . -name "*.dart" -print0 | while IFS= read -r -d '' file; do
    echo "Sorting imports in $file..."
    sort_imports "$file"
done

# Format all Dart files
echo "Formatting Dart files..."
find . -name "*.dart" -print0 | xargs -0 dart format

# Run dart fix with specific codes.
echo "Applying Dart fixes..."
dart fix --apply --code=unused_import \
                  --code=dead_code \
                  --code=unused_field \
                  --code=avoid_catches_without_on_clauses \
                  --code=avoid_print \
                  --code=lines_longer_than_80_chars \
                  --code=unnecessary_this \
                  --code=invalid_null_aware_operator \
                  --code=unnecessary_import \
                  --code=use_build_context_synchronously \
                  --code=prefer_const_constructors \
                  --code=avoid_redundant_argument_values \
                  --code=unnecessary_string_interpolations \
                  --code=sort_child_properties_last \
                  --code=always_use_package_imports

# Check for remaining issues.
echo "Analyzing remaining issues..."
dart analyze || true  # Continue execution even if there are issues.

# Output the remaining issues.
echo "Manual fixes required for the following issues:"
dart analyze | grep -E 'warning|info' | while read -r line ; do
    echo "$line"
done

echo "Summary of manual fixes needed:"
echo "1. Unused local variables or fields: Remove or use the variable/field."
echo "2. Avoid prints: Use a logging framework instead of print statements."
echo "3. Catch clauses: Use 'on' to specify the type of exception being caught."
echo "4. Use 'BuildContext's synchronously: Ensure context is valid when used."
echo "5. Follow naming conventions: Use lowerCamelCase for variables and file names."
echo "6. Avoid redundant arguments: Remove arguments that match default values."
echo "7. Const constructors: Use 'const' with constructors to improve performance."

echo "Fixes applied successfully. Please review any remaining issues manually."
