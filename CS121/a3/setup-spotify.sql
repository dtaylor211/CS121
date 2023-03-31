-- [Problem 1]

DROP TABLE IF EXISTS tracks;

DROP TABLE IF EXISTS artists;
DROP TABLE IF EXISTS albums;
DROP TABLE IF EXISTS playlists;

-- artists: table containing information about a specific artist
CREATE TABLE artists (
    -- identifier of the artist, set length of 22 characters
    artist_uri CHAR(22) NOT NULL,
    -- name of the artist, varying length up to 250 characters
    artist_name VARCHAR(250) NOT NULL,
    -- primary key of artists is the artist uri
    PRIMARY KEY (artist_uri)
);

-- albums: table containing information about a specific album
CREATE TABLE albums (
    -- identifier of the album, set length of 22 characters
    album_uri CHAR(22) NOT NULL,
    -- name of the album, varying length up to 250 characters
    album_name VARCHAR(25) NOT NULL,
    -- date album was released, stored as TIMESTAMP
    release_date TIMESTAMP NOT NULL,
    -- primary key of albums is the album uri
    PRIMARY KEY (album_uri)
);

-- playlists: table containing information about a specific playlist 
CREATE TABLE playlists (
    -- identifier for the playlist, set length of 22 characters
    playlist_uri CHAR(22) NOT NULL,
    -- name of the playlist, varying length set up to 250 characters
    playlist_name VARCHAR(250) NOT NULL,
    -- primary key of playlists is the playlist uri
    PRIMARY KEY (playlist_uri)
);

-- tracks: table containing information about a specific track
CREATE TABLE tracks (
    -- identifier for the track, set length of 22 characters
    track_uri CHAR(22) NOT NULL,
    -- identifier for the playlist, set length of 22 characters
    playlist_uri CHAR(22) NOT NULL,
    -- name of the track, varying length up to 250 characters
    track_name VARCHAR(250) NOT NULL,
    -- identifier of the artist, set length of 22 characters
    artist_uri CHAR(22) NOT NULL,
    -- identifier of the album, set length of 22 characters
    album_uri CHAR(22) NOT NULL,
    -- duration of the track in milliseconds, stored as NUMERIC
    duration_ms NUMERIC(10, 0) NOT NULL,
    -- url for preview of the track, can be NULL, varying length up to
    -- 100 characters
    preview_url VARCHAR(100),
    -- tracks the popularity of the song as an int
    popularity INT NOT NULL,
    -- stores the time when a track was added, stored as TIMESTAMP
    added_at TIMESTAMP NOT NULL,
    -- stores who added a track, can be NULL, varying length up to 50 
    -- characters
    added_by VARCHAR(50),
    PRIMARY KEY (track_uri, playlist_uri),
    FOREIGN KEY (artist_uri)
        REFERENCES artists(artist_uri)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (album_uri)
        REFERENCES albums(album_uri)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (playlist_uri)
        REFERENCES playlists(playlist_uri)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);