
!/bin/bash
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

# Function to check available seats for a showtime
function check_available_seats() {
movie_title="$1"
showtime="$2"

if grep -q "$movie_title - $showtime" "$BOOKINGS_FILE"; then
booked_seats=$(grep "$movie_title - $showtime" "$BOOKINGS_FILE" | awk -F, '{print $5}' |
tr '\n' ' ')
echo "Booked seats for '$movie_title' at '$showtime': $booked_seats"
else
echo "No seats booked yet for '$movie_title' at '$showtime'."
fi
}
# Function to book a ticket
function book_ticket() {
read -p "Enter your name: " name
read -p "Enter your ID: " id
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

# Check available seats
check_available_seats "$movie_title" "$showtime"

read -p "Enter seat number: " seat

# Check if the seat is already booked
if grep -q "$movie_title - $showtime" "$BOOKINGS_FILE" && grep "$movie_title -
$showtime" "$BOOKINGS_FILE" | grep -q ", $seat$"; then
echo "Error: Seat '$seat' is already booked."
return 1
fi

# Process payment
read -p "Enter payment amount: " payment
read -p "Enter payment method (credit card, cash, etc.): " payment_method

# Append booking information to bookings file
echo "$name, $id, $movie_title - $showtime, $seat, $payment, $payment_method" >>
"$BOOKINGS_FILE"
echo "Ticket booked for '$movie_title' at '$showtime', seat '$seat'. Payment: $payment using
$payment_method." 
}

# Function to delete a booking
function delete_booking() {
    read -p "Enter your name: " name
    read -p "Enter your ID: " id
    read -p "Enter the movie title: " movie_title
    read -p "Enter the showtime: " showtime
    read -p "Enter seat number: " seat

    # Construct the booking entry
    booking_entry="$name, $id, $movie_title - $showtime, $seat"
    
    # Check if the booking exists
    if grep -qF "$booking_entry" "$BOOKINGS_FILE"; then
        # Delete the booking
        sed -i "\|$booking_entry|d" "$BOOKINGS_FILE"
        echo "Booking deleted for '$movie_title' at '$showtime', seat '$seat'."
    else
        echo "Error: Booking not found."
    fi
}

# Menu function 
function show_menu() { 
    while true; do 
        echo "Cinema Management Menu" 
        echo "1. Show all movies" 
        echo "2. Show showtimes for a movie" 
        echo "3. Book a ticket" 
        echo "4. Delete a booking" 
        echo "5. Exit" 
        read -p "Please choose an option (1-5): " choice 
 
        case $choice in 
            1) 
                show_movies 
                ;; 
            2) 
                read -p "Enter the movie title: "     movie_titleshow_showtimes "$movie_title" 
                ;; 
            3) 
                book_ticket 
                ;; 
            4) 
                delete_booking 
                ;; 
            5) 
                echo "Exiting the menu." 
                break 
                ;; 
            *) 
                echo "Invalid option. Please choose 1, 2, 3, 4, or 5." 
                ;; 
        esac 
        echo "" 
    done 
} 
 
# Display the menu 
show_menu
