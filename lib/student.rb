require 'pry'
class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    new_student = Student.new
    new_student.id=row[0]
    new_student.name=row[1]
    new_student.grade=row[2]
    new_student
  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
  end

  def self.find_by_name(name)
    sql = "SELECT * FROM students WHERE name = ? LIMIT 1"
     row = DB[:conn].execute(sql, name)
     new_student = self.new_from_db(row[0])
  end

  def self.count_all_students_in_grade_9
    sql = "SELECT COUNT(id) FROM students WHERE grade = '9th'"
    DB[:conn].execute(sql)
  end

  def self.students_below_12th_grade
    sql = "SELECT * FROM students WHERE grade < 12"
    DB[:conn].execute(sql)
  end

  def self.all
    sql = "SELECT * FROM students"
    rows = DB[:conn].execute(sql)

    rows.map do |student_row|
      self.new_from_db(student_row)
    end
  end

  def self.first_x_students_in_grade_10(num)
    sql = "SELECT * FROM students WHERE grade = 10 LIMIT ?"
    rows = DB[:conn].execute(sql, num)

    rows.map do |student_array|
      self.new_from_db(student_array)
    end
  end


  def self.first_student_in_grade_10
    sql = "SELECT * FROM students WHERE grade = 10 LIMIT 1"
    row = DB[:conn].execute(sql)
    self.new_from_db(row[0])
  end

  def self.all_students_in_grade_X(grade)
    sql = "SELECT * FROM students WHERE grade = ?"
    rows = DB[:conn].execute(sql, grade)

    rows.map do |student_array|
      self.new_from_db(student_array)
    end
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
