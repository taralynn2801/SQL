/*link to dataset:https://www.kaggle.com/datasets/equinxx/spotify-top-50-songs-in-2021?select=spotify_top50_2021.csv */

CREATE TABLE BIT_DB.Spotifydata (
id integer PRIMARY KEY,
artist_name varchar NOT NULL,
track_name varchar NOT NULL,
track_id varchar NOT NULL,
popularity integer NOT NULL,
danceability decimal(4,3) NOT NULL,
energy decimal(4,3) NOT NULL,
song_key integer NOT NULL,
loudness decimal(5,3) NOT NULL,
song_mode integer NOT NULL,
speechiness decimal(5,4) NOT NULL,
acousticness decimal(6,5) NOT NULL,
instrumentalness decimal(8,7) NOT NULL,
liveness decimal(5,4) NOT NULL,
valence decimal(4,3) NOT NULL,
tempo decimal(6,3) NOT NULL,
duration_ms integer NOT NULL,
time_signature integer NOT NULL )


SELECT * FROM BIT_DB.Spotifydata


/*What is the most popular song streamed on spotify in 2021?*/
select track_name as Song, artist_name as Artist, popularity
from Spotifydata
order by popularity desc
LIMIT 1



/*Calculate the average popularity for the artists in the Spotify data table. Then, for every artist with an average
popularity of 90 or above, show their name, their average popularity, and label them as a “Top Star”.*/
WITH popularity_average_CTE AS (
SELECT s.artist_name,
AVG(s.popularity) AS average_popularity
FROM SpotifyData s 
GROUP BY s.artist_name
)

SELECT  artist_name,
        average_popularity,
        'Top Star' AS tag
FROM popularity_average_CTE
WHERE average_popularity>=90;
