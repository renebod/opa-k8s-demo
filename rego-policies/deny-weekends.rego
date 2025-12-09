package myapp.auth

# Default allow
default deny_weekends = false

# Deny if today is Saturday or Sunday
deny_weekends {
    t := time.now_ns() / 1000000000
    day := time.weekday(t)
    day == "Saturday" or day == "Sunday"
}
