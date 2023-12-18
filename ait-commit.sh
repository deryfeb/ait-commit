#!/bin/bash

# Function to validate the commit type
validate_type() {
    local type=$1
    case "$type" in
        feat|fix|build|chore|docs|refactor|perf|style|test)
            return 0
            ;;
        *)
            echo "Invalid type. Must be one of: feat, fix, build, chore, docs, refactor, perf, style, test."
            return 1
            ;;
    esac
}

# Function to validate the commit subject
validate_subject() {
    local subject=$1
    if [[ ! $subject ]]; then
        echo "Subject is mandatory."
        return 1
    fi
    if [[ ${#subject} -gt 50 ]]; then
        echo "Subject too long (maximum 50 characters)."
        return 1
    fi
    return 0
}

echo "Enter commit type (feat|fix|build|chore|docs|refactor|perf|style|test):"
read commit_type
validate_type $commit_type || exit 1

echo "Enter scope (optional, lowercase with dash as separator):"
read commit_scope

echo "Enter subject (mandatory, max 50 chars):"
read commit_subject
validate_subject "$commit_subject" || exit 1

echo "Enter body (optional, press CTRL+D when done):"
commit_body=$(cat)

# Formatting commit message
commit_msg="${commit_type}"
if [[ $commit_scope ]]; then
    commit_msg="${commit_msg}(${commit_scope})"
fi
commit_msg="${commit_msg}: ${commit_subject}"

if [[ $commit_body ]]; then
    commit_msg="${commit_msg}\n\n${commit_body}"
fi

# Execute git commit
git commit -m "$commit_msg"

