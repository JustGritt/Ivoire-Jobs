#!/bin/bash

cd ../
find . -name "*.dart" -print0 | xargs -0 dart format

# Run dart fix 
dart fix --apply --code=unused_import --code=dead_code --code=unused_field --code=avoid_catches_without_on_clauses --code=avoid_print --code=lines_longer_than_80_chars

# Check for remaining issues
echo "Check remaining issues.."
dart analyze

echo "Fixes applied successfully"