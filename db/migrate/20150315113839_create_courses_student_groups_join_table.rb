class CreateCoursesStudentGroupsJoinTable < ActiveRecord::Migration
  def change
    create_join_table :courses, :student_groups, id: false do |t|
    	t.integer :course_id
    	t.integer :student_group_id
      # t.index [:course_id, :student_group_id]
      # t.index [:student_group_id, :course_id]
    end

    add_index :courses_student_groups, :course_id 
    add_index :courses_student_groups, :student_group_id
  end
end
