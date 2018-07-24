require 'pry'

class Dog
  attr_accessor :name, :breed, :id

  def initialize (name:, breed:, id:nil)
    @name = name
    @breed = breed
    @id = id
  end

  def self.create_table
    sql = "CREATE TABLE IF NOT EXISTS dogs (id INTEGER PRIMARY KEY, name TEXT, breed TEXT)"
    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE dogs"
    DB[:conn].execute(sql)
  end

  def save
    #returns an instance of the dog class, probably wants a Ruby object
    if self.id
      self.update
    else
      sql = <<-SQL
        INSERT INTO dogs (name, breed)
        VALUES (?, ?)
      SQL

      DB[:conn].execute(sql, self.name, self.breed)
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs")[0][0]
    end
    self
  end

  def self.create(name:, breed:)
    dog = Dog.new(name: name, breed: breed)
    dog.save
    dog
  end

  def self.find_by_id(id)
    sql = <<-SQL
      SELECT *
      FROM dogs
      WHERE id = ?
      SQL

      dog_array = DB[:conn].execute(sql, id)[0]
      dog = self.create(name: dog_array[1], breed: dog_array[2])
      dog.id = dog_array[0]
      dog
    end

    def self.find_or_create_by(name:, breed:)
      sql = "SELECT * FROM dogs WHERE name = ? AND breed = ?"
      dog = DB[:conn].execute(sql, name, album)
      if !dog.empty?

      else
        dog.create(name: name, breed: breed)
    end


end
