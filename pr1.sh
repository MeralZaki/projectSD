#!/bin/bash
# Movies currently showing stored in a file
MOVIE_FILE="movies.txt"

# Showtimes stored in another file
SHOWTIMES_FILE="showtimes.txt"

# Bookings stored in another file
BOOKINGS_FILE="bookings.txt"
# Function to display all movies from movies.txt
function show_movies() {
    if [ -f "$MOVIE_FILE" ]; then
        cat "$MOVIE_FILE"
    else
        echo "No movies currently showing."
    fi
}
