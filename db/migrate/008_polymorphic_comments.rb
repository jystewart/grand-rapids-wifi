class PolymorphicComments < ActiveRecord::Migration
  def self.up
    add_column :comments, :commentable_type, :string
    add_column :comments, :commentable_id, :integer
    comments = Comment.find(:all)
    for comment in comments
      comment.commentable_id = comment.resource_id
      comment.commentable_type = 'News' if comment.type == 'NewsComment'
      comment.commentable_type = 'Location' if comment.type == 'LocationComment'
      comment.save
    end
    remove_column :comments, :type
    remove_column :comments, :resource_id
  end

  def self.down
    add_column :comments, :type, :string
    add_column :comments, :resource_id, :integer
    for comment in comments
      comment.resource_id = comment.commentable_id
      comment.type == 'NewsComment' if comment.commentable_type = 'News'
      comment.type == 'LocationComment' if comment.commentable_type = 'Location' 
      comment.save
    end
    remove_column :comments, :commentable_type
    remove_column :comments, :commentable_id
  end
end
