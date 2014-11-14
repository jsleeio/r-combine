# r-combine

Combines resistor values you have to (hopefully) obtain resistance
values you don't have, by combining them in parallel pairs.

## Input data

Put a list of values you DO have in a stock file called
`r-combine.stock`. KMGT SI suffixes are accepted. Decimal values are
currently not, so write `7500` instead of `7.5k`. Yes, this sucks.

    10
    100
    1k
    10k
    100k
    1m

## Usage

Just pass the values you want to find combinations for on the
commandline. For example:

    $ perl r-combine.pl 910 1k 5k 9100 91000 | grep -v reject
    r-desired 910 candidate r1 1k r2 10k result 909
    r-desired 910 candidate r1 10k r2 1k result 909
    r-desired 1000 exact match found in stock
    r-desired 5000 candidate r1 10k r2 10k result 5000
    r-desired 9100 candidate r1 10k r2 100k result 9090
    r-desired 9100 candidate r1 100k r2 10k result 9090
    r-desired 91000 candidate r1 100k r2 1m result 90909
    r-desired 91000 candidate r1 1m r2 100k result 90909

## Bugs/ideas

All entirely fixable/possible but I am lazy and this works enough for my purposes.

* each candidate is shown twice
* decimal stock entries (eg. 7.5k) don't work, use eg. 7500 instead
* option to disable showing rejects
* option to use a whole E12/24/48/96 series instead of a stock file
