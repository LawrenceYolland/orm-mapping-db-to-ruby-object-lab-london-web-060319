class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    # create a new Student object given a row from the database
    new_student = Student.new
    new_student.id, new_student.name, new_student.grade = row[0], row[1], row[2]
    new_student
  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    sql = <<-SQL
    SELECT *
    FROM students
    SQL
    DB[:conn].execute(sql).collect { |row| self.new_from_db(row)}
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    sql = <<-SQL
    select *
    from students
    where name = ?
    limit 1
    SQL
    DB[:conn].execute(sql, name).collect { |row| self.new_from_db(row)}.first
  end
  
  def self.all_students_in_grade_9
    sql = <<-SQL
    select *
    from students
    where grade = 9
    SQL
    DB[:conn].execute(sql).collect { |row| self.new_from_db(row)}
  end

  def self.students_below_12th_grade
    sql = <<-SQL
    select *
    from students
    where grade < 12
    SQL
    DB[:conn].execute(sql).collect { |row| self.new_from_db(row)}
  end

  def self.first_X_students_in_grade_10(number)
    sql = <<-SQL
    select * 
    from students
    where grade = 10
    order by students.id
    limit ?
    SQL
    DB[:conn].execute(sql,number).collect { |row| self.new_from_db(row)}
  end

  def self.first_student_in_grade_10
    sql = <<-SQL
    select * 
    from students
    where grade = 10
    order by students.id
    limit 1
    SQL
    DB[:conn].execute(sql).collect { |row| self.new_from_db(row)}.first
  end

  def self.all_students_in_grade_X(grade)
    sql = <<-SQL
    select * 
    from students
    where grade = ?
    order by students.id
    SQL
    DB[:conn].execute(sql,grade).collect { |row| self.new_from_db(row)}
  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade) 
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
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
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end
end
