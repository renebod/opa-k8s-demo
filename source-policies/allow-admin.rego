package myapp.auth

# Default deny
default allow = false

# Allow only admin user
allow {
    input.user == "admin"
}
