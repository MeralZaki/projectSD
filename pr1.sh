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
# Function to display showtimes for a movie
function show_showtimes() {
    if [ $# -eq 0 ]; then
        echo "Usage: show_showtimes <movie_title>"
        return 1
    fi

    movie_title="$1"
    showtimes=$(grep "$movie_title" "$SHOWTIMES_FILE")
    if [ -n "$showtimes" ]; then
        echo "Showtimes for '$movie_title':"
        echo "$showtimes"
    else
        echo "No showtimes found for '$movie_title'."
    fi
}

