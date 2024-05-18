l
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
$payment_method." }
#l
