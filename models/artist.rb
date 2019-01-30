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

  def self.delete_all()
    sql = 'DELETE FROM artists'
    Sqlrunner.run(sql)
  end




end
