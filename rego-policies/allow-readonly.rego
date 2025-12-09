package myapp.auth

# Default deny
default allow_readonly = false

# Allow user if role is read-only
allow_readonly {
    input.role == "readonly"
}
