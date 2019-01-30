require('pg')
require_relative('../db/sqlrunner')
require_relative('artist')
require('pry')


class Album

  attr_accessor :title, :genre, :artist_id
  attr_reader :id

  def initialize(album)
    @id = album['id'].to_i if album['id']
    @title = album['title']
    @genre = album['genre']
    @artist_id = album['artist_id'].to_i
  end

  def artist
    sql = "SELECT FROM artists WHERE id = $1"
    values = [@artist_id]
    result = Sqlrunner.run(sql, values)
    # binding.pry
    artist_data = result[0]
    return  Artist.new(artist_data)
  end

  def save
    sql = "INSERT INTO albums (title, genre) VALUES ($1, $2) RETURNING *"
    values = [@title, @genre]
    result = Sqlrunner.run(sql, values)
    @id = result[0]["id"].to_i
  end

  def update()
    sql = "UPDATE albums SET title = $1 WHERE id = $2"
    values = [@title, @id]
    Sqlrunner.run(sql, values)
  end

  def delete()
    sql = "DELETE FROM albums WHERE id = $1"
    values = [@id]
    Sqlrunner.run(sql, values)
  end

  def self.find(id)
    sql = "SELECT * FROM albums WHERE id = $1"
    values = [id]
    results = Sqlrunner.run(sql, values)
    album_hash = results.first
    album = Album.new(album_hash)
    return album
  end

  def self.all()
    sql = "SELECT * FROM albums"
    album = Sqlrunner.run(sql)
    return album.map { |album| Album.new(album) }
  end

  def self.delete_all()
    sql = 'DELETE FROM albums'
    Sqlrunner.run(sql)
  end

end
