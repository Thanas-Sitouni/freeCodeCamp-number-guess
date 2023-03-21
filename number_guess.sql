create database NumberGuess;

create table users (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(22) NOT NULL,
    games_played INT NOT NULL,
    best_game INT NOT NULL
);
