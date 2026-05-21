foreach ($number in 1..30) {
    if ($number % 15 -eq 0) {
        "FizzBuzz"
    }
    elseif ($number % 3 -eq 0) {
        "Fizz"
    }
    elseif ($number % 5 -eq 0) {
        "Buzz"
    }
    else {
        $number
    }
}
