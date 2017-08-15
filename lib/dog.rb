class Dog
  attr_accessor :name, :breed, :id

  def initialize(name:, breed:, id: nil)
    @name = name
    @breed = breed
    @id = id
  end

  def self.create_table
    sql = "CREATE TABLE IF NOT EXISTS dogs(
    @
    )"
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS dogs;"
    DB[:conn].execute(sql)
  end

  def save
    sql = "INSERT INTO dogs (name, breed) VALUES (?, ?)"
    DB[:conn].execute(sql, self.name, self.breed)
    result = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs;")
    @id = result.flatten.first
    self
  end

  def self.create(attributes)
    dog = Dog.new(attributes)
    dog.save
  end

  def self.find_by_id(uniq_id)
    sql = "SELECT * FROM dogs WHERE id = ? LIMIT 1"
    result = DB[:conn].execute(sql, uniq_id).flatten
    dog = Dog.new(id: result[0], name: result[1], breed: result[2])
  end

  def self.new_from_db(array)
    dog = Dog.new(id: array[0], name: array[1], breed: array[2])
  end

  def self.find_by_name(new_name)
    sql = "SELECT * FROM dogs WHERE name = ? LIMIT 1"
    result = DB[:conn].execute(sql, new_name).flatten
    dog = Dog.new(id: result[0], name: result[1], breed: result[2])
  end

  def update
    sql = "UPDATE dogs SET name = ?, breed = ? WHERE id = ?"
    DB[:conn].execute(sql, self.name, self.breed, self.id)
  end

  def self.find_or_create_by(dog_hash)
    sql = " SELECT * FROM dogs WHERE name = ? AND breed = ? LIMIT 1"
    result = DB[:conn].execute(sql, dog_hash[:name], dog_hash[:breed]).flatten
    result.first ? Dog.new(id: result[0], name: result[1], breed: result[2]) : self.create(dog_hash)
  end

end
