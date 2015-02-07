class CreateGroupsQuestionsJoinTable < ActiveRecord::Migration
  def change
    create_join_table :groups, :questions, id: false do |t|
    	t.integer :group_id
    	t.integer :question_id
    end

    add_index :groups_questions, :group_id
    add_index :groups_questions, :question_id
  end
end
