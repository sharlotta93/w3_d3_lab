require('pg')
require_relative('../db/sqlrunner')
require_relative('album')


class Artist

  attr_accessor :name, :id


  def initialize(artist)
    @id = artist['id'].to_i if artist['id']
    @name = artist['name']
  end

  def albums
    sql = "SELECT FROM albums WHERE id = $1"
    values = [@id]
    result = Sqlrunner.run(sql, values)
    return result.map { |album| Album.new(album)}
  end

  def save
    sql = "INSERT INTO artists (name) VALUES ($1) RETURNING *"
    values = [@name]
    result = Sqlrunner.run(sql, values)
    @id = result[0]["id"].to_i
  end

  def update()
    sql = "UPDATE artists SET name = $1 WHERE id = $2"
    values = [@name, @id]
    Sqlrunner.run(sql, values)
  end

  def delete()
    sql = "DELETE FROM artists WHERE id = $1"
    values = [@id]
    Sqlrunner.run(sql, values)
  end

  def self.find(id)
    sql = "SELECT * FROM artists WHERE id = $1"
    values = [id]
    results = Sqlrunner.run(sql, values)
    artist_hash = results.first
    artist = Artist.new(artist_hash)
    return artist
  end

  def self.all()
    sql = "SELECT * FROM artists"
    artist = Sqlrunner.run(sql)
    return artist.map { |artist| Artist.new(artist) }
  end

  def self.delete_all()
    sql = 'DELETE FROM artists'
    Sqlrunner.run(sql)
  end




end
