class Student

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]  
  attr_accessor :name, :grade
  attr_reader :id

  def initialize(name, grade, id = nil)
  	@name = name
  	@grade = grade
  	@id = id
  end

  def self.create_table
  	sql = <<-SQL
  		CREATE TABLE IF NOT EXISTS students (
			id INTEGER PRIMARY KEY,
			name TEXT,
			grade TEXT
  		)
  		SQL
  	DB[:conn].execute(sql)
  end

  def self.drop_table
  	DB[:conn].execute("DROP TABLE IF EXISTS students")
  end

  def self.create(attr_hash)
  	self.new(attr_hash[:name], attr_hash[:grade]).tap{ |student| student.save }
  end

  def save
  	sql = <<-SQL
  		INSERT INTO students (name, grade) VALUES (?, ?)
  		SQL
  	DB[:conn].execute(sql, self.name, self.grade)
  	@id = DB[:conn].execute("SELECT id FROM students ORDER BY id DESC LIMIT 1").flatten[0]
  end
  
end
