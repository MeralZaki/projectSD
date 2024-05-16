#!/bin/bash

# Movies currently showing (stored in a file)
MOVIE_FILE="movies.txt"

# Showtimes (stored in another file)
SHOWTIMES_FILE="showtimes.txt"

# Bookings (stored in another file)
BOOKINGS_FILE="bookings.txt"

# Function to display all movies
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

# Function to book a ticket
function book_ticket() {
    read -p "Enter the movie title: " movie_title
    read -p "Enter the showtime: " showtime
    
    # Check if the movie exists
    if ! grep -q "^$movie_title$" "$MOVIE_FILE"; then
        echo "Error: Movie '$movie_title' not found."
        return 1
    fi
    
    # Check if the showtime exists for the movie
    if ! grep -q "$movie_title - $showtime" "$SHOWTIMES_FILE"; then
        echo "Error: Showtime '$showtime' for movie '$movie_title' not found."
        return 1
    fi
    
    # Append booking information to bookings file
    echo "$movie_title - $showtime" >> "$BOOKINGS_FILE"
    echo "Ticket booked for '$movie_title' at '$showtime'."
}

# Menu function
function show_menu() {
    while true; do
        echo "Cinema Management Menu"
        echo "1. Show all movies"
        echo "2. Show showtimes for a movie"
        echo "3. Book a ticket"
        echo "4. Exit"
        read -p "Please choose an option (1-4): " choice

        case $choice in
            1)
                show_movies
                ;;
            2)
                read -p "Enter the movie title: " movie_title
                show_showtimes "$movie_title"
                ;;
            3)
                book_ticket
                ;;
            4)
                echo "Exiting the menu."
                break
                ;;
            *)
                echo "Invalid option. Please choose 1, 2, 3, or 4."
                ;;
        esac
        echo ""
    done
}

# Display the menu
show_menu

