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


  def self.delete_all()
    sql = 'DELETE FROM albums'
    Sqlrunner.run(sql)
  end

end
