#!/bin/bash

# Movies currently showing (stored in a file)
MOVIE_FILE="movies.txt"

# Showtimes (stored in another file)
SHOWTIMES_FILE="showtimes.txt"

# Function to display all movies
function show_movies() {
    if [ -f "$MOVIE_FILE" ]; then
        cat "$MOVIE_FILE"
    else
        echo "No movies currently showing."
    fi
}

# Function to add a movie
function add_movie() {
    if [ $# -eq 0 ]; then
        echo "Usage: add_movie <movie_title>"
        return 1
    fi
    movie_title="$1"
    echo "$movie_title" >> "$MOVIE_FILE"
    echo "Movie '$movie_title' added."
}

# Function to remove a movie
function remove_movie() {
    if [ $# -eq 0 ]; then
        echo "Usage: remove_movie <movie_title>"
        return 1
    fi

    movie_title="$1"
    temp_file="temp.txt"

    # Filter out the movie title from the movies file
    grep -v "^$movie_title" "$MOVIE_FILE" > "$temp_file"
    mv "$temp_file" "$MOVIE_FILE"

    # Remove associated showtimes (basic implementation)
    grep -v "$movie_title" "$SHOWTIMES_FILE" > "$temp_file"
    mv "$temp_file" "$SHOWTIMES_FILE"

    echo "Movie '$movie_title' removed."
}

# Function to add a showtime
function add_showtime() {
    if [ $# -lt 2 ]; then
        echo "Usage: add_showtime <movie_title> <showtime>"
        return 1
    fi
    movie_title="$1"
    showtime="$2"

    # Simple check if movie exists (improve in future versions)
    if grep -q "$movie_title" "$MOVIE_FILE"; then
        echo "$movie_title - $showtime" >> "$SHOWTIMES_FILE"
        echo "Showtime added for '$movie_title': $showtime"
    else
        echo "Error: Movie '$movie_title' not found."
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

# Display help message
if [ $# -eq 0 ]; then
    echo "Cinema Management Script"
    echo "Usage:"
    echo "  show_movies - List all movies"
    echo "  add_movie <title> - Add a new movie"
    echo "  remove_movie <title> - Remove a movie"
    echo "  add_showtime <title> <time> - Add a showtime"
    echo "  show_showtimes <title> - List showtimes for a movie"
    exit 0
fi

# Call the specific function based on the first argument
case $1 in
    show_movies) show_movies ;;
    add_movie) add_movie "$2" ;;
    remove_movie) remove_movie "$2" ;;
    add_showtime) add_showtime "$2" "$3" ;;
    show_showtimes) show_showtimes "$2" ;;
    *) echo "Invalid command. Use 'help' for usage information." ;;
esac

